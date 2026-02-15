library ieee;
    use ieee.std_logic_1164.all;

-------------------------------------------------

entity compare_4bit_tb is
-- Entity of testbench is always empty
end entity compare_4bit_tb;

-------------------------------------------------

architecture testbench of compare_4bit_tb is
    component compare_4bit is
        port (
            b      : in    std_logic_vector(3 downto 0);
            a      : in    std_logic_vector(3 downto 0);
            b_gt   : out   std_logic;
            b_a_eq : out   std_logic;
            a_gt   : out   std_logic
        );
    end component;

    -- Testbench local signals
    signal sig_b      : std_logic_vector(3 downto 0);
    signal sig_a      : std_logic_vector(3 downto 0);
    signal sig_b_gt   : std_logic;
    signal sig_b_a_eq : std_logic;
    signal sig_a_gt   : std_logic;
begin

    dut : component compare_4bit
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
        sig_b <= "0000"; sig_a <= "0000"; wait for 100 ns;
        assert (sig_b_gt = '0') and (sig_b_a_eq = '1') and (sig_a_gt = '0')
            report "Input combination b=0, a=0 FAILED" severity error;

        ------------------------------
        sig_b <= "0001"; sig_a <= "0001"; wait for 100 ns;
        assert (sig_b_gt = '0') and (sig_b_a_eq = '1') and (sig_a_gt = '0')
            report "Input combination b=1, a=1 FAILED" severity error;

        ------------------------------
        sig_b <= "0011"; sig_a <= "1100"; wait for 100 ns;
        assert (sig_b_gt = '0') and (sig_b_a_eq = '0') and (sig_a_gt = '1')
            report "Input combination b=3, a=12 FAILED" severity error;

        ------------------------------
        sig_b <= "1000"; sig_a <= "1001"; wait for 100 ns;
        assert (sig_b_gt = '0') and (sig_b_a_eq = '0') and (sig_a_gt = '1')
            report "Input combination b=8, a=9 FAILED" severity error;

        ------------------------------
        sig_b <= "1001"; sig_a <= "1000"; wait for 100 ns;
        assert (sig_b_gt = '1') and (sig_b_a_eq = '0') and (sig_a_gt = '0')
            report "Input combination b=9, a=8 FAILED" severity error;


        -- TODO: Write other test cases and asserts here


        report "Stimulus process finished";

        -- Data generation process is suspended forever
        wait;

    end process p_stimulus;

end architecture testbench;
