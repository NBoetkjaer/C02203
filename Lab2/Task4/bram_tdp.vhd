library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bram_tdp is

generic (
    DATA_WIDTH    : integer := 32;
    ADDR_WIDTH    : integer := 10
);

port (
	clk   : in  std_logic;
-- Port A
    a_wr    : in  std_logic;
    a_addr  : in  unsigned(ADDR_WIDTH-1 downto 0);
    a_din   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    a_dout  : out std_logic_vector(DATA_WIDTH-1 downto 0);
-- Port B
    b_wr    : in  std_logic;
    b_addr  : in  unsigned(ADDR_WIDTH-1 downto 0);
    b_din   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    b_dout  : out std_logic_vector(DATA_WIDTH-1 downto 0)
);
end bram_tdp;

architecture rtl of bram_tdp is
-- Shared memory
    type mem_type is array ( (2**ADDR_WIDTH)-1 downto 0 ) of std_logic_vector(DATA_WIDTH-1 downto 0);
    shared variable mem : mem_type := (others => (others => '0'));
begin

-- Port A
process(clk)
begin
    if( rising_edge(clk) ) then
        if(a_wr='1') then
            mem(to_integer(a_addr)) := a_din;
        end if;
        a_dout <= mem(to_integer(a_addr));
    end if;
end process;
 
-- Port B
process(clk)
begin
    if( rising_edge(clk) ) then
        if(b_wr='1') then
            mem(to_integer(b_addr)) := b_din;
        end if;
        b_dout <= mem(to_integer(b_addr));
    end if;
end process;
end rtl;