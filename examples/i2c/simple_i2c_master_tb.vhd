library ieee;
use ieee.std_logic_1164.all;

entity simple_i2c_master_tb is
end simple_i2c_master_tb;

architecture tb of simple_i2c_master_tb is

    component simple_i2c_master
        port (clk       : in  std_logic;
              rst       : in  std_logic;
              start     : in  std_logic;
              addr      : in  std_logic_vector (6 downto 0);
              -- data_in   : in  std_logic_vector (7 downto 0);
              rw        : in  std_logic;
              busy      : out std_logic;
              -- ack_error : out std_logic;
              scl       : out std_logic;
              sda       : out std_logic);
    end component;

    signal clk       : std_logic;
    signal rst       : std_logic;
    signal start     : std_logic;
    signal addr      : std_logic_vector (6 downto 0);
    -- signal data_in   : std_logic_vector (7 downto 0);
    signal rw        : std_logic;
    signal busy      : std_logic;
    -- signal ack_error : std_logic;
    signal scl       : std_logic;
    signal sda       : std_logic;

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : simple_i2c_master
    port map (clk       => clk,
              rst       => rst,
              start     => start,
              addr      => addr,
              -- data_in   => data_in,
              rw        => rw,
              busy      => busy,
              -- ack_error => ack_error,
              scl       => scl,
              sda       => sda);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;
    ----------------------------------------------------------------
    -- Stimulus
    ----------------------------------------------------------------
    stimuli : process
    begin
        -- Init
        start   <= '0';
        addr    <= b"101_0000";      -- example slave address
        -- data_in <= "11001100";     -- example data
        rw      <= '0';

        -- Reset
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        -- Start transaction
        report "Starting I2C transaction";
        start <= '1';
        wait for TbPeriod;
        start <= '0';

        -- Wait until busy goes high
        --  until busy = '1';
        report "Controller is busy";

        -- Wait until transaction completes
        -- wait until busy = '0';
        report "Transaction finished";

        -- Basic check
        assert busy = '0'
            report "ERROR: Busy should be low after transaction"
            severity error;

        report "Simulation completed successfully";

        wait for 500 ns;

        TbSimEnded <= '1';
        wait;
    end process;

    ----------------------------------------------------------------
    -- Optional waveform monitor (very useful!)
    ----------------------------------------------------------------
    -- monitor : process(clk)
    -- begin
    --     if rising_edge(clk) then
    --         report "SCL=" & std_logic'image(scl) &
    --                " SDA=" & std_logic'image(sda) &
    --                " BUSY=" & std_logic'image(busy);
    --     end if;
    -- end process;

end tb;
