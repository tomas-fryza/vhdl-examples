----------------------------------------------------------
--
--! @title Top-level for traffic light controller using 2 RGB LEDs
--! @author Tomas Fryza
--! Dept. of Radio Electronics, Brno Univ. of Technology, Czechia
--!
--! @copyright (c) 2020 Tomas Fryza
--! This work is licensed under the terms of the MIT license
--
-- Hardware: Nexys A7-50T, xc7a50ticsg324-1L
-- Software: TerosHDL, Vivado 2020.2, EDA Playground
--
----------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;

----------------------------------------------------------
-- Entity declaration for top level
----------------------------------------------------------

entity top is
  port (
    CLK100MHZ : in    std_logic; --! Main clock
    LED16_R   : out   std_logic; --! South: Red
    LED16_G   : out   std_logic; --! South: Green
    LED16_B   : out   std_logic; --! South: Blue
    LED17_R   : out   std_logic; --! West: Red
    LED17_G   : out   std_logic; --! West: Green
    LED17_B   : out   std_logic; --! West: Blue
    BTNC      : in    std_logic --! Synchronous reset
  );
end entity top;

----------------------------------------------------------
-- Architecture body for top level
----------------------------------------------------------

architecture Behavioral of top is

begin
  --------------------------------------------------------
  -- Instance (copy) of tlc entity
  --------------------------------------------------------
  tlc : entity work.tlc
    port map (
      clk      => CLK100MHZ,
      south(2) => LED16_R,
      -- MAP OTHER RGB LEDS (SOUTH and WEST) HERE
      south(1) => LED16_G,
      south(0) => LED16_B,
      west(2)  => LED17_R,
      west(1)  => LED17_G,
      west(0)  => LED17_B,
      rst      => BTNC
    );

end Behavioral;
