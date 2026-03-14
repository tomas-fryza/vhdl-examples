library ieee;
use ieee.std_logic_1164.all;

entity debounce_tb is
end entity;

architecture tb of debounce_tb is

    ------------------------------------------------
    -- constants
    ------------------------------------------------
    constant CLK_PERIOD : time := 10 ns;

    ------------------------------------------------
    -- signals
    ------------------------------------------------
    signal clk         : std_logic := '1';
    signal rst         : std_logic;
    signal btn_in      : std_logic;

    signal btn_state   : std_logic;
    signal btn_press   : std_logic;
    signal btn_release : std_logic;

    signal TbSimEnded  : std_logic := '0';

    component debounce
    port (
        clk         : in  std_logic;
        rst         : in  std_logic;
        btn_in      : in  std_logic;

        btn_state   : out std_logic;  -- debounced level
        btn_press   : out std_logic;  -- 1-clock press pulse
        btn_release : out std_logic   -- 1-clock release pulse
    );
    end component;

begin

    ------------------------------------------------
    -- DUT
    ------------------------------------------------
    dut : debounce
    port map (
        clk         => clk,
        rst         => rst,
        btn_in      => btn_in,
        btn_state   => btn_state,
        btn_press   => btn_press,
        btn_release => btn_release
    );

    ------------------------------------------------
    -- clock generator
    ------------------------------------------------
    clk <= not clk after CLK_PERIOD/2 when TbSimEnded /= '1' else '0';

    ------------------------------------------------
    -- stimulus process
    ------------------------------------------------
    p_stim : process
    begin

        btn_in <= '0';

        ------------------------------------------------
        -- reset phase
        ------------------------------------------------
        rst <= '1';
        wait for 100 ns;
        rst <= '0';

        ------------------------------------------------
        -- simulate button bounce on press
        ------------------------------------------------
        report "Simulating button press with bounce";

        wait for 100 ns;
        btn_in <= '1';
        wait for 50 ns;
        btn_in <= '0';
        wait for 50 ns;
        btn_in <= '1';
        wait for 250 ns;
        btn_in <= '0';  -- final stable press

        wait for 20 ns;

        ------------------------------------------------
        -- simulate button bounce on release
        ------------------------------------------------
        report "Simulating button release with bounce";

        btn_in <= '1';
        wait for 60 ns;
        btn_in <= '0';
        wait for 30 ns;
        btn_in <= '1';
        wait for 50 ns;
        btn_in <= '0';  -- final release
        wait for 300 ns;

        ------------------------------------------------
        report "Simulation finished";
        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;

    end process;

end architecture;
