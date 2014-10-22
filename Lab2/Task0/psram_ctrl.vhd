----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:07:28 10/04/2012 
-- Design Name: 
-- Module Name:    psram_ctrl - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity psram_ctrl is
	port (
		     clk : in std_logic;
		     rst : in std_logic;
	 -- from internal design 
		     addr : in unsigned(23 downto 0);
		     wr_en : in std_logic;
		     mem_cs : in std_logic;
		     read_data : out signed(15 downto 0);
		     write_data : in signed(15 downto 0);

    -- to external memory
		     MemOE : out std_logic;
		     MemWR : out std_logic;
		     MemAdv : out std_logic;
		     RamCS : out std_logic;
		     MemClk : out std_logic;
		     RamLB : out std_logic;
		     RamUB : out std_logic;
		     MemAdr : out unsigned(23 downto 0);
		     MemDB : inout signed(15 downto 0)
	     );
end psram_ctrl;

architecture Behavioral of psram_ctrl is
	signal wr_en_delay : std_logic;

begin

-- asynchronous mode !!
	MemClk <= '0';
-- always enabled chip select
	RamCS <= mem_cs;
	MemAdv <= '0';
	RamLB <= '0';
	RamUB <= '0';


	process(clk)
	begin
		if(clk'event and clk='1') then
			if (rst = '1') then
				read_data <= (others => '0');
			else
				read_data <= MemDB;
				wr_en_delay <= wr_en; 
				MemAdr <= addr;
				if ( wr_en = '1' ) then
					MemWR <= '0';
					MemOE <= '1';
					MemDB <= write_data;
				else
					MemOE <= '0';
					MemWR <= '1';
					MemDB <= (others => 'Z');
				end if;
			end if;
		end if;
	end process;

end Behavioral;

