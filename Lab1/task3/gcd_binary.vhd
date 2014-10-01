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

architecture FSMD_binary of gcd is

type state_type is ( InputA, LoadA, RegAdone, InputB, LoadB, CmpAB, UpdateA, UpdateB, DoneC ); -- Input your own state names
signal state, next_state : state_type; 

signal reg_a,next_reg_a, next_reg_b,reg_b: unsigned(7 downto 0);
signal next_shift_reg, shift_reg : integer range 0 to 7;
signal op1, op2, diff : signed(8 downto 0);

begin

	diff <= op1 - op2;
	-- Combinatoriel logic
	CL: process (req,AB,state,reg_a,reg_b, shift_reg, diff, reset)
	begin
		C <= (others =>'Z');
		next_reg_a <= reg_a;
		next_reg_b <= reg_b;
		next_shift_reg <= shift_reg;
		ack <= '0';
		op1 <= signed('0' & std_logic_vector(reg_a));
		op2 <= signed('0' & std_logic_vector(reg_b));
		
		case (state) is
		
		When InputA =>
			next_shift_reg <= 0; -- initialize the shift 
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
			if reg_a(0) = '0' and reg_b(0) = '0' then -- Both A and B is even.
				next_reg_a <= ('0' & reg_a(7 downto 1)); -- divide by 2.
				next_reg_b <= ('0' & reg_b(7 downto 1)); -- divide by 2.
				next_shift_reg <= shift_reg + 1;
				next_state <= CmpAB;
		
			elsif reg_a(0) = '1' and reg_b(0) = '1' then -- Both A and B is odd.
				if diff(8) = '1' then -- If sign bit is set op2 > op1.
					next_state <= UpdateB;
				elsif diff(7 downto 0) = 0 then
					next_reg_a <= reg_a sll shift_reg; -- shift result back.
					next_state <= DoneC;
				else 
					next_state <= UpdateA;
				end if;				
			elsif reg_a(0) = '1' then -- A is odd (B must be even)
				next_reg_b <= ('0' & reg_b(7 downto 1)); -- divide by 2.
				next_state <= CmpAB;
			else -- A is even and B is odd.
				next_reg_a <= ('0' & reg_a(7 downto 1)); -- divide by 2.
				next_state <= CmpAB;
			end if;
		
		When UpdateA =>
			op1 <= signed('0' & std_logic_vector(reg_a));
			op2 <= signed('0' & std_logic_vector(reg_b));	
			next_reg_a <= ('0' & unsigned(diff(7 downto 1))); -- divide by 2.
			next_state <= CmpAB;
		  
		When UpdateB =>
			op1 <= signed('0' & std_logic_vector(reg_b));
			op2 <= signed('0' & std_logic_vector(reg_a));
			next_reg_b <= ('0' & unsigned(diff(7 downto 1))); -- divide by 2.
			next_state <= CmpAB;				
		When DoneC =>
			ack <= '1';
			C <= reg_a;
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
			shift_reg <= next_shift_reg;
		end if;
	end process seq;
end fsmd_binary;

