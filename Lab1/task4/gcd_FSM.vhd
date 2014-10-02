----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:57:09 10/01/2014 
-- Design Name: 
-- Module Name:    gcd_FSM - structural 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity gcd_FSM is
port(
	clk		: IN std_logic; -- The clock signal.
	reset		: IN std_logic; -- Reset the module.
	req		: IN std_logic; -- Start computation.
	ack		: OUT std_logic; -- Computation is complete.
	fn			: OUT signed(1 DOWNTO 0); -- Requested ALU function.	
	ABorALU	: OUT std_logic; -- MUX select signal.
	LDA		: OUT std_logic; -- Load A register.	
	LDB		: OUT std_logic; -- Load B register.
	C_ready	: OUT std_logic; --	Enable signal for tri-state buffer.
	Z			: IN std_logic; -- Result = 0 flag.
	N			: IN std_logic); -- Result negative flag.	
end gcd_FSM;

architecture behaviour of gcd_FSM is
	----------------------------
	-- Define FSMD states 
	----------------------------
	type state_type is ( InputA, LoadA, RegAdone, InputB, LoadB, CmpAB, UpdateB, DoneC );
	----------------------------
	-- Declare signals
	----------------------------
	signal state, next_state : state_type; 
begin

	-- Combinatoriel logic
	CL: process (req, Z, N, state, reset)
	begin
		ack <= '0';
		ABorALU <= '0';
		LDA <= '0';
		LDB <= '0';
		fn <= "00";
		C_ready <= '0';
		
		case (state) is
			
			When InputA =>
				if req = '1' then
					next_state <= LoadA;
				else
					next_state <= InputA;
				end if;
			  
			When LoadA =>  
				ABorALU <= '1';
				LDA <= '1';
				next_state <= RegAdone;	
				
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
				ABorALU <= '1';
				LDB <= '1';			
				next_state <= CmpAB;
				
			When CmpAB =>
				if Z = '1' then -- (A - B) = 0; we're done
					next_state <= DoneC;					
				elsif N = '1' then -- If sign bit is set then A < B.
					next_state <= UpdateB;
				else -- Directly update A, result is already on ALU output.
					LDA <= '1';
					next_state <= CmpAB;
				end if;
			  
			When UpdateB =>
				fn <= "01";
				LDB <= '1';	
				next_state <= CmpAB;
					
			When DoneC =>
				C_ready <= '1';
				ack <= '1'; 
				fn <= "10"; -- Pass register directly trough the ALU 
				if req = '0' then
					next_state <= InputA;
				else
					next_state <= DoneC;
				end if;  				
	   end case;      
	end process CL; 

	-- State register update
	seq: process (clk, reset)
	begin
		if reset = '1' then
			state <= InputA;         -- Reset to initial state 
		elsif rising_edge(clk) then
			state <= next_state;
		end if;
	end process seq;

end behaviour;

