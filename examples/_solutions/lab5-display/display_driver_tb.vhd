library ieee;
use ieee.std_logic_1164.all;

entity display_driver_tb is
end display_driver_tb;

architecture tb of display_driver_tb is

    component display_driver
        port (clk   : in  std_logic;
              rst   : in  std_logic;
              data  : in  std_logic_vector(7 downto 0);
              seg   : out std_logic_vector(6 downto 0);
              anode : out std_logic_vector(1 downto 0));
    end component;

    signal clk   : std_logic;
    signal rst   : std_logic;
    signal data  : std_logic_vector(7 downto 0);
    signal seg   : std_logic_vector(6 downto 0);
    signal anode : std_logic_vector(1 downto 0);

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : component display_driver
    port map (clk   => clk,
              rst   => rst,
              data  => data,
              seg   => seg,
              anode => anode);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    clk <= TbClock;

    stimuli : process
    begin
        data <= x"00";

        -- Reset generation
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        data <= x"18";
        wait for 50 * TbPeriod;

        data <= x"19";
        wait for 50 * TbPeriod;

        data <= x"20";
        wait for 50 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;
