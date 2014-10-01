-- -----------------------------------------------------------------------------
--
--  Title      :  Environment for the GCD module
--             :
--  Developers :  Jens Sparsø and Rasmus Bo Sørensen
--             :
--  Purpose    :  This design is an environment for the GCD module. It applies 
--             :  signals to a GCD module and collects the result of a            
--             :  computation. It should be connected to a GCD module only in a 
--             :  testbench.
--             :
--  Revision   : 02203 fall 2012 v.2
--
-- -----------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

-------------------------------------------------------------------------------- 
-- Entity declaration for the environment. It mirrors the entity declaration for
-- the GCD module so that they can be connected.
--------------------------------------------------------------------------------

ENTITY env IS                        
    PORT (clk:         IN std_logic;           -- The clock signal.
          reset:       IN std_logic;           -- Reset the module.
          req:         OUT std_logic;          -- Start computation.
          AB:          OUT unsigned(7 downto 0);  
                                               -- The two operands. One at at time
          ack:         IN std_logic;           -- Computation is complete.
          C:           IN unsigned(7 downto 0)); -- The result.  
END env;

-------------------------------------------------------------------------------- 
-- Behaviour model of the environment. It applies operands and the "req" signal 
-- to a GCD module and when the computation is complete, it collects the result.
-- There is room for improvement:
-- 1. The environment does not check the result. A simple modification is to 
--    insert an ASSERT statement that ensures that the result is a common 
--    divisor.
--------------------------------------------------------------------------------

ARCHITECTURE behaviour OF env IS
    -- This type will indicate the state of the statemachine.
    TYPE StateType IS (INPUT_A, DONE_A, INPUT_B, DONE_ALL);  
    
    -- Two signals to hold states.
    SIGNAL current_state, next_state: StateType;
    
    -- Result register.
    SIGNAL R: unsigned(7 downto 0);    
    
    -- Enable signal for the result register.        
    SIGNAL ld_R: std_logic;

BEGIN
    -- Combinatorial part of the statemachine. It is responsible for the 
    -- computation of the next state. It must be sensitive to the state
    -- and all inputs used to compute the next state.
    PROCESS (current_state, ack)
    	TYPE Operants IS ARRAY (0 TO 4) OF NATURAL;
		VARIABLE a_operants : Operants := (91, 17, 49, 81, 25);
		VARIABLE b_operants : Operants := (63, 11, 98, 45,  5);
		VARIABLE c_results  : Operants := ( 7,  1, 49,  9,  5);

    	-- Exercise all 8 bit (251 is a prime number (and 251 and 252 differs by only one) -> worst case)
--		VARIABLE a_operants : Operants := (251, 17, 49, 81, 25);
--    VARIABLE b_operants : Operants := (252, 11, 98, 45,  5);
--		VARIABLE c_results  : Operants := ( 1,  1, 49,  9,  5);
				
    	VARIABLE test_number : INTEGER := 0;
    BEGIN
        CASE current_state IS
         
            WHEN INPUT_A =>
                req  <= '1';
                AB   <= TO_UNSIGNED(a_operants(test_number),AB'length);
                                               -- The a operant is converted to a std_logic_vector
     
                IF ack = '0' THEN              -- wait until finish signal ack is one
                    next_state <= INPUT_A;
                ELSE                           -- then set next_state to DONE
                    next_state <= DONE_A;
                END IF;

            WHEN DONE_A =>
                req  <= '0';                   -- Phase 3 of handshaking protocol.
                AB   <= (others => 'X');       -- remove A
  
                IF ack = '1' THEN              -- wait until GCD module finishes the 
                    next_state <= DONE_A;      -- handshake protocol, 
                ELSE                           -- then start a new computation.
                    next_state <= INPUT_B;
                END IF;
 
           WHEN INPUT_B =>
                req  <= '1';
                AB   <= TO_UNSIGNED(b_operants(test_number),AB'length);
                                               -- The b operant is converted to a std_logic_vector                  
                ld_R <= '1';                   -- Enable result register.
    
                IF ack = '0' THEN              -- wait until finish signal ack is one
                    next_state <= INPUT_B;
                ELSE                           -- then set next_state to DONE
                    next_state <= DONE_ALL;
                END IF;

            WHEN DONE_ALL =>
                req  <= '0';                   -- Phase 3 of handshaking protocol.
                AB   <= (others => 'X');       -- remove B
                ld_R <= '0';                   -- Disable result register.
				assert R = TO_UNSIGNED(c_results(test_number),C'length) report "Wrong result!" severity failure;
                IF ack = '1' THEN              -- wait until GCD module finishes the 
                    next_state <= DONE_ALL;      -- handshake protocol, 
                ELSE                           -- then start a new computation.
                    IF test_number < 4 THEN
                    	test_number := test_number + 1;
                    ELSE
                    	test_number := 0;
						report "Test passed" severity failure;
                    END IF;
                    next_state <= INPUT_A;
                END IF;

        END CASE;
    END PROCESS;

    -- This process assigns next_state to current_state. It implements the 
    -- state holding registers in the statemachine.
    PROCESS(clk)                             
    BEGIN
        IF rising_edge(clk) THEN
            IF ld_R = '1' THEN 
                R <= C;
            END IF;
            
            IF reset = '1' THEN
                current_state <= INPUT_A;         -- Reset to initial state 
            ELSE
                current_state <= next_state;      -- go to next_state
            END IF;    
        END IF;
    END PROCESS;
END behaviour;

