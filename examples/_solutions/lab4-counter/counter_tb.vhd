-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 28.2.2024 21:53:41 UTC

library ieee;
  use ieee.std_logic_1164.all;

-------------------------------------------------

entity counter_tb is
end entity counter_tb;

-------------------------------------------------

architecture tb of counter_tb is

    component counter is
        generic (
            G_BITS : positive
        );
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            en  : in  std_logic;
            cnt : out std_logic_vector(G_BITS - 1 downto 0)
        );
    end component counter;

    constant C_BITS : integer := 5;  -- Change only this value to scale the counter
    signal   clk    : std_logic;
    signal   rst    : std_logic;
    signal   en     : std_logic;
    signal   cnt    : std_logic_vector(C_BITS - 1 downto 0);

    constant tbperiod   : time      := 10 ns;
    signal   tbclock    : std_logic := '0';
    signal   tbsimended : std_logic := '0';

begin

    dut : component counter
        generic map (
            G_BITS => C_BITS
        )
        port map (
            clk => clk,
            rst => rst,
            en  => en,
            cnt => cnt
        );

    -- Clock generation
    tbclock <= not tbclock after tbperiod / 2 when tbsimended /= '1' else
                   '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= tbclock;

    stimuli : process is
    begin

        en <= '1';

        -- Reset generation
        rst <= '1';
        wait for 50 ns;
        rst <= '0';
        wait for 100 ns;

        wait for 33 * tbperiod;
        en <= '0';
        wait for 6 * tbperiod;
        en <= '1';
        wait for 1 * tbperiod;
        en <= '0';
        wait for 6 * tbperiod;
        en <= '1';
        wait for 1 * tbperiod;
        en <= '0';
        wait for 6 * tbperiod;
        en <= '1';
        wait for 1 * tbperiod;
        en <= '0';
        wait for 6 * tbperiod;

        -- Stop the clock and hence terminate the simulation
        tbsimended <= '1';
        wait;

    end process stimuli;
end architecture tb;
