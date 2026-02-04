library ieee;
    use ieee.std_logic_1164.all;

-------------------------------------------------

entity gates_tb is
-- Entity of testbench is always empty
end entity gates_tb;

-------------------------------------------------

architecture testbench of gates_tb is
    component gates is
        port (
            a     : in    std_logic;
            b     : in    std_logic;
            y_and : out   std_logic;
            y_or  : out   std_logic;
            y_xor : out   std_logic
        );
    end component;

    -- Testbench local signals
    signal sig_a, sig_b : std_logic;
    signal sig_and      : std_logic;
    signal sig_or       : std_logic;
    signal sig_xor      : std_logic;
begin

    -- Instantiate the design under test (DUT)
    dut : component gates
        port map (
            a     => sig_a,
            b     => sig_b,
            y_and => sig_and,
            y_or  => sig_or,
            y_xor => sig_xor
        );

    -- Test stimulus
    stimulus_process : process is
    begin

        sig_b <= '0';
        sig_a <= '0';
        wait for 100 ns;
        sig_b <= '0';
        sig_a <= '1';
        wait for 100 ns;
        sig_b <= '1';
        sig_a <= '0';
        wait for 100 ns;
        sig_b <= '1';
        sig_a <= '1';
        wait for 100 ns;
        sig_b <= '0';
        sig_a <= '0';
        wait for 100 ns;

        wait;

    end process stimulus_process;

end architecture testbench;
