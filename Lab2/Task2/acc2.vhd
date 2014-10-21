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
	constant last_addr	: natural := width_step * (img_height - 1);
	
	-- start address of processed image in memory
	constant mem_start  : natural := img_width/2*img_height;

	-- All internal signals are defined here
	TYPE StateType IS (idle, readData1, readData2, readData3, writeData, doneImg);  

	-- Declare signals
	signal state, state_next : StateType; -- Two signals to hold the states of the FSM.
	signal addr_reg, addr_next, addr_write: word_t; -- Address being processed. 
	signal addr_cur_reg, addr_cur_next: word_t;	-- Current read address.
	signal rw_int : std_logic;	-- internal signal (wired to rw)
	
	signal R1_1_reg, R1_1_next	: halfword_t;
	signal R1_2_reg, R1_2_next	: halfword_t;
	signal R2_1_reg, R2_1_next	: halfword_t;
	signal R2_2_reg, R2_2_next	: halfword_t;
	signal R3_1_reg, R3_1_next	: halfword_t;
	signal R3_2_reg, R3_2_next	: halfword_t;
	signal firstLine, lastLine	: std_logic;
	signal lineEnd				: std_logic;

BEGIN
	rw <= rw_int;
	addr <= addr_cur_reg when rw_int = '1' else  std_logic_vector(unsigned(addr_reg) + mem_start);

	firstLine <= '1' when unsigned(addr_reg) < width_step else '0';
	lastLine <= '1' when unsigned(addr_reg) > (last_addr - width_step);
	
	FSMD: process(state, start, firstLine, lastLine)
	begin
		-- Default values
		state_next <= state;
		finish <= '0';
		rw_int <= '1';
		req <= '0';
		dataW <= (others => '0');
		
		addr_next <= addr_reg;
		addr_cur_next <= addr_cur_reg;		
		
		case state is			
			when idle =>			
				addr_next <= (others => '0');
				addr_cur_next <= (others => '0');
				if start = '1' then
					state_next <= readData1;
				end if;
				
			when readData1 =>
				state_next <= readData2;			
				rw_int <= '1'; -- Read mode.
				req <= '1'; -- Request memory transaction.	
				addr_cur_next <= addr_reg;		
				
			when readData2 =>
				state_next <= readData3;
				rw_int <= '1'; -- Read mode.
				req <= '1'; -- Request memory transaction.	
			
				R1_1_next <= R1_2_reg;
				R1_2_next <= dataR;
				if firstLine = '0' then						
					addr_cur_next <= std_logic_vector(unsigned(addr_reg) - width_step);
				end if;					
				
			when readData3 =>
				state_next <= writeData;
				rw_int <= '1'; -- Read mode.
				req <= '1'; -- Request memory transaction.	

				R2_1_next <= R2_2_reg;
				R2_2_next <= dataR;
				if lastLine = '0' then 
					addr_cur_next <= std_logic_vector(unsigned(addr_reg) + width_step);
				else
					addr_cur_next <= addr_reg;
				end if;									
				
				
			when writeData =>
				R3_1_next <= R3_2_reg;
				R3_2_next <= dataR;				
				dataW <=  R1_2_reg( 7 downto 0) & R1_2_reg( 15 downto 8); -- Just a test swap pixels ... 0<->1, 2<->3, ...
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
			addr_cur_reg <= addr_cur_next;
			
			R1_1_reg <= R1_1_next;
			R1_2_reg <= R1_2_next;
			R2_1_reg <= R2_1_next;
			R2_2_reg <= R2_2_next;
			R3_1_reg <= R3_1_next;
			R3_2_reg <= R3_2_next;			
		end if;
	end process registerTransfer;

END structure;



