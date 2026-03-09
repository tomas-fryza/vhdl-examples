library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity tb_debounce is
end entity tb_debounce;

architecture behavior of tb_debounce is
    -- Component Declaration for the Device Under Test (DUT)
    component debounce is
        port (
            clk      : in    std_logic;
            rst      : in    std_logic;
            en       : in    std_logic;
            bouncey  : in    std_logic;
            clean    : out   std_logic;
            pos_edge : out   std_logic;
            neg_edge : out   std_logic
        );
    end component;

    -- Inputs
    signal clock     : std_logic;
    signal reset     : std_logic;
    signal clock_en  : std_logic;
    signal button_in : std_logic;
    -- Output
    signal pulse_out : std_logic;
    signal pos_edge  : std_logic;
    signal neg_edge  : std_logic;

    -- Clock period definitions
    constant TbPeriod   : time      := 10 ns;
    signal   TbClock    : std_logic := '0';
    signal   TbSimEnded : std_logic := '0';
begin

    -- Instantiate the Device Under Test (DUT)
    dut : debounce
        port map (
            clk      => clock,
            rst      => reset,
            en       => clock_en,
            bouncey  => button_in,
            clean    => pulse_out,
            pos_edge => pos_edge,
            neg_edge => neg_edge
        );

    -- Clock generation
    TbClock <= not TbClock after TbPeriod / 2 when TbSimEnded /= '1' else
               '0';

    -- EDIT: Check that clk is really your main clock signal
    clock <= TbClock;

    -- Stimulus process
    stim_proc : process is
    begin

        clock_en  <= '1';
        button_in <= '0';
        reset     <= '1';
        wait for TbPeriod * 3;
        reset     <= '0';

        -- first activity
        wait for TbPeriod * 10;
        button_in <= '1';
        wait for TbPeriod * 2;
        button_in <= '0';
        wait for TbPeriod * 1;
        button_in <= '1';
        wait for TbPeriod * 1;
        button_in <= '0';
        wait for TbPeriod * 15;

        -- second activity
        button_in <= '1';
        wait for TbPeriod * 1;
        button_in <= '0';
        wait for TbPeriod * 1;
        button_in <= '1';
        wait for TbPeriod * 1;
        button_in <= '0';
        wait for TbPeriod * 2;
        button_in <= '1';
        wait for TbPeriod * 10;
        button_in <= '0';
        wait for TbPeriod * 1;
        button_in <= '1';
        wait for TbPeriod * 10;

        -- third activity
        button_in <= '0';
        wait for TbPeriod * 2;
        button_in <= '1';
        wait for TbPeriod * 1;
        button_in <= '0';
        wait for TbPeriod * 1;
        button_in <= '1';
        wait for TbPeriod * 1;
        button_in <= '0';
        wait for TbPeriod * 10;

        -- forth activity
        clock_en  <= '0';
        wait for TbPeriod * 5;
        button_in <= '1';
        wait for TbPeriod * 2;
        button_in <= '0';
        wait for TbPeriod * 1;
        button_in <= '1';
        wait for TbPeriod * 1;
        button_in <= '0';
        wait for TbPeriod * 10;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;

    end process stim_proc;

end architecture behavior;
