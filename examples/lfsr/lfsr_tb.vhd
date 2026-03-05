-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 21.3.2025 06:14:58 UTC

library ieee;
  use ieee.std_logic_1164.all;

entity tb_lfsr is
end entity tb_lfsr;

architecture tb of tb_lfsr is

  component lfsr is
    generic (
      n_bits : integer
    );
    port (
      clk      : in    std_logic;
      rst      : in    std_logic;
      en       : in    std_logic;
      load     : in    std_logic;
      lfsr_in  : in    std_logic_vector(n_bits - 1 downto 0);
      done     : out   std_logic;
      lfsr_out : out   std_logic_vector(n_bits - 1 downto 0)
    );
  end component lfsr;

  signal   clk      : std_logic;
  signal   rst      : std_logic;
  signal   en       : std_logic;
  signal   load     : std_logic;
  constant c_nbits  : integer := 5; -- !!! Simulating number of bits !!!
  signal   lfsr_in  : std_logic_vector(c_nbits - 1 downto 0);
  signal   done     : std_logic;
  signal   lfsr_out : std_logic_vector(c_nbits - 1 downto 0);

  constant tbperiod   : time      := 10 ns; -- EDIT Put right period here
  signal   tbclock    : std_logic := '0';
  signal   tbsimended : std_logic := '0';

begin

  dut : component lfsr
    generic map (
      n_bits => c_nbits
    )
    port map (
      clk      => clk,
      rst      => rst,
      en       => en,
      load     => load,
      lfsr_in  => lfsr_in,
      done     => done,
      lfsr_out => lfsr_out
    );

  -- Clock generation
  tbclock <= not tbclock after tbperiod / 2 when tbsimended /= '1' else
             '0';

  -- EDIT: Check that clk is really your main clock signal
  clk <= tbclock;

  stimuli : process is
  begin

    -- EDIT Adapt initialization as needed
    en      <= '0';
    load    <= '0';
    lfsr_in <= (others => '0');

    -- Reset generation
    -- EDIT: Check that rst is really your reset signal
    rst <= '1';
    wait for 23 ns;
    rst <= '0';
    wait for 45 ns;
    en  <= '1';

    -- EDIT Add stimuli here
    wait for 64 * tbperiod;
    load <= '1';
    wait for 33 ns;
    load <= '0';

    wait for 20 * tbperiod;

    -- Stop the clock and hence terminate the simulation
    tbsimended <= '1';
    wait;

  end process stimuli;

end architecture tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_lfsr of tb_lfsr is
    for tb
    end for;
end cfg_tb_lfsr;
