-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Wed, 09 Apr 2025 14:20:02 GMT
-- Request id : cfwk-fed377c2-67f6821292f8f

library ieee;
    use ieee.std_logic_1164.all;

entity tb_uart_tx is
end entity tb_uart_tx;

architecture tb of tb_uart_tx is
    component uart_tx is
        generic (
            CLK_FREQ : integer;
            BAUDRATE : integer
        );
        port (
            clk      : in    std_logic;
            rst      : in    std_logic;
            tx_data  : in    std_logic_vector(7 downto 0);
            tx_start : in    std_logic;
            tx       : out   std_logic;
            done     : out   std_logic
        );
    end component uart_tx;

    signal clk      : std_logic;
    signal rst      : std_logic;
    signal tx_data  : std_logic_vector(7 downto 0);
    signal tx_start : std_logic;
    signal tx       : std_logic;
    signal done     : std_logic;

    constant TBPERIOD   : time      := 10 ns; -- ***EDIT*** Put right period here
    signal   tbclock    : std_logic := '0';
    signal   tbsimended : std_logic := '0';

begin
    dut : uart_tx
        generic map (
            CLK_FREQ => 100_000_000,
            BAUDRATE => 15_600_000
        )
        port map (
            clk      => clk,
            rst      => rst,
            tx_data  => tx_data,
            tx_start => tx_start,
            tx       => tx,
            done     => done
        );

    -- Clock generation
    tbclock <= not tbclock after TBPERIOD / 2 when tbsimended /= '1' else
               '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= tbclock;

    stimuli : process is
    begin
        -- Reset generation
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for 20 ns;

        tx_data  <= b"0101_0101";
        wait for 3 * TBPERIOD;
        tx_start <= '1';
        wait for 1 * TBPERIOD;
        tx_start <= '0';
        wait for 100 * TBPERIOD;

        tx_data  <= x"43";
        wait for 3 * TBPERIOD;
        tx_start <= '1';
        wait for 1 * TBPERIOD;
        tx_start <= '0';
        wait for 100 * TBPERIOD;

        -- Stop the clock and hence terminate the simulation
        tbsimended <= '1';
        wait;
    end process stimuli;

end architecture tb;
