library ieee;
    use ieee.std_logic_1164.all;

-------------------------------------------------

entity compare_2bit_tb is
-- Entity of testbench is always empty
end entity compare_2bit_tb;

-------------------------------------------------

architecture testbench of compare_2bit_tb is
    component compare_2bit is
        port (
            b      : in    std_logic_vector(1 downto 0);
            a      : in    std_logic_vector(1 downto 0);
            b_gt   : out   std_logic;
            b_a_eq : out   std_logic;
            a_gt   : out   std_logic
        );
    end component;

    -- Testbench local signals
    signal sig_b      : std_logic_vector(1 downto 0);
    signal sig_a      : std_logic_vector(1 downto 0);
    signal sig_b_gt   : std_logic;
    signal sig_b_a_eq : std_logic;
    signal sig_a_gt   : std_logic;
begin

    dut : component compare_2bit
        port map (
            b      => sig_b,
            a      => sig_a,
            b_gt   => sig_b_gt,
            b_a_eq => sig_b_a_eq,
            a_gt   => sig_a_gt
        );

    -----------------------------------------------
    p_stimulus : process is
    begin

        -- Report a note at the beginning of stimulus process
        report "Stimulus process started";

        -- Test case is followed by the expected output
        -- value(s). If assert condition is false, then
        -- an error is reported to the console.
        sig_b <= "00";
        sig_a <= "00";
        wait for 100 ns;
        assert (sig_b_gt = '0') and (sig_b_a_eq = '1') and (sig_a_gt = '0')
            report "Input combination b=0, a=0 FAILED" severity error;

        ------------------------------
        -- WRITE OTHER TEST CASES AND ASSERTS HERE
        sig_b <= "01";
        sig_a <= "01";
        wait for 100 ns;
        assert (sig_b_gt = '0') and (sig_b_a_eq = '1') and (sig_a_gt = '0')
            report "Input combination b=1, a=1 FAILED" severity error;

        ------------------------------
        sig_b <= "10";
        sig_a <= "11";
        wait for 100 ns;
        assert (sig_b_gt = '0') and (sig_b_a_eq = '0') and (sig_a_gt = '1')
            report "Input combination b=2, a=3 FAILED" severity error;

        ------------------------------
        sig_b <= "01";
        sig_a <= "10";
        wait for 100 ns;
        assert (sig_b_gt = '0') and (sig_b_a_eq = '0') and (sig_a_gt = '1')
            report "Input combination b=1, a=2 FAILED" severity error;

        ------------------------------
        sig_b <= "10";
        sig_a <= "01";
        wait for 100 ns;
        assert (sig_b_gt = '1') and (sig_b_a_eq = '0') and (sig_a_gt = '0')
            report "Input combination b=2, a=1 FAILED" severity error;

        report "Stimulus process finished";

        -- Data generation process is suspended forever
        wait;

    end process p_stimulus;

end architecture testbench;
