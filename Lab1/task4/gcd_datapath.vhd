-- -----------------------------------------------------------------------------
--
--  Title      : Finite state machine and datapath of the GCD
--             :
--  Developers : Anders Greve(s073188) and Nicolas Bøtkjær (s918819) 
-- 		      :
--  Purpose    : This design is the FSM and Datapath of the Greatest Common Divisor
--             :
--  Notes      : Implementation of Euclids GCD algorithm with repeated subtration.
--             : The implementation is a low level structural implementation.
--             : This architecture implements the datapath, by connecting low level
--             : components.
--             :
--  Revision   :  02203 fall 2014 v.1
--              
-- -----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity gcd_datapath is
   generic (W: NATURAL := 8); -- Width of inputs.
	port(
	clk		: IN std_logic; -- The clock signal.
	AB			: IN unsigned(W-1 downto 0);	-- The two operands.
	fn			: IN signed(1 DOWNTO 0); -- Requested ALU function.	
	ABorALU	: IN std_logic; -- MUX select signal.
	LDA		: IN std_logic; -- Load A register.	
	LDB		: IN std_logic; -- Load B register.
	C_ready	: IN std_logic; --	Enable signal for tri-state buffer.
	C			: OUT unsigned(W-1 DOWNTO 0); -- Result.
	Z			: OUT std_logic; -- Result = 0 flag.
	N			: OUT std_logic); -- Result negative flag.	
end gcd_datapath;

architecture Structural of gcd_datapath is
	--------------------------
	-- Component Declarations 
	--------------------------
	COMPONENT tri IS                                
		GENERIC (N:     NATURAL := 8);				-- Width of inputs.
		PORT (data_in	: IN  unsigned(N DOWNTO 1);-- Input.
				data_out	: OUT unsigned(N DOWNTO 1);-- Output.
				en			: IN  std_logic);				-- Enable signal. 
	END COMPONENT;

	COMPONENT  mux IS                                
		GENERIC (N		:	NATURAL := 8);					-- Width of inputs and output.
		PORT (data_in1	:	IN  unsigned(N DOWNTO 1);	-- Inputs.
				data_in2	:	IN unsigned(N DOWNTO 1);
				s			:	IN std_logic;					-- Select signal (in1 when '0')
				data_out	:	OUT  unsigned(N DOWNTO 1)	-- Output. 
				 );          
	END COMPONENT; 

	COMPONENT reg IS                               
		GENERIC (N:     NATURAL := 8);					-- Width of inputs.
		PORT (clk:      IN  std_logic;					-- Clock signal.
				 en:       IN  std_logic;					-- Enable signal.
				 data_in:  IN  unsigned(N DOWNTO 1);   -- Input data.
				 data_out: OUT unsigned(N DOWNTO 1));  -- Output data.
	END COMPONENT;

	COMPONENT alu IS  
		GENERIC(W	: NATURAL := 8);				-- Width of inputs.
		PORT (A, B	: IN signed(W DOWNTO 1);	-- Input operands.
				fn		: IN signed(2 DOWNTO 1);	-- Function
				C		: OUT signed(W DOWNTO 1);	-- Result.
				Z		: OUT std_logic;				-- Result = 0 flag.
				N		: OUT std_logic);				-- Result negative flag.
	END COMPONENT;
	----------------------------
	-- Declare signals
	----------------------------
	signal A, B, Y, C_int: unsigned(W-1 downto 0);
	signal Aext, Bext, Yext : signed(W downto 0); -- extended with one sign bit

begin

	Y <= unsigned( Yext(W-1 downto 0) );
	Aext <= signed( '0' & A);
	Bext <= signed( '0' & B);
	
	----------------------------
	-- Connect all components
	----------------------------
	alu1	: alu GENERIC MAP (W => W+1) PORT MAP(A=>Aext, B=>Bext, fn=>fn, C=>Yext, Z=>Z, N=>N);
	reg_a	: reg GENERIC MAP (N => W) PORT MAP (clk=>clk, en=>LDA, data_in=>C_int, data_out=>A);
	reg_b	: reg GENERIC MAP (N => W)PORT MAP (clk=>clk, en=>LDB, data_in=>C_int, data_out=>B);
	mux1	: mux GENERIC MAP (N => W)PORT MAP (data_in1=>Y, data_in2=>AB, s=>ABorALU, data_out=>C_int);
	tribuf: tri GENERIC MAP (N => W)PORT MAP (data_in=>C_int, data_out=>C, en=>C_ready);

end Structural;

