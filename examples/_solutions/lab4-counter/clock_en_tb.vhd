-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 29.2.2024 08:01:35 UTC

library ieee;
  use ieee.std_logic_1164.all;

entity tb_clock_en is
end entity tb_clock_en;

architecture tb of tb_clock_en is

  component clock_en is
    generic (
      n_periods : integer
    );
    port (
      clk   : in    std_logic;
      rst   : in    std_logic;
      pulse : out   std_logic
    );
  end component clock_en;

  signal clk   : std_logic;
  signal rst   : std_logic;
  signal pulse : std_logic;

  constant tbperiod   : time      := 10 ns; -- EDIT Put right period here
  signal   tbclock    : std_logic := '0';
  signal   tbsimended : std_logic := '0';

begin

  dut : component clock_en
    generic map (
      n_periods => 11
    )
    port map (
      clk   => clk,
      rst   => rst,
      pulse => pulse
    );

  -- Clock generation
  tbclock <= not tbclock after tbperiod / 2 when tbsimended /= '1' else
             '0';

  -- EDIT: Check that clk is really your main clock signal
  clk <= tbclock;

  stimuli : process is
  begin

    -- EDIT Adapt initialization as needed

    -- Reset generation
    -- EDIT: Check that rst is really your reset signal
    rst <= '1';
    wait for 100 ns;
    rst <= '0';
    wait for 100 ns;

    -- EDIT Add stimuli here
    wait for 100 * tbperiod;

    -- Stop the clock and hence terminate the simulation
    tbsimended <= '1';
    wait;

  end process stimuli;

end architecture tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_clock_en of tb_clock_en is
    for tb
    end for;
end cfg_tb_clock_en;
