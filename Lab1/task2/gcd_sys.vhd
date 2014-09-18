-- -----------------------------------------------------------------------------
--
--  Title      :  FSMD and IO of the GCD
--             :
--  Developers :  Jens Sparsø and Rasmus Bo Sørensen       
-- 		       :
--  Purpose    :  This design instantiates the FSMD, the clock divider and the IO  
--             :  greates common devisor of two positive integers in two's 
--             :  complement representation.
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

--ENTITY gcd_sys IS
--    PORT (clk:      IN std_logic;                       -- The clock signal.
--          reset:    IN std_logic;                       -- Reset the module.
--          req:      IN std_logic;                       -- Input operand / Start computation.
--          AB:       IN unsigned(7 downto 0);    -- Bus for A and B operands.
--          ack:      OUT std_logic;                      -- Input received / Computation is complete.
--          C:        OUT unsigned(7 downto 0));   -- The result.
--END gcd;

Architecture fsmd_io of gcd_sys is
	 
	 COMPONENT debounce
			PORT (	clk		: IN std_logic;
					reset	: IN std_logic;
					sw		: IN std_logic;
					db_level: OUT std_logic;
					db_tick	: OUT std_logic
					);
	 END COMPONENT;				
    
    COMPONENT gcd
        PORT (clk	: IN std_logic;                       -- The clock signal.
              reset	: IN std_logic;                       -- Reset the module.
              req	: IN std_logic;                       -- Input operand / Start computation.
              AB	: IN unsigned(7 downto 0);    -- Bus for A and B operands.
              ack	: OUT std_logic;                      -- Input received / Computation is complete.
              C		: OUT unsigned(7 downto 0)    -- The result.
             );
    END COMPONENT;
    
	signal db_req : std_logic;

    --signal internal_ack: std_logic;
    
    BEGIN

		u1:gcd PORT MAP (clk=>clk,  reset=>reset, req=>db_req, AB=>AB, ack=>ack, C=>C);
		dbreq:debounce PORT MAP (clk=>clk, reset=>reset, sw=>req, db_level=>db_req, db_tick=>open);

END fsmd_io;
