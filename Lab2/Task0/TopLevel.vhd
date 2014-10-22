----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:40:38 10/21/2014 
-- Design Name: 
-- Module Name:    TopLevel - Behavioral 
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
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
USE WORK.types.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TopLevel is
	port (
		     clk_100mhz : in std_logic;
		     rst : in std_logic;
		     led : out unsigned(7 downto 0);
			  btn : in std_logic_vector(0 downto 0);
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
end TopLevel;

architecture Behavioral of TopLevel is
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
	
   component acc
      port (clk    : in  bit_t;
            reset  : in  bit_t;
            addr   : out word_t;
            dataR  : in  halfword_t;
            dataW  : out halfword_t;
            req    : out bit_t;
            rw     : out bit_t;
            start  : in  bit_t;
            finish : out bit_t);          
   end component;	
	
	signal clk : std_logic;
	signal addr_32bit : word_t;           -- Address bus for data.
	signal start, finish: std_logic;
	signal req, wr_en: std_logic;
	signal dataW : halfword_t;
	signal dataR : signed(15 downto 0);
begin	
	start <= btn(0);
	led(0) <= start;
	led(1) <= finish;
	led(7 downto 2) <= (others => '0');
	-- memory clock of 12.5 MHz
	-- read somewhere about the timing to be 80ns !!
	-- works faster in synchronous mode, but not tested
	clk_div_inst : ClockDivider
	generic map (div => 8.0 )
	port map ( reset => rst, clkIn => clk_100mhz, clkOut => clk);

	psram_ctrl_inst : psram_ctrl
	port map (
			 clk => clk,
			 rst => rst,

			 addr => unsigned(addr_32bit(23 downto 0)),
			 wr_en => wr_en,
			 mem_cs => req,
			 read_data => dataR,
			 write_data  => signed(dataW),

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
		 
   Accelerator : acc
      port map (clk    => clk,
                reset  => rst,
                addr   => addr_32bit,
                dataR  => halfword_t(dataR),
                dataW  => dataW,
                req    => req,
                rw     => wr_en,
                start  => start,
                finish => finish);
					 
end Behavioral;

