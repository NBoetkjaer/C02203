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
USE WORK.types.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity memory_burst is
	generic (
		mem_size       : positive;
		load_file_name : string);
	port (
		clk : in std_logic;
		addr	: in word_t;
		dataR	: out halfword_t;
		dataW	: in halfword_t;
		rw		: in std_logic;
		req		: in std_logic;
		
		adv 	: in std_logic;		-- Address valid signal.
		dwait 	: out std_logic;	-- wait signal.
		-- Signal to dump processed image to file
		dump_image : in  std_logic

	     );
end memory_burst;

architecture Behavioral of memory_burst is
	
	component memory2 is
		generic (
		mem_size       : positive;
		load_file_name : string);
		port (
		clk        : in  std_logic;
		addr       : in  word_t;
		dataR      : out halfword_t;
		dataW      : in  halfword_t;
		rw         : in  std_logic;
		req        : in  std_logic;
		dump_image : in  std_logic);
	end component memory2;
   
	-- Declare the state type.
	type StateType is (idle, initBurst, bursting); 
	-- Declare signals
	signal state, state_next : StateType; -- Two signals to hold the states of the FSM.

	signal rw_reg, rw_next : std_logic;
	signal addr_reg, addr_next : word_t;
	signal dataR_int: halfword_t;
	-- rowBoundarySize is used for simulating the delay, caused by row boundary crossing.
	constant rowBoundarySize: natural := 7; -- actual value is 2^(rowBoundarySize)
	constant mem_latency: natural := 2;
	signal latencyCount_reg, latencyCount_next : unsigned(1 downto 0);
begin
	
	Memory : memory2
	generic map (
		mem_size	=> mem_size,
		load_file_name => load_file_name)
	port map(
		clk        => clk,
		addr       => addr_reg,
		dataR      => dataR_int,
		dataW      => dataW,
		rw         => rw_reg,
		req        => req,
		dump_image => dump_image);	
	
	FSM: process(state, addr_reg, rw, rw_reg, latencyCount_reg, addr, dataR_int)
	begin
		state_next <= state;
		addr_next <= addr_reg;
		latencyCount_next <= latencyCount_reg;
		rw_next <= rw_reg;
		dataR <= (others => 'Z'); 
		dwait <= '0';
		case state is
			when idle =>
				latencyCount_next <= (others => '0');
				dwait <= 'Z';
				if req = '1' and adv = '1' then
					state_next <= initBurst;
					addr_next <= addr; 
					rw_next <= rw; -- read or write 
					dwait <= '0';
				end if;
				
			when initBurst =>
				latencyCount_next <= latencyCount_reg + 1;
				if latencyCount_reg =  mem_latency then					
					state_next <= bursting;					
				end if;
				
			when bursting => 
				dwait <= '1';
				if rw_reg <= '1' then -- Burst read.
					dataR <= dataR_int;
				end if;
				addr_next <= std_logic_vector(unsigned( addr_reg )+ 1);
				-- Detect when crossing a row boundary. (simulate synchronous behaviour)
				if addr_reg(rowBoundarySize) /= addr_next(rowBoundarySize) then -- detect when bit value changes.
					latencyCount_next <= (others => '0');
					--dwait <= '0';
					state_next <= initBurst;
				end if;
				
		end case;
		
	end process FSM;
	
	registerTransfer: process(clk, req)
	begin
		if req = '0' then
			state <= idle;
		elsif rising_edge(clk) then
			state <= state_next;
			addr_reg <= addr_next;
			latencyCount_reg <= latencyCount_next;
			rw_reg <= rw_next;
		end if;	
	end process registerTransfer;
end Behavioral;

