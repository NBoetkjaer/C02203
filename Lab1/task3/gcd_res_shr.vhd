-- -----------------------------------------------------------------------------
--
--  Title      : Finite state machine and datapath of the GCD
--             :
--  Developers : Anders Greve(s073188) and Nicolas Bøtkjær (s918819) 
-- 		      :
--  Purpose    : This design is the FSM and Datapath of the Greatest Common Divisor
--             :
--  Notes      : Implementation of Euclids GCD algorithm with repeated subtration.
--             : Operator sharing is implementetd for both subtraction 
--             : and multiplexing.
--             :
--  Revision   :  02203 fall 2014 v.1
--              
-- -----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY gcd IS            
    PORT (clk:      IN std_logic;				-- The clock signal.
          reset:    IN std_logic;				-- Reset the module.
          req:      IN std_logic;				-- Start computation.
          AB:       IN unsigned(7 downto 0);	-- The two operands.
          ack:      OUT std_logic;				-- Computation is complete.
          C:        OUT unsigned(7 downto 0));	-- The result.  
END gcd;

architecture FSMD_res_sharing of gcd is
-- FSMD States 
type state_type is ( InputA, LoadA, RegAdone, InputB, LoadB, CmpAB, UpdateA, UpdateB, DoneC );
-- Declare signals
signal state, next_state : state_type; 
signal reg_a,next_reg_a,next_reg_b,reg_b : unsigned(7 downto 0);
signal op1, op2, Y : signed(8 downto 0); -- One extra bit to hold the sign-bit.
signal C_int : unsigned (7 downto 0);
signal ABorALU : std_logic;
 
begin
	-- Share the subtraction			
	Y <= op1 - op2; 
	-- Share the multiplexer (AB input or result from subtraction) 
	C_int <= unsigned(Y(7 downto 0)) when ABorALU = '0' else AB ;	
	
	-- Combinatoriel logic
	CL: process (req, AB, state, reg_a, reg_b, C_int, Y, reset)
	begin
		-- Default values.
		C <= (others =>'Z');
		ABorALU <= '0';
		next_reg_a <= reg_a;
		next_reg_b <= reg_b;		
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
			next_reg_a <=	C_int;
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
			next_state <= CmpAB;		
			next_reg_b <= C_int;
			ABorALU <= '1';
		  
		When CmpAB =>
			if Y(8) = '1' then -- If sign bit is set op2 > op1		
				next_state <= UpdateB;
			elsif Y(7 downto 0) = 0 then
				next_state <= DoneC;
			else 			
				next_state <= UpdateA;
			end if;

		When UpdateA =>
			op1 <= signed('0' & std_logic_vector(reg_a));
			op2 <= signed('0' & std_logic_vector(reg_b));	
			next_reg_a <=	C_int;	
			next_state <= CmpAB;
		  
		When UpdateB =>
			op1 <= signed('0' & std_logic_vector(reg_b));
			op2 <= signed('0' & std_logic_vector(reg_a));
			next_reg_b <= C_int;
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
		end if;
	end process seq;
	
end FSMD_res_sharing;

