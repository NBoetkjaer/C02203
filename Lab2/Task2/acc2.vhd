-- -----------------------------------------------------------------------------
--
--  Title      :  Edge-Detection design project
--             :
--  Developers :  Anders Greve(s073188) and Nicolas Bøtkjær (s918819) 
--             :
--  Purpose    :  This design contains an implementation for the accelerator that performs 
--             :  a Sobel filtering of an image. The design is using a sliding window
--             :  in order to reduce the required memory transactions.
--             :  It is based on the architecture skeleton developed by
--             :  Jonas Benjamin Borch - s052435@student.dtu.dk
--             :
--             :
--  Revision   :  1.0    7-10-08     Final version
--             :  1.1    8-10-09     Split data line to dataR and dataW
--             :                     Edgar <s081553@student.dtu.dk>
--             :  1.2   12-10-11     Changed from std_loigc_arith to numeric_std
--             :  
--  Special    :
--  thanks to  :  Niels Haandbæk -- c958307@student.dtu.dk
--             :  Michael Kristensen -- c973396@student.dtu.dk
--
-- -----------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE WORK.types.ALL;

ENTITY acc IS  
    PORT (clk :		IN	bit_t;	-- The clock.
          reset:	IN	bit_t;	-- The reset signal. Active low.
          addr:		OUT	word_t;	-- Address bus for data.
          dataR:	IN	halfword_t;	-- The data bus.
          dataW:	OUT	halfword_t;	-- The data bus.
          req:		OUT	bit_t;	-- Request signal for data.
          rw:		OUT	bit_t;	-- Read/Write signal for data.
          start:	IN	bit_t;	-- Start signal from 'CPU'
          finish:	OUT	bit_t);	-- Done with Sobel filtering. 
END acc;

--------------------------------------------------------------------------------
-- The description of the accelerator.
--------------------------------------------------------------------------------
ARCHITECTURE structure OF acc IS
	-- Image dimension
	constant img_width	: natural := 352; -- Width must be an even number. 
	constant img_height	: natural := 288;
	constant width_step	: natural := img_width/2; -- Number of memory locations for one image row.
	-- last_addr is a memory address that is one past the last source pixel.
	constant last_addr	: natural := width_step * img_height; 
	-- Address of first pixel in destination image.
	constant mem_start  : natural := width_step * img_height; 
	
	-- Declare the state type.
	type StateType is (idle, startRow, readSetup, readCenter, readAbove, readBelow, calculateFilter, writeData, doneImg);  
	-- Declare a type that can hold the pixel data of the sliding window.
	subtype RowCache_t is std_logic_vector( 5*8 - 1 downto 0);
	type PixCache_t is array (2 downto 0) of RowCache_t; -- 3 rows of 5 pixels cache.
	
	-- Declare signals
	signal state, state_next : StateType; -- Two signals to hold the states of the FSM.
	signal addr_reg, addr_next : word_t;			-- Address being processed. 
	signal addr_row_reg, addr_row_next: word_t;		-- Address to start of current row (scan line).
	signal addr_read_reg, addr_read_next: word_t;	-- Current read address.
	signal dataW_reg, dataW_next: halfword_t;	-- Register that will hold the output pixel pair (Sobel result).
	signal rw_int : std_logic;	-- internal signal (wired to rw)
	
	-- Signals used for sobel filter calculation.
	-- maximum range is [-4*255; 4*255] = [-1020,1020]	
	signal gxA_1, gxA_2, gxB_1, gxB_2, gyA_1, gyA_2, gyB_1, gyB_2: signed(10 downto 0);
	signal gxA, gxB, gyA, gyB: signed(10 downto 0);
	signal sobelA, sobelB: unsigned(10 downto 0);	
	
	-- Signals used for border handling.
	signal firstRow, lastRow		: std_logic;	-- Signals to indicate the first and last scanLine.
	signal firstColumnR	: std_logic;				-- Signal to indicate if read addr. is on the first column.
	signal firstColumnW, lastColumnW: std_logic;	-- Signals to indicate if the write addr. is on first and last column.
	-- Pixel cache holds 15 x 8 bit pixels (organized in 3 rows of 5 pixels)	
	signal pix_reg, pix_next :PixCache_t;	
	-- Declare convenient aliases into pixels cache.
	alias A1: byte_t is pix_reg(0)(7 downto 0);    --   Kernel A
	alias A2: byte_t is pix_reg(0)(15 downto 8);   -- | A1 A2 A3 |
	alias A3: byte_t is pix_reg(0)(23 downto 16);  -- | A4 A5 A6 |
	alias A4: byte_t is pix_reg(1)(7 downto 0);    -- | A7 A8 A9 |
	alias A5: byte_t is pix_reg(1)(15 downto 8);
	alias A6: byte_t is pix_reg(1)(23 downto 16);
	alias A7: byte_t is pix_reg(2)(7 downto 0); 
	alias A8: byte_t is pix_reg(2)(15 downto 8);
	alias A9: byte_t is pix_reg(2)(23 downto 16);	
	
	alias B1: byte_t is pix_reg(0)(15 downto 8);   --   Kernel B
	alias B2: byte_t is pix_reg(0)(23 downto 16);  -- | B1 B2 B3 |
	alias B3: byte_t is pix_reg(0)(31 downto 24);  -- | B4 B5 B6 |
	alias B4: byte_t is pix_reg(1)(15 downto 8);   -- | B7 B8 B9 |
	alias B5: byte_t is pix_reg(1)(23 downto 16);
	alias B6: byte_t is pix_reg(1)(31 downto 24);
	alias B7: byte_t is pix_reg(2)(15 downto 8); 
	alias B8: byte_t is pix_reg(2)(23 downto 16);
	alias B9: byte_t is pix_reg(2)(31 downto 24);

