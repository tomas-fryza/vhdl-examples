-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 29.2.2024 08:01:35 UTC

library ieee;
  use ieee.std_logic_1164.all;

entity clk_en_tb is
end entity clk_en_tb;

architecture tb of clk_en_tb is

  component clk_en is
    generic (
      G_MAX : positive
    );
    port (
      clk : in  std_logic;
      rst : in  std_logic;
      ce  : out std_logic
    );
  end component clk_en;

  signal clk : std_logic;
  signal rst : std_logic;
  signal ce  : std_logic;

  constant tbperiod   : time      := 10 ns;
  signal   tbclock    : std_logic := '0';
  signal   tbsimended : std_logic := '0';

begin

  dut : component clk_en
    generic map (
      G_MAX => 10  -- Change only this value to modify counting
    )
    port map (
      clk => clk,
      rst => rst,
      ce  => ce
    );

  -- Clock generation
  tbclock <= not tbclock after tbperiod / 2 when tbsimended /= '1' else
             '0';

  -- EDIT: Check that clk is really your main clock signal
  clk <= tbclock;

  stimuli : process is
  begin

    -- Reset generation
    rst <= '1';
    wait for 50 ns;
    rst <= '0';

    wait for 200 * tbperiod;

    -- Stop the clock and hence terminate the simulation
    tbsimended <= '1';
    wait;

  end process stimuli;

end architecture tb;
