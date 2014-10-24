-- -----------------------------------------------------------------------------
--
--  Title      :  Edge-Detection design project - task 2.
--             :
--  Developers :  Jonas Benjamin Borch - s052435@student.dtu.dk
--             :
--  Purpose    :  This design contains an entity for the accelerator that must be build  
--             :  in task two of the Edge Detection design project. It contains an     
--             :  architecture skeleton for the entity as well.                
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

--------------------------------------------------------------------------------
-- The entity for task two. Notice the additional signals for the memory.        
-- reset is active low.
--------------------------------------------------------------------------------

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
          start:	IN	bit_t;
          finish:	OUT	bit_t);
END acc;

--------------------------------------------------------------------------------
-- The desription of the accelerator.
--------------------------------------------------------------------------------

ARCHITECTURE structure OF acc IS
	-- Image dimension (width must be a even number)
	constant img_width	: natural := 352;
	constant img_height	: natural := 288;
	constant width_step	: natural := img_width/2;
	constant last_addr	: natural := width_step * img_height;
	
	-- start address of processed image in memory
	constant mem_start  : natural := img_width/2*img_height;

	-- All internal signals are defined here
	type StateType is (idle, startRow, readSetup, readCenter, readAbove, readBelow,  writeData, doneImg);  

	-- Declare a type that can hold the cached pixel data.
	type RowCache_t is array (5 downto 0) of halfword_t;

	-- Declare signals
	signal state, state_next : StateType; -- Two signals to hold the states of the FSM.
	signal addr_reg, addr_next : word_t;			-- Address being processed. 
	signal addr_row_reg, addr_row_next: word_t;		-- Address to start of current row (scan line).
	signal addr_read_reg, addr_read_next: word_t;	-- Current read address.
	signal rw_int : std_logic;	-- internal signal (wired to rw)
	
	-- Accumulator register used to pipeline the gradient calculations
	-- maximum range is [-4*255; 4*255] = [-1020,1020]
	signal Gx_reg, Gx_next, Gy_reg, Gy_next: signed(10 downto 0); 
	-- Signals used for border handling.
	signal firstRow, lastRow		: std_logic;	-- Signals to indicate the first and last scanLine.
	signal firstColumn, lastColumn	: std_logic;	-- Signals to indicate the first and last column.
	-- Pixel cache holds 12 x 8 bit pixels (organized in 6 pixel pairs of each 16 bit )
	signal pixelCache_reg,  pixelCache_next: RowCache_t;	
	-- Declare convenient aliases for pixels.
	-- A1-9 and B1-9 represents a 3x3 neighborhood.
	----------------------------      A:
	--    0       |       1    |      A1 A2 A3
	-- A1 | A2/B1 | A3/B2 | B3 |      A4 A5 A6
	----------------------------      A7 A8 A9
	--    2       |       3    |      B: 
	-- A4 | A5/B4 | A6/B5 | B6 |      B1 B2 B3
