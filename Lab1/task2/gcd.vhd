-- -----------------------------------------------------------------------------
--
--  Title      :  Finite state machine and datapath of the GCD
--             :
--  Developers :  Jens Sparsø and Rasmus Bo Sørensen          
-- 		       :
--  Purpose    :  This design is the FSM and Datapath of the Greatest Common Divisor 
--             :
--  Revision   :  02203 fall 2011 v.2
--              
-- -----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY gcd IS            
    PORT (clk:      IN std_logic;				-- The clock signal.
          reset:    IN std_logic;				-- Reset the module.
          req:      IN std_logic;				-- Start computation.
          AB:       IN unsigned(7 downto 0);	-- The two operands.
          ack:      OUT std_logic;				-- Computation is complete.
          C:        OUT unsigned(7 downto 0));	-- The result.  
END gcd;

architecture FSMD of gcd is

type state_type is ( InputA, LoadA, RegAdone, InputB, LoadB, CmpAB, UpdateA, UpdateB, DoneC ); -- Input your own state names
signal reg_a,next_reg_a,next_reg_b,reg_b : unsigned(7 downto 0);
signal state, next_state : state_type; 

begin

	-- Combinatoriel logic
	CL: process (req,AB,state,reg_a,reg_b,reset)
	begin
		next_reg_a <= reg_a;
		next_reg_b <= reg_b;
		ack <= '0';
		C <= (others =>'Z');
		
		case (state) is
			When InputA =>
				if req = '1' then
					next_state <= LoadA;
				else
					next_state <= InputA;
				end if;

			When LoadA =>  
				next_state <= RegAdone;
				next_reg_a <= AB;

			When RegAdone =>
				ack <= '1';
				if req = '0' then
					next_state <= InputB;
				else
					next_state <= RegAdone;
				end if;      
			
			When InputB =>
				if req = '1' then
					next_state <= LoadB;
				else
					next_state <= InputB;
				end if;     
			  
			When LoadB=>
				next_reg_b <= AB;
				next_state <= CmpAB;
			  
			When CmpAB => 
				if reg_a = reg_b then
					next_state <= DoneC;
				elsif reg_a > reg_b then
					next_state <= UpdateA;
				else
					next_state <= UpdateB; -- A < B
				end if;  
			  
			When UpdateA =>
				next_reg_a <= reg_a - reg_b;
				next_state <= CmpAB;
			  
			When UpdateB =>
				next_reg_b <= reg_b - reg_a;
				next_state <= CmpAB;
					
			When DoneC =>
				C <= reg_a;
				ack <= '1';
				if req = '0' then
					next_state <= InputA;
				else
					next_state <= DoneC;
				end if;  
			
	   end case;      
	end process CL; 

	-- Registers
	seq: process (clk, reset)
	begin
		if reset = '1' then
			state <= InputA;         -- Reset to initial state 
		elsif rising_edge(clk) then
			state <= next_state;
			reg_a <= next_reg_a;
			reg_b <= next_reg_b;
		end if;
	end process seq;
	
end fsmd;

