-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Wed, 01 Apr 2026 05:07:04 GMT
-- Request id : cfwk-fed377c2-69cca7f86593c

library ieee;
use ieee.std_logic_1164.all;

entity simple_i2c_tb is
end entity;

architecture tb of simple_i2c_tb is

    component simple_i2c
        port (clk       : in std_logic;
              rst       : in std_logic;
              addr      : in std_logic_vector (6 downto 0);
              start     : in std_logic;
              scl       : out std_logic;
              sda       : inout std_logic;
              ack_error : out std_logic;
              busy      : out std_logic);
    end component;

    signal clk       : std_logic;
    signal rst       : std_logic;
    signal addr      : std_logic_vector (6 downto 0);
    signal start     : std_logic;
    signal scl       : std_logic;
    signal sda       : std_logic;
    signal ack_error : std_logic;
    signal busy      : std_logic;

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : simple_i2c
    port map (clk       => clk,
              rst       => rst,
              addr      => addr,
              start     => start,
              scl       => scl,
              sda       => sda,
              ack_error => ack_error,
              busy      => busy);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- Initialization
        addr  <= (others => '0');
        start <= '0';

        -- Reset
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        -------------------------------------------------
        -- TEST 1: Valid transfer with ACK
        -------------------------------------------------
        addr <= b"101_0000"; -- example address

        wait for 2 * TbPeriod;
        start <= '1';
        wait for TbPeriod;
        start <= '0';

        -- Wait for transaction to complete
        wait until busy = '1';
        wait until busy = '0';

        wait for 10 * TbPeriod;

        -------------------------------------------------
        -- TEST 2: NACK case (no slave response)
        -------------------------------------------------
        addr <= b"110_0000";

        wait for 2 * TbPeriod;
        start <= '1';
        wait for TbPeriod;
        start <= '0';

        -- Wait for transaction to complete
        wait until busy = '1';
        wait until busy = '0';

        wait for 20 * TbPeriod;

        -------------------------------------------------
        -- End simulation
        -------------------------------------------------
        TbSimEnded <= '1';
        wait;
    end process;

end tb;
