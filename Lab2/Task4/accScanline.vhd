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
-- The description of the accelerator.
--------------------------------------------------------------------------------

ARCHITECTURE structure OF acc IS
	-- Image dimension (width must be a even number)
	constant img_width	: natural := 352;
	constant img_height	: natural := 288;
	constant width_step	: natural := img_width/2;
	constant two_width_step : natural := 2 * width_step;
	constant last_addr	: natural := width_step * img_height;
	-- start address of processed image in memory
	constant mem_start  : natural := width_step * img_height;
	constant mem_latency: natural := 0;
	constant outputBuffer_lag : natural := 3;
	
	-- Declare the state type.
	type StateType is (idle, startRow, readData, writeData, doneImg);  
	-- Declare a type that can hold the cached pixel data.	
	subtype RowCache_t is std_logic_vector( 5*8 - 1 downto 0);
	type PixCache_t is array (2 downto 0) of RowCache_t; -- 3 rows of 5 pixels cache.
	
	-- Declare signals
	signal state, state_next : StateType; -- Two signals to hold the states of the FSM.
	signal addr_reg, addr_next : word_t;			-- Address being processed. 
	signal addr_row_reg, addr_row_next: word_t;		-- Address to start of current row (scan line).	
	signal dataR_reg, dataR_next: halfword_t;
	signal rw_int : std_logic;	-- internal signal (wired to rw)
	signal latencyCount_reg, latencyCount_next : unsigned(2 downto 0);
	
	signal col_reg, col_next	: unsigned(7 downto 0);
	signal a_wr, b_wr, out_wr	: std_logic;
	signal a_addr, b_addr		: unsigned(8 downto 0);
	signal out_addr				: unsigned(7 downto 0);
	signal scan0ptr_reg, scan0ptr_next, scan1ptr_reg, scan1ptr_next : unsigned(8 downto 0);
	signal a_din, b_din, out_din	: halfword_t;
	signal a_dout, b_dout, out_dout	: halfword_t;
	signal a_dout_reg, b_dout_reg	: halfword_t;
	signal mode_reg, mode_next		: std_logic;
	
	-- Signals used for sobel filter calculation.
	-- maximum range is [-4*255; 4*255] = [-1020,1020]	
	signal gxA_1, gxA_2, gxB_1, gxB_2, gyA_1, gyA_2, gyB_1, gyB_2: signed(10 downto 0);
	signal gxA, gxB, gyA, gyB: signed(10 downto 0);
	signal sobelA, sobelB: unsigned(10 downto 0);	
	
	-- Signals used for border handling.
	signal firstRow, lastRow		: std_logic;	-- Signals to indicate the first and last scanLine.
	-- Pixel cache holds 15 x 8 bit pixels (organized in 3 rows of 5 pixels)	
	signal pix_reg, pix_next :PixCache_t;
	-- Declare convenient aliases into pixels cache.
	alias A1: byte_t is pix_reg(0)(7 downto 0); 
	alias A2: byte_t is pix_reg(0)(15 downto 8);
	alias A3: byte_t is pix_reg(0)(23 downto 16);
	alias A4: byte_t is pix_reg(1)(7 downto 0); 
	alias A5: byte_t is pix_reg(1)(15 downto 8);
	alias A6: byte_t is pix_reg(1)(23 downto 16);
	alias A7: byte_t is pix_reg(2)(7 downto 0); 
	alias A8: byte_t is pix_reg(2)(15 downto 8);
	alias A9: byte_t is pix_reg(2)(23 downto 16);	

	alias B1: byte_t is pix_reg(0)(15 downto 8); 
	alias B2: byte_t is pix_reg(0)(23 downto 16);
	alias B3: byte_t is pix_reg(0)(31 downto 24);
	alias B4: byte_t is pix_reg(1)(15 downto 8); 
	alias B5: byte_t is pix_reg(1)(23 downto 16);
	alias B6: byte_t is pix_reg(1)(31 downto 24);
	alias B7: byte_t is pix_reg(2)(15 downto 8); 
	alias B8: byte_t is pix_reg(2)(23 downto 16);
	alias B9: byte_t is pix_reg(2)(31 downto 24);

