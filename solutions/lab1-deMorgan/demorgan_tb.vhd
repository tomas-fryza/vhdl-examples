library ieee;
    use ieee.std_logic_1164.all;

--------------------------------------------------

entity demorgan_tb is
-- Entity of testbench is always empty
end entity demorgan_tb;

--------------------------------------------------

architecture testbench of demorgan_tb is
    component demorgan is
        port (
            a     : in    std_logic;
            b     : in    std_logic;
            c     : in    std_logic;
            f_org : out   std_logic;
            f_and : out   std_logic;
            f_or  : out   std_logic
        );
    end component;

    -- Testbench local signals
    signal sig_c   : std_logic;
    signal sig_b   : std_logic;
    signal sig_a   : std_logic;
    signal sig_org : std_logic;
    signal sig_and : std_logic;
    signal sig_or  : std_logic;
begin

    -- Connecting local testbench signals to `morgan`
    -- component (Design Under Test)
    dut : component demorgan
        port map (
            c     => sig_c,
            b     => sig_b,
            a     => sig_a,
            f_org => sig_org,
            f_and => sig_and,
            f_or  => sig_or
        );

    ------------------------------------------------
    -- Testing data generation process
    ------------------------------------------------

    p_stimulus : process is
    begin

        -- Set one test case and wait for 100 ns ...
        sig_c <= '0';
        sig_b <= '0';
        sig_a <= '0';
        wait for 100 ns;

        -- ... and then continue with other test cases
        sig_c <= '0';
        sig_b <= '0';
        sig_a <= '1';
        wait for 100 ns;

        sig_c <= '0';
        sig_b <= '1';
        sig_a <= '0';

        wait for 100 ns;
        sig_c <= '0';
        sig_b <= '1';
        sig_a <= '1';
        wait for 100 ns;

        sig_c <= '1';
        sig_b <= '0';
        sig_a <= '0';
        wait for 100 ns;

        sig_c <= '1';
        sig_b <= '0';
        sig_a <= '1';
        wait for 100 ns;

        sig_c <= '1';
        sig_b <= '1';
        sig_a <= '0';
        wait for 100 ns;

        sig_c <= '1';
        sig_b <= '1';
        sig_a <= '1';
        wait for 100 ns;

        wait; -- Generation process is suspended forever

    end process p_stimulus;

end architecture testbench;
