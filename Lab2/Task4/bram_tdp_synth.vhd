library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


Library UNISIM;
use UNISIM.vcomponents.all;

entity bram_tdp is

generic (
    DATA_WIDTH    : integer := 16;
    ADDR_WIDTH    : integer := 8
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

signal WEAWEL : std_logic_vector(1 downto 0);
signal WEBWEU : std_logic_vector(1 downto 0);
signal ADDRAWRADDR: std_logic_vector(12 downto 0);
signal ADDRBWRADDR: std_logic_vector(12 downto 0);
begin
	-- always write 16 bit (both bytes)
	WEAWEL <= a_wr & a_wr;
	WEBWEU <= b_wr & b_wr;
	-- setup address
	ADDRAWRADDR(ADDR_WIDTH-1 downto 0) <= std_logic_vector(a_addr);	
	ADDRAWRADDR(12 downto ADDR_WIDTH) <= (others => '0');
	
	ADDRBWRADDR(ADDR_WIDTH-1 downto 0) <= std_logic_vector(b_addr);
	ADDRBWRADDR(12 downto ADDR_WIDTH) <= (others => '0');

   -- RAMB8BWER: 8k-bit Data and 1k-bit Parity Configurable Synchronous Block RAM
   --            Spartan-6
   -- Xilinx HDL Language Template, version 14.7

   RAMB8BWER_inst : RAMB8BWER
   generic map (
      -- DATA_WIDTH_A/DATA_WIDTH_B: 'If RAM_MODE="TDP": 0, 1, 2, 4, 9 or 18; If RAM_MODE="SDP": 36'
      DATA_WIDTH_A => DATA_WIDTH + 2,
      DATA_WIDTH_B => DATA_WIDTH + 2,
      -- DOA_REG/DOB_REG: Optional output register (0 or 1)
      DOA_REG => 0,
      DOB_REG => 0,
      -- EN_RSTRAM_A/EN_RSTRAM_B: Enable/disable RST
      EN_RSTRAM_A => TRUE,
      EN_RSTRAM_B => TRUE,
      -- INITP_00 to INITP_03: Initial memory contents.
      INITP_00 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_01 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_02 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_03 => X"0000000000000000000000000000000000000000000000000000000000000000",
      -- INIT_00 to INIT_1F: Initial memory contents.
      INIT_00 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_01 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_02 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_03 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_04 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_05 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_06 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_07 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_08 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_09 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0A => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0B => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0C => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0E => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0F => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_10 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_11 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_12 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_13 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_14 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_15 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_16 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_17 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_18 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_19 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1A => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1B => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1C => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1E => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1F => X"0000000000000000000000000000000000000000000000000000000000000000",
      -- INIT_A/INIT_B: Initial values on output port
      INIT_A => X"00000",
      INIT_B => X"00000",
      -- INIT_FILE: Not Supported
      INIT_FILE => "NONE",                                                             -- Do not modify
      -- RAM_MODE: "SDP" or "TDP" 
      RAM_MODE => "TDP",
      -- RSTTYPE: "SYNC" or "ASYNC" 
      RSTTYPE => "SYNC",
      -- RST_PRIORITY_A/RST_PRIORITY_B: "CE" or "SR" 
      RST_PRIORITY_A => "CE",
      RST_PRIORITY_B => "CE",
      -- SIM_COLLISION_CHECK: Collision check enable "ALL", "WARNING_ONLY", "GENERATE_X_ONLY" or "NONE" 
      SIM_COLLISION_CHECK => "ALL",
      -- SRVAL_A/SRVAL_B: Set/Reset value for RAM output
      SRVAL_A => X"00000",
      SRVAL_B => X"00000",
      -- WRITE_MODE_A/WRITE_MODE_B: "WRITE_FIRST", "READ_FIRST", or "NO_CHANGE" 
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "READ_FIRST" 
   )
   port map (
      -- Port A Data: 16-bit (each) output: Port A data
      DOADO => a_dout,             -- 16-bit output: A port data/LSB data output
      DOPADOP => open,            -- 2-bit output: A port parity/LSB parity output
      -- Port B Data: 16-bit (each) output: Port B data
      DOBDO => b_dout,             -- 16-bit output: B port data/MSB data output
      DOPBDOP => open,            -- 2-bit output: B port parity/MSB parity output
      -- Port A Address/Control Signals: 13-bit (each) input: Port A address and control signals (write port
      -- when RAM_MODE="SDP")
      ADDRAWRADDR => ADDRAWRADDR, -- 13-bit input: A port address/Write address input
      CLKAWRCLK => clk,		-- 1-bit input: A port clock/Write clock input
      ENAWREN => '1',	-- 1-bit input: A port enable/Write enable input
      REGCEA => '0',			-- 1-bit input: A port register enable input
      RSTA => '0',			-- 1-bit input: A port set/reset input
      WEAWEL => WEAWEL,	-- 2-bit input: A port write enable input
      -- Port A Data: 16-bit (each) input: Port A data
      DIADI => a_din,		-- 16-bit input: A port data/LSB data input
      DIPADIP => "00",		-- 2-bit input: A port parity/LSB parity input
      -- Port B Address/Control Signals: 13-bit (each) input: Port B address and control signals (read port
      -- when RAM_MODE="SDP")
      ADDRBRDADDR => ADDRBWRADDR, -- 13-bit input: B port address/Read address input
      CLKBRDCLK => clk,		-- 1-bit input: B port clock/Read clock input
      ENBRDEN => '1',	-- 1-bit input: B port enable/Read enable input
      REGCEBREGCE => '0',	-- 1-bit input: B port register enable/Register enable input
      RSTBRST => '0',		-- 1-bit input: B port set/reset input
      WEBWEU => WEBWEU,		-- 2-bit input: B port write enable input
      -- Port B Data: 16-bit (each) input: Port B data
      DIBDI => b_din,		-- 16-bit input: B port data/MSB data input
      DIPBDIP => "00"		-- 2-bit input: B port parity/MSB parity input
   );
   -- End of RAMB8BWER_inst instantiation
end rtl;