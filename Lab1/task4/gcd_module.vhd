-- -----------------------------------------------------------------------------
--
--  Title      :  Finite state machine and datapath of the GCD
--             :
--  Developers :  Anders Greve(s073188) and Nicolas Bøtkjær (s918819)         
--             :
--  Purpose    :  This design is the FSM and Datapath of the Greatest Common Divisor 
--             :
--  Revision   :  02203 fall 2014 v.1
--              
-- -----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY gcd IS            
	PORT (
		clk:      IN std_logic;					-- The clock signal.
		reset:    IN std_logic;					-- Reset the module.
		req:      IN std_logic;					-- Start computation.
		AB:       IN unsigned(7 downto 0);	-- The two operands.
		ack:      OUT std_logic;				-- Computation is complete.
		C:        OUT unsigned(7 downto 0));-- The result.  
END gcd;

architecture Structural of gcd is
	--------------------------
	-- Component Declarations 
	--------------------------
	COMPONENT gcd_datapath IS
		GENERIC (W: NATURAL := 8);				-- Width of inputs.
		PORT(
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
	END COMPONENT;
	
	COMPONENT gcd_FSM IS
		PORT(
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
	end COMPONENT;	
	
	----------------------------
	-- Declare signals
	----------------------------
	signal ABorALU, LDA, LDB, C_ready, Z, N: std_logic;
	signal fn: signed(1 DOWNTO 0);
begin

	---------------------------------------
	-- Connect FSM and Datapath components
	---------------------------------------
	fsm_comp	: gcd_FSM 
	PORT MAP(
		clk => clk,
		reset => reset,
		req => req,
		ack => ack,
		fn => fn,
		ABorALU => ABorALU,
		LDA => LDA,
		LDB => LDB,
		C_ready => C_ready,
		Z => Z,
		N => N	
	);
		
	datapath_comp	: gcd_datapath 
	GENERIC MAP (W => 8) 
	PORT MAP(
		clk => clk,		
		AB => AB,		
		fn => fn,
		ABorALU => ABorALU,
		LDA => LDA,
		LDB => LDB,
		C_ready => C_ready,
		C => C,
		Z => Z,
		N => N
	);
end Structural;