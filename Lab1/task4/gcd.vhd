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

type state_type is ( InputA, LoadA, RegAdone, InputB, LoadB, ALUcompute, CmpAB, UpdateA, UpdateB, DoneC ); -- Input your own state names
----------------------------
-- Declare signals
----------------------------
signal state, next_state : state_type; 

signal ABorALU, LDA, LDB, Z, N, C_ready: std_logic;
signal fn: signed(1 downto 0);
signal A, B, Y, C_int: unsigned(7 downto 0);
signal A9, B9,Y9 : signed(8 downto 0);	

begin

	Y <= unsigned( Y9(7 downto 0) );
	A9 <= signed( '0' & A);
	B9 <= signed( '0' & B);
----------------------------
-- Connect all components
----------------------------
	alu1	: alu GENERIC MAP (w => 9) PORT MAP (A=>A9, B=>B9, fn=>fn, C=>Y9, Z=>Z, N=>N);
	reg_a	: reg PORT MAP (clk=>clk, en=>LDA, data_in=>C_int, data_out=>A);
	reg_b	: reg PORT MAP (clk=>clk, en=>LDB, data_in=>C_int, data_out=>B);
	mux1	: mux PORT MAP (data_in1=>Y, data_in2=>AB, s=>ABorALU, data_out=>C_int);
	tribuf: tri PORT MAP (data_in=>C_int, data_out=>C, en=>C_ready);

	-- Combinatoriel logic
	CL: process (req, AB, state, reset)
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
				next_state <= ALUcompute;
				
			When ALUcompute=>
				next_state <= CmpAB;
				
			When CmpAB =>
				fn <= "00";
				if Z = '1' then -- (A - B) = 0; we're done
					next_state <= DoneC;					
				elsif N = '1' then -- If sign bit is set then A < B
					next_state <= UpdateB;
				else 
					next_state <= UpdateA;
				end if;

			When UpdateA =>
				fn <= "00";
				LDA <= '1';	
				next_state <= ALUcompute;
			  
			When UpdateB =>
				fn <= "01";
				LDB <= '1';	
				next_state <= ALUcompute;
					
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

