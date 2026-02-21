library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;  -- Required for "to_unsigned"

-------------------------------------------------

entity bin2seg_tb is
-- Entity of testbench is always empty
end entity bin2seg_tb;

-------------------------------------------------

architecture testbench of bin2seg_tb is
    component bin2seg is
        port (
            bin : in  std_logic_vector(3 downto 0);
            seg : out std_logic_vector(6 downto 0)
        );
    end component;

    -- Testbench internal signals
    signal sig_bin : std_logic_vector(3 downto 0);
    signal sig_seg : std_logic_vector(6 downto 0);
begin

    dut : component bin2seg
        port map (
            bin => sig_bin,
            seg => sig_seg
        );

    -----------------------------------------------
    -- Data generation process
    -----------------------------------------------
    p_stimulus : process is
    begin

        report "Stimulus process started";

        -- Loop through all hexadecimal values (0 to 15)
        for i in 0 to 15 loop

            -- Convert integer i to 4-bit std_logic_vector
            sig_bin <= std_logic_vector(to_unsigned(i, 4));
            -- sig_bin <= std_logic_vector(to_unsigned(i, sig_bin'length));
            wait for 10 ns;

            -- Expected segment values
            case sig_bin is

                when x"0" =>
                    assert sig_seg = "0000001"
                        report "0 does not map to 0000001"
                        severity error;

                when x"1" =>
                    assert sig_seg = "1001111"
                        report "1 does not map to 1001111"
                        severity error;

                when x"2" =>
                    assert sig_seg = "0010010"
                        report "2 does not map to 0010010"
                        severity error;

                when x"3" =>
                    assert sig_seg = "0000110"
                        report "3 does not map to 0000110"
                        severity error;

                when x"4" =>
                    assert sig_seg = "1001100"
                        report "4 does not map to 1001100"
                        severity error;

                when x"5" =>
                    assert sig_seg = "0100100"
                        report "5 does not map to 0100100"
                        severity error;

                when x"6" =>
                    assert sig_seg = "0100000"
                        report "6 does not map to 0100000"
                        severity error;

                when x"7" =>
                    assert sig_seg = "0001111"
                        report "7 does not map to 0001111"
                        severity error;

                when x"8" =>
                    assert sig_seg = "0000000"
                        report "8 does not map to 0000000"
                        severity error;

                when x"9" =>
                    assert sig_seg = "0000100"
                        report "9 does not map to 0000100"
                        severity error;

                when others =>
                    null;  -- No assertion for other input combinations

            end case;

        end loop;

        report "Stimulus process finished";
        wait;

    end process p_stimulus;

end architecture testbench;