-- Declare block ram component
component bram_tdp is
generic (
    DATA_WIDTH    : integer;
    ADDR_WIDTH    : integer
);
port (
	clk   : in  std_logic;
-- Port A
    a_wr    : in  std_logic;
    a_addr  : in  unsigned(ADDR_WIDTH-1 downto 0);
    a_din   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    a_dout  : out std_logic_vector(DATA_WIDTH-1 downto 0);
-- Port B
    b_wr    : in  std_logic;
    b_addr  : in  unsigned(ADDR_WIDTH-1 downto 0);
    b_din   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    b_dout  : out std_logic_vector(DATA_WIDTH-1 downto 0)
);
end component bram_tdp;

begin

	-- Instantiate a block RAM component
	scanLineBuffer : bram_tdp
		generic map(
			DATA_WIDTH =>  16,
			ADDR_WIDTH => 9
		)
		port map (
			clk		=> clk,
			-- Port A
			a_wr	=> a_wr,
			a_addr	=> a_addr,
			a_din	=> a_din,
			a_dout	=> a_dout,
			-- Port B
			b_wr	=> b_wr,
			b_addr	=> b_addr,
			b_din	=> b_din,
			b_dout	=> b_dout
		);
	OutputBuffer : bram_tdp
		generic map(
			DATA_WIDTH =>  16,
			ADDR_WIDTH => 8
		)
		port map (
			clk		=> clk,
			-- Port A
			a_wr	=> out_wr,
			a_addr	=> out_addr,
			a_din	=> out_din,
			a_dout	=> out_dout,
			-- Port B
			b_wr	=> '0',
			b_addr	=> (others => '1'),
			b_din	=> (others=> '0'),
			b_dout	=> open
		);

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
	-- Assign address to either read or write address. Note that write address is lagging one scanline behind.
	addr <= addr_reg when rw_int = '1' else  std_logic_vector(unsigned(addr_reg) + (mem_start - width_step));	
	-- Generate signals to indicate the image borders.
	firstRow		<= '1' when unsigned(addr_row_reg) = 0 else '0';
	lastRow 		<= '1' when unsigned(addr_row_reg) = last_addr else '0';
	
	a_addr <= scan0ptr_reg; -- Don't used the registered signal (block ram address is already registered)
	b_addr <= scan1ptr_reg;
	
	FSMD: process(state, start, firstRow, lastRow, dataR, addr_reg, addr_row_reg, pix_reg
			,scan0ptr_reg, scan1ptr_reg, sobelA, sobelB, latencyCount_reg, addr_next, col_reg, out_dout)
	begin
		mode_next <= mode_reg;
		a_wr <= '0';
		b_wr <= '0';
		out_wr <= '0';
		col_next <= col_reg;
		
		a_din <= dataR;
		b_din <= dataR;
		out_din <= byte_t(sobelB(10 downto 3)) & byte_t(sobelA(10 downto 3)); -- Divide by 8.		
		
		scan0ptr_next <= scan0ptr_reg;
		scan1ptr_next <= scan1ptr_reg;
		-- Default values
		state_next <= state;
		finish <= '0';
		rw_int <= '1';	-- read mode
		req <= '1'; -- request memory interface.
		latencyCount_next <= (others =>'0');
		dataR_next <= dataR_reg;
		
		addr_next <= addr_reg;
		addr_row_next <= addr_row_reg;
		pix_next <= pix_reg;
				
		case state is
			when idle =>
				req <= '0'; -- release memory request
				addr_row_next <= (others => '0');
				if start = '1' then
					state_next <= startRow;
				end if;
				scan0ptr_next <= (others => '0');
				scan1ptr_next <= to_unsigned(width_step, scan1ptr_next'length);
				mode_next <= '0'; -- Read mode
			when startRow =>
				state_next <= startRow;
				if lastRow = '1'  and mode_reg = '0'then
					addr_next <= std_logic_vector(unsigned(addr_row_reg) - width_step);
				else
					addr_next <= addr_row_reg; -- Set addr to start of row
				end if; 
				latencyCount_next <= latencyCount_reg + 1;
				if latencyCount_reg = mem_latency then
					if mode_reg = '0' then 
						state_next <= readData;
					else
						state_next <= writeData;
					end if;
				end if;				
				col_next <= (others => '0'); -- reset the column counter
				 -- Set out_addr to ensure the value is ready when entering writeData state.
				out_addr <= (others => '0');
				
			when readData =>
				dataR_next <= dataR;
				col_next <=  col_reg + 1; -- Increment the column counter.
				if col_reg < to_unsigned(width_step, col_reg'length) then
					a_wr <= '1';
					if firstRow = '1' then
						b_wr <= '1';
					end if;
					-- Increment scanline pointers
					scan0ptr_next <= scan0ptr_reg + 1;
					scan1ptr_next <= scan1ptr_reg + 1;
					-- Move to next memory location.
					addr_next <= std_logic_vector(unsigned(addr_reg) + 1);
				end if; 
				if  firstRow /= '1' and col_reg > (outputBuffer_lag - 1) then -- Output pointer is lagging behind the scanline buffers.
					-- Write result of Sobel filter.
					out_wr <= '1';
					out_addr <= col_reg - outputBuffer_lag; -- Set pointer to output buffer.
				end if;

				-- Roll the pixel cache two pixels
				pix_next(0)(23 downto 0) <= pix_reg(0)(39 downto 16);
				pix_next(1)(23 downto 0) <= pix_reg(1)(39 downto 16);
				pix_next(2)(23 downto 0) <= pix_reg(2)(39 downto 16);
										
				-- Update sliding window with new samples.
				pix_next(0)(39 downto 24)  <= a_dout;
				pix_next(1)(39 downto 24)  <= b_dout;
				pix_next(2)(39 downto 24)  <= dataR_reg;
				
				-- Handle the left border.
				if col_reg = 1 then
					pix_next(0)(23 downto 16) <= a_dout(7 downto 0);
					pix_next(1)(23 downto 16) <= b_dout(7 downto 0);
					pix_next(2)(23 downto 16) <= dataR_reg(7 downto 0);
				end if;
				
				-- Handle the right border.
				if col_reg = (width_step + 1) then
					pix_next(0)(31 downto 24) <= pix_reg(0)(39 downto 32);
					pix_next(1)(31 downto 24) <= pix_reg(1)(39 downto 32);
					pix_next(2)(31 downto 24) <= pix_reg(2)(39 downto 32);
				end if;								
				
				-- Check for end of row
				if col_reg < to_unsigned(width_step  + outputBuffer_lag, col_reg'length) then
					state_next <= readData;
				else
					state_next <= startRow;
					mode_next <= '1'; -- Continue to write mode.
				end if;

			when writeData =>
				-- Check for end of row
				if firstRow /= '1' AND col_reg < to_unsigned(width_step, col_reg'length) then
					rw_int <= '0'; -- Write mode
					col_next <=  col_reg + 1; -- Increment the column counter.
					out_addr <= col_next; -- Set pointer to output buffer.
					dataW <= out_dout; 
					-- Move to next memory location.
					addr_next <= std_logic_vector(unsigned(addr_reg) + 1);
					state_next <= writeData;
				else
					if lastRow = '1' then
						state_next <= doneImg;
					else
						state_next <= startRow;
					end if;
					mode_next <= '0'; -- Continue to read mode.	
					-- Move to next row 
					addr_row_next <= std_logic_vector(unsigned(addr_row_reg) + width_step);	
					-- Check for scan pointer roll over.
					if scan0ptr_reg > to_unsigned(two_width_step -1, scan0ptr_reg'length) then
						scan0ptr_next <= (others => '0');
					end if;						
					if scan1ptr_reg > to_unsigned(two_width_step -1, scan1ptr_reg'length) then
						scan1ptr_next <= (others => '0');
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
			mode_reg <= mode_next;
			scan0ptr_reg <= scan0ptr_next;
			scan1ptr_reg <= scan1ptr_next;
			latencyCount_reg <= latencyCount_next;
			
			col_reg <= col_next;
			addr_reg <= addr_next;
			addr_row_reg <= addr_row_next;
			pix_reg <= pix_next;
			dataR_reg <= dataR_next;
			
			a_dout_reg <= a_dout;
			b_dout_reg <= b_dout;
		end if;
	end process registerTransfer;
	

	-- Combinatorial logic 
	-- Calculate the Sobel filter on the sliding window.
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
