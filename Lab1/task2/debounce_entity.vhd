library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity debounce is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           sw : in  STD_LOGIC;
           db_level : out  STD_LOGIC;
           db_tick : out  STD_LOGIC);
end debounce;