begin
	-----------------------------
	-- Overview of algorithm flow.
	-- Show how the pixels are access pairwise.
	--   0 1 2 3	: Memory address.
	--  xABCDEFGHx	: Image (width must be even) A-H is pixels x is the border.
	--  AABCD		: step (1)	: read addr. 0 and 1 (first column).
	--   AB			: 			: write addr. 0 + offset.
	--    BCDEF  	: step (2)	: read addr. 2.
	--     CD		: 			: write addr. 1 + offset
	-- 				: ....
	--  	DEFGH	: step (n-1): read addr. (n-1).
	--  	 EF		: 			: write addr. (n-1) - 1 + offset
	--  	  FGHH#	: step (n)	: no read (last column) (# = don't care)
	--  	   GH	: 			: write addr. n - 1 + offset
	-----------------------------

	rw <= rw_int; -- Wire internal signal to entity out port .
	-- Assign address to either read or write address. Note that write address is lagging one behind.
	addr <= addr_read_reg when rw_int = '1' else  std_logic_vector(unsigned(addr_reg) + mem_start -  1);	
	dataW <= dataW_reg;
	-- Generate signals to indicate the image borders.
	firstRow		<= '1' when unsigned(addr_row_reg) = 0 else '0';
	lastRow 		<= '1' when unsigned(addr_row_reg) = (last_addr - width_step) else '0';
	firstColumnR 	<= '1' when addr_reg = addr_row_reg else '0';
	firstColumnW	<= '1' when addr_reg = std_logic_vector(unsigned(addr_row_reg) + 1) else '0';
	LastColumnW 	<= '1' when addr_reg = std_logic_vector(unsigned(addr_row_reg) + (width_step)) else '0';
	
	FSMD: process(state, start, firstRow, lastRow, firstColumnR, firstColumnW, lastColumnW, dataR, dataW_reg, addr_reg, addr_read_reg, addr_row_reg, pix_reg, sobelA, sobelB)
	begin
		-- Default values
		state_next <= state;
		finish <= '0';
		rw_int <= '1';	-- read mode
		req <= '1'; -- request memory interface.
		dataW_next <= dataW_reg;
		
		addr_next <= addr_reg;
		addr_read_next <= addr_read_reg;		
		addr_row_next <= addr_row_reg;
		pix_next <= pix_reg;
		
		case state is			
			when idle =>		
				req <= '0'; -- release memory request
				addr_row_next <= (others => '0');
				if start = '1' then
					state_next <= startRow;
				end if;
				
			when startRow =>				
				req <= '0'; -- release memory request
				state_next <= readSetup;
				addr_next <= addr_row_reg; -- Set addr to start of row.				
				
			when readSetup =>
				if  LastColumnW = '1' then 
					-- When processing last column we should not read any data.
					state_next <= calculateFilter; 
				else
					state_next <= readCenter;
				end if;							
				-- Roll the pixel cache two pixels
				pix_next(0)(23 downto 0) <= pix_reg(0)(39 downto 16);
				pix_next(1)(23 downto 0) <= pix_reg(1)(39 downto 16);
				pix_next(2)(23 downto 0) <= pix_reg(2)(39 downto 16);
				-- Handle the left border.
				if firstColumnW = '1' then					
					pix_next(0)(7 downto 0) <= pix_reg(0)(31 downto 24);
					pix_next(1)(7 downto 0) <= pix_reg(1)(31 downto 24);
					pix_next(2)(7 downto 0) <= pix_reg(2)(31 downto 24); 								
				end if;
				-- Handle the right border.
				if lastColumnW = '1' then
					pix_next(0)(31 downto 24) <= pix_reg(0)(39 downto 32);
					pix_next(1)(31 downto 24) <= pix_reg(1)(39 downto 32);
					pix_next(2)(31 downto 24) <= pix_reg(2)(39 downto 32);
				end if;								
				-- prepare to read center position.
				addr_read_next <= addr_reg;					
				
			when readCenter =>
				state_next <= readAbove;
				-- Insert two new pixels into cache
				pix_next(1)(39 downto 24)  <= dataR;
				
				if firstRow = '0' then				
					-- prepare to read one row above the center position.
					addr_read_next <= std_logic_vector(unsigned(addr_reg) - width_step);
				else
					-- Handle top border, by reading center position again.
					addr_read_next <= addr_reg;
				end if;
				
			when readAbove =>
				state_next <= readBelow;
				-- Insert two new pixels into cache
				pix_next(0)(39 downto 24)  <= dataR;				
			
				if lastRow = '0' then 
					-- prepare to read one row below the center position.
					addr_read_next <= std_logic_vector(unsigned(addr_reg) + width_step);
				else
					-- Handle bottom border, by reading center position again.
					addr_read_next <= addr_reg;
				end if;									
				
			when readBelow =>
				state_next <= calculateFilter;
				-- Insert two new pixels into cache								
				pix_next(2)(39 downto 24)  <= dataR;
				
			when calculateFilter =>
				state_next <= writeData;					
				-- Divide by 8.
				dataW_next <= byte_t(sobelB(10 downto 3)) & byte_t(sobelA(10 downto 3));

			when writeData =>				
				if firstColumnR = '1'then
					state_next <= readSetup;
				else
					rw_int <= '0'; -- write mode.
				end if;		
				
				-- Check if image is done
				if lastRow = '1' and lastColumnW = '1' then  
					state_next <= doneImg;
				else
					-- Check for end of row
					if lastColumnW = '1' then
						state_next <= startRow;
						-- Move to next row 
						addr_row_next <= std_logic_vector(unsigned(addr_row_reg) + width_step);
					else
						state_next <= readSetup;
						-- Move to next memory location.					
						addr_next <= std_logic_vector(unsigned(addr_reg) + 1);
					end if;
				end if;
											
			when doneImg =>
				finish <= '1';
				req <= '0';	-- release memory request
				if start = '0' then
					state_next <= idle;
				end if;
		end case;		
	end process FSMD;
	
	
	registerTransfer: process(clk, reset)
	begin
		if reset = '1' then
			state <= idle;
		elsif rising_edge(clk) then
			state <= state_next;
			addr_reg <= addr_next;
			addr_read_reg <= addr_read_next;
			addr_row_reg <= addr_row_next;			
			pix_reg <= pix_next;
			dataW_reg <= dataW_next;
		end if;
	end process registerTransfer;
	

	-- Combinatorial logic 
	-- Calculate the Sobel filter on the sliding window.
	-- Two pixels are processed simultaneously.
	-- Gx = (a3 + 2*a6 + a9) - (a1 + 2*a4 + a7)
	gxA_1 <= signed('0' & (unsigned(A3) + unsigned('0' & A6 & '0') + unsigned(A9)));
	gxA_2 <= signed('0' & (unsigned(A1) + unsigned('0' & A4 & '0') + unsigned(A7)));
	gxA <= gxA_1 - gxA_2;
	
	gxB_1 <= signed('0' & (unsigned(B3) + unsigned('0' & B6 & '0') + unsigned(B9)));
	gxB_2 <= signed('0' & (unsigned(B1) + unsigned('0' & B4 & '0') + unsigned(B7)));
	gxB <= gxB_1 - gxB_2;	
	
	-- Gy = (a1 + 2*a2 + a3) - (a7 + 2*a8 + a9)				
	gyA_1 <= signed('0' & (unsigned(A1) + unsigned('0' & A2 & '0') + unsigned(A3)));
	gyA_2 <= signed('0' & (unsigned(A7) + unsigned('0' & A8 & '0') + unsigned(A9)));	
	gyA <= gyA_1 - gyA_2;
		
	gyB_1 <= signed('0' & (unsigned(B1) + unsigned('0' & B2 & '0') + unsigned(B3)));
	gyB_2 <= signed('0' & (unsigned(B7) + unsigned('0' & B8 & '0') + unsigned(B9)));	
	gyB <= gyB_1 - gyB_2;	
	
	-- Sobel = |Gx| + |Gy|
	sobelA <= unsigned(abs(gxA)) + unsigned(abs(gyA));
	sobelB <= unsigned(abs(gxB)) + unsigned(abs(gyB));	

end structure;