--------------------------------	  B4 B5 B6
	--    4       |       5    |      B7 B8 B9
	-- A7 | A8/B7 | A9/B8 | B9 |
	----------------------------
	alias A1 : byte_t is pixelCache_reg(0)(7 downto 0);
	alias A2 : byte_t is pixelCache_reg(0)(15 downto 8);
	alias A3 : byte_t is pixelCache_reg(1)(7 downto 0);		
	alias A4 : byte_t is pixelCache_reg(2)(7 downto 0);
	alias A5 : byte_t is pixelCache_reg(2)(15 downto 8);
	alias A6 : byte_t is pixelCache_reg(3)(7 downto 0);
	alias A7 : byte_t is pixelCache_reg(4)(7 downto 0);
	alias A8 : byte_t is pixelCache_reg(4)(15 downto 8);
	alias A9 : byte_t is pixelCache_reg(5)(7 downto 0);

	alias B1 : byte_t is pixelCache_reg(0)(15 downto 8);
	alias B2 : byte_t is pixelCache_reg(1)(7 downto 0);
	alias B3 : byte_t is pixelCache_reg(1)(15 downto 8);
	alias B4 : byte_t is pixelCache_reg(2)(15 downto 8);
	alias B5 : byte_t is pixelCache_reg(3)(7 downto 0);
	alias B6 : byte_t is pixelCache_reg(3)(15 downto 8);
	alias B7 : byte_t is pixelCache_reg(4)(15 downto 8);
	alias B8 : byte_t is pixelCache_reg(5)(7 downto 0);
	alias B9 : byte_t is pixelCache_reg(5)(15 downto 8);

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
	--  	   GHH#	: step (n)	: no read (last column) (# = don't care)
	--  	   GH	: 			: write addr. n - 1 + offset
	-----------------------------

	rw <= rw_int; -- Wire internal signal to entity out port .
	-- Assign address to either read or write address.
	addr <= addr_read_reg when rw_int = '1' else  std_logic_vector(unsigned(addr_reg) + mem_start);
	-- Generate signals to indicate the image borders.
	firstRow <= '1' when unsigned(addr_reg) < width_step else '0';
	lastRow <= '1' when unsigned(addr_reg) > (last_addr - width_step) else '0';
	firstColumn <= '1' when addr_reg = addr_row_reg else '0';
	LastColumn <= '1' when addr_reg = std_logic_vector(unsigned(addr_row_reg) + (width_step - 1)) else '0';
	
	FSMD: process(state, start, firstRow, lastRow, firstColumn, lastColumn, dataR, addr_reg, addr_row_reg, pixelCache_reg)
	begin
		-- Default values
		state_next <= state;
		finish <= '0';
		rw_int <= '1';	-- read mode
		req <= '1'; -- request memory interface.
		dataW <= (others => '0');		

		pixelCache_next <= pixelCache_reg;
		addr_next <= addr_reg;
		addr_read_next <= addr_read_reg;		
		addr_row_next <= addr_row_reg;
		Gx_next <= Gx_reg;
		Gy_next <= Gy_reg;
		
		case state is			
			when idle =>		
				req <= '0'; -- release memory request
				addr_next <= (others => '0');
				addr_read_next <= (others => '0');
				if start = '1' then
					state_next <= startRow;
				end if;
			when startRow =>				
				state_next <= readSetup;
				addr_row_next <= addr_reg;	-- Save start address of current row to register.
				
			when readSetup =>
				state_next <= readCenter;			
				rw_int <= '1'; -- Read mode.
				-- prepare to read center position.
				addr_read_next <= addr_reg;	
				-- Reset the accumulators.
				Gx_next <= (others => '0');
				Gy_next <= (others => '0');
				
			when readCenter =>
				state_next <= readAbove;
				rw_int <= '1'; -- Read mode.
				pixelCache_next(2) <=  pixelCache_reg(3);
				pixelCache_next(3) <= dataR;
				
				if firstRow = '0' then				
					-- prepare to read one row above the center position.
					addr_read_next <= std_logic_vector(unsigned(addr_reg) - width_step);
				else
					-- Handle top border, by reading center position again.
					addr_read_next <= addr_reg;
				end if;
				
			when readAbove =>
				state_next <= readBelow;
				rw_int <= '1'; -- Read mode.

				pixelCache_next(0) <=  pixelCache_reg(1);
				pixelCache_next(1) <= dataR;
				-- 2*a6 - 2*a4
				Gx_next <= signed('0' & std_logic_vector(signed('0' & A6) - signed('0' & A4)) & '0');
				
				if lastRow = '0' then 
					-- prepare to read one row below the center position.
					addr_read_next <= std_logic_vector(unsigned(addr_reg) + width_step);
				else
					-- Handle top border, by reading center position again.
					addr_read_next <= addr_reg;
				end if;									
				
			when readBelow =>
				state_next <= writeData;
				rw_int <= '1'; -- Read mode.	

				pixelCache_next(4) <=  pixelCache_reg(5);
				pixelCache_next(5) <= dataR;
				-- a1 + 2*a2 + a3
				--Gy_next <= signed( std_logic_vector(( "00" & A1) + ('0' & A2 & '0') + ( "00" & A3) ));
				-- a3 - a1
				Gx_next <= Gx_reg + signed('0' & std_logic_vector(signed('0' & A3) - signed('0' & A1)));
				
				if firstColumn = '1'then
					-- Handle left border.
					pixelCache_next(0) <= A3 & A3;
					pixelCache_next(2) <= A6 & A6; --pixelCache_reg(3)(7 downto 0) & pixelCache_reg(3)(15 downto 8);
					pixelCache_next(4) <= dataR(7 downto 0) & dataR(7 downto 0);
				end if;
				if lastColumn = '1'then
					-- ToDo not working yet ....
					-- Handle right border. -- 
					pixelCache_next(1) <= B2 & B2; --pixelCache_reg(0)(15 downto 8) & pixelCache_reg(1)(15 downto 8);
					pixelCache_next(3) <= B6 & B6; --pixelCache_reg(3)(15 downto 8) & pixelCache_reg(3)(15 downto 8);
					pixelCache_next(5) <= dataR(15 downto 8) & dataR(15 downto 8);
				end if;
			
			when writeData =>
				-- a7 + 2*a8 + a9
				--Gy_next <= Gy_reg - ...
				-- a9 - a7
				Gx_next <= Gx_reg + signed('0' & std_logic_vector(signed('0' & A9) - signed('0' & A7)));
			
				dataW <= A9 & A8;  
				dataW <= abs(Gx_reg) + (Gy_reg);
				rw_int <= '0'; -- write mode.
				
				-- Check if image is done
				if lastRow = '1' and lastColumn = '1' then  
					state_next <= doneImg;
				else
					-- Check for end of row
					if lastColumn = '1' then
						state_next <= startRow;
					else
						state_next <= readSetup;
					end if;
				end if;
				-- Move to next memory location.					
				addr_next <= std_logic_vector(unsigned(addr_reg) + 1);				
											
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
			pixelCache_reg <= pixelCache_next;	
			Gx_reg <= Gx_next;
			Gy_reg <= Gy_next;
		end if;
	end process registerTransfer;

end structure;



