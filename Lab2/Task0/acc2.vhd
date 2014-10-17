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
    PORT (clk :       IN    bit_t;            -- The clock.
          reset:      IN    bit_t;            -- The reset signal. Active low.
          addr:       OUT   word_t;           -- Address bus for data.
          dataR:       IN halfword_t;           -- The data bus.
          dataW:       OUT halfword_t;           -- The data bus.
          req:        OUT   bit_t;            -- Request signal for data.
          rw:         OUT   bit_t;            -- Read/Write signal for data.
          start:      IN    bit_t;
          finish:     OUT    bit_t);
END acc;

--------------------------------------------------------------------------------
-- The desription of the accelerator.
--------------------------------------------------------------------------------

ARCHITECTURE structure OF acc IS

	-- All internal signals are defined here
	TYPE StateType IS (idle, prepareRead, readPix, prepareWrite, writePix, doneImg);  

	-- Two signals to hold states.
	SIGNAL state, state_next: StateType;
	signal addr_reg, addr_next, addr_write: word_t;	
	signal pixVal_reg, pixVal_next: halfword_t;
	signal rw_int: std_logic;
	constant img_width	: natural := 352;
   constant img_height	: natural := 288;
	constant last_addr: natural := img_width/2 * img_height - 1;
   -- start address of processed image in memory
   constant mem_start  : natural := img_width/2*img_height;
BEGIN
	rw <= rw_int;
	addr <= addr_reg when rw_int = '1' else  std_logic_vector(unsigned(addr_reg) + mem_start);

	FSMD: process(state,start)	
	begin
		-- Default values
		finish <= '0';
		state_next <= state;
		rw_int <= '1';
		req <= '0';
		addr_next <= addr_reg;
		dataW <= not pixVal_reg;
		pixVal_next <= pixVal_reg; 
		
		case state is			
			when idle =>
			
				addr_next <= (others => '0');
				if start = '1' then
					state_next <= prepareRead;
				end if;
				
			when prepareRead =>
				state_next <= readPix;
				rw_int <= '1'; -- Read mode.
				req <= '1'; -- Request memory transaction.
				
			when readPix =>
				pixVal_next <= dataR;
				state_next <= prepareWrite;
				
			when prepareWrite =>
				state_next <= writePix;
				rw_int <= '0'; -- write mode.
				req <= '1'; -- Request memory transaction.	
				
			when writePix =>			
				if unsigned(addr_reg) = last_addr then
					state_next <= doneImg;
				else
					state_next <= prepareRead;
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
			pixVal_reg <= pixVal_next;
		end if;
	end process registerTransfer;

END structure;



