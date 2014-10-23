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
	type StateType is (idle, readSetup, readData1, readData2, readData3,  writeData, doneImg);  

	-- Declare a type that can hold the cached pixel data.
	type RowCache_t is array (5 downto 0) of halfword_t;
	signal pixelCache_reg,  pixelCache_next: RowCache_t;	
	-- Declare convenient aliases for kernel pixels 	
	---------------------------
	--    0       |       1    |
	-- A1 | A2/B1 | A3/B2 | B3 |
	----------------------------
	--    2       |       3    |
	-- A4 | A5/B4 | A6/B5 | B6 |
--------------------------------	
	--    4       |       5    |
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

	-- Declare signals
	signal state, state_next : StateType; -- Two signals to hold the states of the FSM.
	signal addr_reg, addr_next : word_t; -- Address being processed. 
	signal addr_read_reg, addr_read_next: word_t;	-- Current read address.
	signal rw_int : std_logic;	-- internal signal (wired to rw)
	
	signal firstLine, lastLine	: std_logic;
	signal firstRow, lastRow	: std_logic;

begin
	rw <= rw_int;
	addr <= addr_read_reg when rw_int = '1' else  std_logic_vector(unsigned(addr_reg) + mem_start);

	firstLine <= '1' when unsigned(addr_reg) < width_step else '0';
	lastLine <= '1' when unsigned(addr_reg) > (last_addr - width_step);
	
	FSMD: process(state, start, firstLine, lastLine, firstRow, lastRow, dataR, addr_reg, pixelCache_reg)
	begin
		-- Default values
		state_next <= state;
		finish <= '0';
		rw_int <= '1';
		req <= '0';
		dataW <= (others => '0');		

		pixelCache_next <= pixelCache_reg;
		addr_next <= addr_reg;
		addr_read_next <= addr_read_reg;		
		
		case state is			
			when idle =>			
				addr_next <= (others => '0');
				addr_read_next <= (others => '0');
				if start = '1' then
					state_next <= readData1;
				end if;
				
			when readSetup =>
				state_next <= readData1;			
				rw_int <= '1'; -- Read mode.
				req <= '1'; -- Request memory transaction.	
				addr_read_next <= addr_reg;		
				
			when readData1 =>
				state_next <= readData2;
				rw_int <= '1'; -- Read mode.
				req <= '1'; -- Request memory transaction.	
			
				pixelCache_next(0) <=  pixelCache_reg(1);
				pixelCache_next(1) <= dataR;
				if firstLine = '0' then						
					addr_read_next <= std_logic_vector(unsigned(addr_reg) - width_step);
				end if;					
				
			when readData2 =>
				state_next <= readData3;
				rw_int <= '1'; -- Read mode.
				req <= '1'; -- Request memory transaction.	

				pixelCache_next(2) <=  pixelCache_reg(3);
				pixelCache_next(3) <= dataR;
				if lastLine = '0' then 
					addr_read_next <= std_logic_vector(unsigned(addr_reg) + width_step);
				else
					addr_read_next <= addr_reg;
				end if;									
				
			when readData3 =>
				state_next <= writeData;
				rw_int <= '1'; -- Read mode.
				req <= '1'; -- Request memory transaction.	

				pixelCache_next(4) <=  pixelCache_reg(5);
				pixelCache_next(5) <= dataR;
				
				if firstRow then
					pixelCache_next(5) <= dataR(15 downto 8) & dataR(15 downto 8);
					pixelCache_next(3) <= pixelCache_reg(3)(15 downto 8) & pixelCache_reg(3)(15 downto 8);
					pixelCache_next(1) <= pixelCache_reg(1)(15 downto 8) & pixelCache_reg(1)(15 downto 8);					
				end if;
			
			when writeData =>				
				--dataW <=  pixelCache_reg(2)(7 downto 0) & pixelCache_reg(2)( 15 downto 8); -- Just a test swap pixels ... 0<->1, 2<->3, ...				
				--dataW <= B9 & B8;  
				dataW <= A9 & A8;  
				rw_int <= '0'; -- write mode.
				req <= '1'; -- Request memory transaction.

				-- ToDo handle end of line ...
				
				-- Check if image is done
				if unsigned(addr_reg) = last_addr then
					state_next <= doneImg;
				else
					state_next <= readData1;
				end if;
				-- Move to next memory location.					
				addr_next <= std_logic_vector(unsigned(addr_reg) + 1);				
											
			when doneImg =>
				finish <= '1';
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
			
			pixelCache_reg <= pixelCache_next;		
		end if;
	end process registerTransfer;

end structure;



