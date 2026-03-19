library ieee;
use ieee.std_logic_1164.all;

entity uart_tx_tb is
end uart_tx_tb;

architecture tb of uart_tx_tb is

    component uart_tx
        port (clk         : in std_logic;
              rst         : in std_logic;
              data        : in std_logic_vector (7 downto 0);
              tx_start    : in std_logic;
              tx          : out std_logic;
              tx_complete : out std_logic);
    end component;

    signal clk         : std_logic;
    signal rst         : std_logic;
    signal data        : std_logic_vector (7 downto 0);
    signal tx_start    : std_logic;
    signal tx          : std_logic;
    signal tx_complete : std_logic;

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : uart_tx
    port map (clk         => clk,
              rst         => rst,
              data        => data,
              tx_start    => tx_start,
              tx          => tx,
              tx_complete => tx_complete);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- Initialization
        data <= (others => '0');
        tx_start <= '0';

        report "Reset generation";
        rst <= '1';
        wait for 50 ns;
        rst <= '0';
        wait for 50 ns;

        -------------------------------------------------
        report "Send first byte: 0x44";
        data <= x"44";
        tx_start <= '1';
        wait for TbPeriod;
        tx_start <= '0';

        -- Wait until transmission is complete
        wait until tx_complete = '1';
        wait for 10 * TbPeriod;  -- Small gap

        -------------------------------------------------
        report "Send next byte: 0x45";
        data <= x"45";
        tx_start <= '1';
        wait for TbPeriod;
        tx_start <= '0';

        wait until tx_complete = '1';
        wait for 10 * TbPeriod;

        -------------------------------------------------
        report "Send next byte: 0x31";
        data <= x"31";
        tx_start <= '1';
        wait for TbPeriod;
        tx_start <= '0';

        wait until tx_complete = '1';
        wait for 10 * TbPeriod;

        -------------------------------------------------
        report "Stop the clock and hence terminate the simulation";
        TbSimEnded <= '1';
        wait;
    end process;

end tb;
