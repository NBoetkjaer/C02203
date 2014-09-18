-- -----------------------------------------------------------------------------
--
--  Title      :  Testbench for the GCD module
--             :
--  Developers :  Jens Sparsø and Rasmus Bo Sørensen
--             :
--  Purpose    :  This design is a testbench for the GCD module. It instantiates
--             :  a GCD module, an environment and a clock. It does not check     
--             :  any results. At the bottom of the file you will find a        
--             :  configuration that will set the simulator to simulate the 
--             :  specification architecture of the GCD module. Copy and modify 
--             :  the configuration to simulate your own versions of the GCD 
--             :  module.
--             :
--  Revision   : 02203 fall 2012 v.2
--              
-- -----------------------------------------------------------------------------

-------------------------------------------------------------------------------- 
-- Standard testbench entity declaration. No inputs and no outputs.             
--------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY testbench IS                       
END testbench;

-------------------------------------------------------------------------------- 
-- This testbench instantiates a GCD module, an environment and a clock. It
-- connects the three entities.     
--------------------------------------------------------------------------------

ARCHITECTURE structure OF testbench IS
    COMPONENT clock
        GENERIC (period:    TIME := 10 ns);
        PORT (clk:          OUT std_logic := '0');
    END COMPONENT;

    COMPONENT env
        PORT (clk:         IN std_logic;           -- The clock signal.
              reset:       IN std_logic;           -- Reset the module.
              req:         OUT std_logic;          -- Start computation.
              AB:          OUT unsigned(7 downto 0);     -- The two operands.
              ack:         IN std_logic;           -- Computation is complete.
              C:           IN unsigned(7 downto 0));     -- The result.      
    END COMPONENT;  

    COMPONENT GCD_sys             
       PORT (clk:         IN std_logic;           -- The clock signal.
             reset:       IN std_logic;           -- Reset the module.
             req:         IN std_logic;           -- Start computation.
             AB:          IN unsigned(7 downto 0);      -- The two operands.
             ack:         OUT std_logic;          -- Computation is complete.
             C:           OUT unsigned(7 downto 0));    -- The result.
    END COMPONENT;

    SIGNAL req, ack, clk, reset: std_logic;       -- Signals to inter-
    SIGNAL AB, C: unsigned(7 downto 0);   -- connect components.

BEGIN                                     
    -- assert reset, note that reset is active high
    reset <= '1', '0' after 110 ns;
    
    clock_gen: clock
        PORT MAP (clk);

    environment: env
        PORT MAP (clk, reset, req, AB, ack, C);

    GCD_module: GCD_sys
        PORT MAP (clk, reset, req, AB, ack, C);

END structure;



