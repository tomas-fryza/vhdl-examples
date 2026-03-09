library ieee;
    use ieee.std_logic_1164.all;

-------------------------------------------------
-- Entity declaration for testbench
-------------------------------------------------

entity tb_blink is
-- Entity of testbench is always empty
end entity tb_blink;

-------------------------------------------------
-- Architecture body for testbench
-------------------------------------------------

architecture testbench of tb_blink is
    component blink is
        port (
            clk : in    std_logic;
            rst : in    std_logic;
            led : out   std_logic
        );
    end component;

    constant c_clk_100mhz_period : time := 10 ns;

    -- Local signals
    signal sig_clk_100mhz : std_logic;
    signal sig_rst        : std_logic;
    signal sig_led        : std_logic;
begin

    dut : blink
        port map (
            clk => sig_clk_100mhz,
            rst => sig_rst,
            led => sig_led
        );

    -----------------------------------------------
    -- Clock generation process
    -----------------------------------------------
    p_clk_gen : process is
    begin

        -- 75 periods of 100MHz clock
        while now < 750 ns loop

            sig_clk_100mhz <= '0';
            wait for c_clk_100mhz_period / 2;
            sig_clk_100mhz <= '1';
            wait for c_clk_100mhz_period / 2;

        end loop;

        -- Process is suspended forever
        wait;

    end process p_clk_gen;

    -----------------------------------------------
    -- Reset generation process
    -----------------------------------------------
    p_reset_gen : process is
    begin

        sig_rst <= '0';
        wait for 13 ns;

        -- Reset activated
        sig_rst <= '1';
        wait for 20 ns;

        -- Reset deactivated
        sig_rst <= '0';

        wait;

    end process p_reset_gen;

    -----------------------------------------------
    -- Input data generation process
    -----------------------------------------------
    p_stimulus : process is
    begin

        report "Stimulus process started";
        -- No other input data is needed
        report "Stimulus process finished";

        wait;

    end process p_stimulus;

end architecture testbench;
