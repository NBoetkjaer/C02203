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
	PORT (
		clk:      IN std_logic;					-- The clock signal.
		reset:    IN std_logic;					-- Reset the module.
		req:      IN std_logic;					-- Start computation.
		AB:       IN unsigned(7 downto 0);	-- The two operands.
		ack:      OUT std_logic;				-- Computation is complete.
		C:        OUT unsigned(7 downto 0));-- The result.  
END gcd;

architecture FSMD_component_based of gcd is

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

type state_type is ( InputA, LoadA, RegAdone, InputB, LoadB, CmpAB, UpdateA, UpdateB, DoneC ); -- Input your own state names

signal state, next_state : state_type; 

signal Z, N: std_logic;
signal fn: std_logic_vector(1 downto 0);
signal A, B, C_int: std_logic_vector(7 downto 0);
signal Y9 : std_logic_vector(8 downto 0);	
	alias Y: std_logic_vector(7 downto 0) is Y9(7 downto 0);

begin
----------------------------
-- Connect all components
----------------------------
	alu1	: alu GENERIC MAP (w => 9) PORT MAP (A=>('0' & A), B=>('0' & B), fn=>fn, C=>Y9, Z=>Z, N=>N);
--	reg_a	: reg PORT MAP (clk=>, en=>, data_in=>, data_out=>);
--	reg_b	: reg PORT MAP (clk=>, en=>, data_in=>, data_out=>);
--	mux1	: mux PORT MAP (data_in1=>, data_in2=>, s=>, data_out=>);
--	tribuf: tri PORT MAP (data_in=>, data_out=>, en=>);

--	-- Combinatoriel logic
--	CL: process (req, AB, state, reset)
--	begin
--		ack <= '0';
--		
--		case (state) is
--		
--		When InputA =>
--			if req = '1' then
--				next_state <= LoadA;
--			else
--				next_state <= InputA;
--			end if;
--		  
--		When LoadA =>  
--			next_state <= RegAdone;			
--		When RegAdone =>
--			ack <= '1';
--			if req = '0' then
--				next_state <= InputB;
--			else
--				next_state <= RegAdone;
--			end if;      
--		
--		When InputB =>
--			if req = '1' then
--				next_state <= LoadB;
--			else
--				next_state <= InputB;
--			end if;     
--		  
--		When LoadB=>
--			next_state <= CmpAB;
--		  
--		When CmpAB =>
--			if N = '1' then -- If sign bit is ...
--				next_state <= UpdateB;
--			elsif Z = 0 then
--				next_state <= DoneC;
--			else 
--				next_state <= UpdateA;
--			end if;
--
--		When UpdateA =>
--			next_state <= CmpAB;
--		  
--		When UpdateB =>
--			next_state <= CmpAB;
--				
--		When DoneC =>
--			ack <= '1';
--			if req = '0' then
--				next_state <= InputA;
--			else
--				next_state <= DoneC;
--			end if;  
--			
--	   end case;      
--	end process CL; 

	-- Registers

	seq: process (clk, reset)
	begin
		if reset = '1' then
			state <= InputA;         -- Reset to initial state 
		elsif rising_edge(clk) then
			state <= next_state;
		end if;
	end process seq;
	
end FSMD_component_based;

