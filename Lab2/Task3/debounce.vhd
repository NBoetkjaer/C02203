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

architecture Behavioral of debounce is
	constant N: integer:=20;  -- filter of 2^N * 10ns = 10ms
	-- N should be set to 20 when synthesizing and 2 when simulating.
   type state_type is (zero, wait0, one, wait1);
   signal state_reg, state_next: state_type;
   signal q_reg, q_next: unsigned(N-1 downto 0);
   signal q_load, q_dec, q_zero: std_logic;
	signal sw_reg1, sw_reg2 : std_logic;
begin

	process(clk,reset)
	begin
		if reset='1' then
			sw_reg2 <= '0';
			sw_reg1 <= '0';
		elsif rising_edge(clk) then
			sw_reg2 <= sw_reg1;
			sw_reg1 <= sw;
		end if;
	end process;
	-- FSMD state & data registers
   process(clk,reset)
   begin
      if reset='1' then
         state_reg <= zero;
         q_reg <= (others=>'0');
      elsif (rising_edge(clk)) then
         state_reg <= state_next;
         q_reg <= q_next;
      end if;
   end process;

   -- FSMD data path (counter) next-state logic
   q_next <= (others=>'1') when q_load='1' else
             q_reg - 1 when q_dec='1' else
             q_reg;
   q_zero <= '1' when q_next=0 else '0';

   -- FSMD control path next-state logic
   process(state_reg,sw_reg2,q_zero)
   begin
      q_load <= '0';
      q_dec <= '0';
      db_tick <= '0';
      state_next <= state_reg;
      case state_reg is
         when zero =>
            db_level <= '0';
            if sw_reg2='1' then
               state_next <= wait1;
               q_load <= '1';
            end if;
         when wait1=>
            db_level <= '0';
            if sw_reg2='1' then
               q_dec <= '1';
               if q_zero='1' then
                  state_next <= one;
                  db_tick <= '1';
               end if;
            else -- sw_reg2='0'
               state_next <= zero;
            end if;
         when one =>
            db_level <= '1';
            if sw_reg2='0' then
               state_next <= wait0;
               q_load <= '1';
            end if;
         when wait0=>
            db_level <= '1';
            if sw_reg2='0' then
               q_dec <= '1';
               if q_zero='1' then
                  state_next <= zero;
               end if;
            else -- sw_reg2='1'
               state_next <= one;
            end if;
      end case;
   end process;

end Behavioral;

