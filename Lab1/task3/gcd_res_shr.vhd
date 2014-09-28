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

architecture FSMD_res_sharing of gcd is

type state_type is ( InputA, LoadA, RegAdone, InputB, LoadB, CmpAB
, UpdateA, UpdateB
, DoneC ); -- Input your own state names

signal reg_a,next_reg_a,next_reg_b,reg_b : unsigned(7 downto 0);

signal op1, op2, diff : signed(8 downto 0);
signal m1 : unsigned (7 downto 0);
signal state, next_state : state_type; 
signal ABorALU, LDA, LDB : std_logic;
begin

	with ABorALU select 
		m1 <=	unsigned(diff(7 downto 0)) when '0',
				AB when others;
				
	next_reg_a <=	m1 when LDA = '1' else reg_a;
	next_reg_b <=	m1 when LDB = '1' else reg_b;			
				
	diff <= op1 - op2;
	-- Combinatoriel logic
	CL: process (req,AB,state,reg_a,reg_b, m1, diff, reset)
	begin
		ABorALU <= '0';
		LDA <= '0';
		LDB <= '0';
		ack <= '0';
		op1 <= signed('0' & std_logic_vector(reg_a));
		op2 <= signed('0' & std_logic_vector(reg_b));		
				
		case (state) is
		
		When InputA =>
			if req = '1' then
				next_state <= LoadA;
			else
				next_state <= InputA;
			end if;
		  
		When LoadA =>  
			next_state <= RegAdone;
			LDA <= '1';
			ABorALU <= '1';
			
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
			LDB <= '1';
			ABorALU <= '1';
			next_state <= CmpAB;
		  
		When CmpAB =>
			if diff(8) = '1' then -- If sign bit is set op2 > op1		
				next_state <= UpdateB;
			elsif diff(7 downto 0) = 0 then
				next_state <= DoneC;
			else 			
				next_state <= UpdateA;
			end if;

		When UpdateA =>
			op1 <= signed('0' & std_logic_vector(reg_a));
			op2 <= signed('0' & std_logic_vector(reg_b));	
			LDA <= '1';			
			next_state <= CmpAB;
		  
		When UpdateB =>
			op1 <= signed('0' & std_logic_vector(reg_b));
			op2 <= signed('0' & std_logic_vector(reg_a));
			LDB <= '1';
			next_state <= CmpAB;
				
		When DoneC =>
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
	
	-- Output 
	C <= reg_a;
	
end FSMD_res_sharing;

