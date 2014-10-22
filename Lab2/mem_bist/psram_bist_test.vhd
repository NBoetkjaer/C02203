----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:46:41 10/04/2012 
-- Design Name: 
-- Module Name:    psram_bist_test - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:  First writes signature 16 bit values (A5A5 or 5A5A) to alternate memory locations (0,2,4... upto 1000).
--						Then reads from the same memory locations to check if data read is OK.
--						Asserts a bist_flag if check fails (i.e reads dont have signature data)
--						bist_flag is mapped to led0, if glowing means bist failed.
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


entity psram_bist_test is
	port (
		     clk_100mhz : in std_logic;
		     rst : in std_logic;
		     led : out unsigned(7 downto 0);
		     --memory interface 
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
end psram_bist_test;

architecture Behavioral of psram_bist_test is


	component psram_ctrl is
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
	end component;

	component ClockDivider is
		generic(div : real);
			port(reset  : in  std_logic;
			     clkIn  : in  std_logic;
			     clkOut : out std_logic
		     );
	end component;

	signal addr_count, addr_final :  unsigned(23 downto 0);
	signal wr_en : std_logic;
	signal mem_cs : std_logic;
	signal write_data, read_data : signed(15 downto 0);
	signal read_data_ff : signed(15 downto 0);
	signal count_clock : unsigned(3 downto 0);
	signal clk : std_logic;
	signal counter : unsigned(15 downto 0);
	signal bist_flag : std_logic;
begin

	-- memory clock of 12.5 MHz
	-- read somewhere about the timing to be 80ns !!
	-- works faster in synchronous mode, but not tested
	clk_div_inst : ClockDivider
	generic map (div => 8.0 )
	port map ( reset => rst, clkIn => clk_100mhz, clkOut => clk);

	led(7) <= '0';
	led(6) <= wr_en;
	led(5 downto 2) <= unsigned(write_data(3 downto 0));
	led(1) <= mem_cs;
	led(0) <= bist_flag;



	process(clk,rst)
	begin
		if(clk'event and clk='1') then
			if (rst = '1') then
				addr_count <= (others => '0');
				bist_flag <= '0';
				counter <= (others => '0');
				wr_en <= '0';
				write_data <= (others => '0');
				read_data_ff <= X"A5A5";
			else
				
				if ( counter < 1000 ) then
					counter <= counter + 1;
					wr_en <= '1';
					addr_count <= addr_count + 1;
					--write different signature in alternate locations
					if (counter(1) = '0') then
						write_data <= X"A5A5";
					else
						write_data <= X"5A5A";
					end if;
					addr_final <= addr_count;
				elsif(counter < 2000 ) then
					wr_en <= '0';
					counter <= counter + 1;
					addr_count <= addr_count + 1;
					addr_final <= addr_count - 1000;
					-- read back data and check 
					read_data_ff <= read_data;
					if ( bist_flag = '0' and ((read_data_ff = X"5A5A" and counter(1) = '1') or (read_data_ff = X"A5A5" and counter(1) = '0'))) then
						bist_flag <= '0';
					else
						bist_flag <= '1';
					end if;
				else
					wr_en <= '0';
				end if;
			end if;
		end if;
	end process;
	mem_cs <= '0';

	psram_ctrl_inst : psram_ctrl
	port map (
			 clk => clk,
			 rst => rst,

			 addr => addr_final,
			 wr_en => wr_en,
			 mem_cs => mem_cs,
			 read_data => read_data,
			 write_data  => write_data,

			 MemOE => MemOE,
			 MemWR => MemWR, 
			 MemAdv => MemAdv, 
			 RamCS => RamCS,
			 MemClk => MemClk,
			 RamLB => RamLB,
			 RamUB => RamUB,
			 MemAdr => MemAdr,
			 MemDB => MemDB
		 );

end Behavioral;

