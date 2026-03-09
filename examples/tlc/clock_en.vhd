----------------------------------------------------------
--
--! @title Clock enable
--! @author Tomas Fryza
--! Dept. of Radio Electronics, Brno Univ. of Technology, Czechia
--!
--! @copyright (c) 2019 Tomas Fryza
--! This work is licensed under the terms of the MIT license
--!
--! Generates clock enable signal according to the number
--! of clock pulses `g_MAX`.
--
-- Hardware: Nexys A7-50T, xc7a50ticsg324-1L
-- Software: TerosHDL, Vivado 2020.2, EDA Playground
--
----------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all; -- Package for arithmetic operations

----------------------------------------------------------
-- Entity declaration for clock enable
----------------------------------------------------------

entity clock_en is
  generic ( g_MAX : natural := 5 );  --! Number of clk pulses to generate one enable signal period
                                     -- Note that there IS a semicolon between generic and port sections
  port (
    clk : in    std_logic; --! Main clock
    rst : in    std_logic; --! High-active synchronous reset
    ce  : out   std_logic  --! Clock enable pulse signal
  );
end entity clock_en;

------------------------------------------------------------
-- Architecture body for clock enable
------------------------------------------------------------

architecture Behavioral of clock_en is

  -- Local counter
  signal sig_cnt : natural;

begin

  --------------------------------------------------------
  -- p_clk_enable:
  -- Generate clock enable signal. By default, enable signal
  -- is low and generated pulse is always one clock long.
  --------------------------------------------------------
  p_clk_enable : process (clk) is
  begin

    if (rising_edge(clk)) then            -- Synchronous process
      if (rst = '1') then                 -- High-active reset
        sig_cnt <= 0;                     -- Clear local counter
        ce      <= '0';                   -- Set output to low

      -- Test number of clock periods
      elsif (sig_cnt >= (g_MAX - 1)) then
        sig_cnt <= 0;                     -- Clear local counter
        ce      <= '1';                   -- Generate clock enable pulse
      else
        sig_cnt <= sig_cnt + 1;
        ce      <= '0';
      end if;
    end if;

  end process p_clk_enable;

end Behavioral;
