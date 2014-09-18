library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder is 
	port (	A : IN STD_LOGIC;
		B : IN STD_LOGIC;
		C : IN STD_LOGIC;
		S : OUT STD_LOGIC;
		T : OUT STD_LOGIC);
end full_adder;

architecture Ligninger of full_adder is
begin
	S <= A xor B xor C;
	T <= (A and B) or (B and C) or (A and C);
end Ligninger;