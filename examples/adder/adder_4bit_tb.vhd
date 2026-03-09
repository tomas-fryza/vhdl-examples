-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 20.2.2024 10:25:25 UTC

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all; -- Definition of "to_unsigned"

entity tb_adder_4bit is
end entity tb_adder_4bit;

architecture tb of tb_adder_4bit is
    component adder_4bit is
        port (
            c_in   : in    std_logic;
            b      : in    std_logic_vector(3 downto 0);
            a      : in    std_logic_vector(3 downto 0);
            c_out  : out   std_logic;
            result : out   std_logic_vector(3 downto 0)
        );
    end component;

    signal c_in   : std_logic;
    signal b      : std_logic_vector(3 downto 0);
    signal a      : std_logic_vector(3 downto 0);
    signal c_out  : std_logic;
    signal result : std_logic_vector(3 downto 0);
begin

    dut : adder_4bit
        port map (
            c_in   => c_in,
            b      => b,
            a      => a,
            c_out  => c_out,
            result => result
        );

    stimuli : process is
    begin

        report "Stimulus process started";

        -- EDIT Adapt initialization as needed
        c_in <= '0';
        b    <= x"0";
        -- Loop for all hex values
        for i in 0 to 15 loop

            -- Convert decimal value `i` to 4-bit wide binary
            a <= std_logic_vector(to_unsigned(i, a'length));
            wait for 10 ns;

        end loop;

        c_in <= '0';
        b    <= x"6";
        -- Loop for all hex values
        for i in 0 to 15 loop

            -- Convert decimal value `i` to 4-bit wide binary
            a <= std_logic_vector(to_unsigned(i, a'length));
            wait for 10 ns;

        end loop;

        c_in <= '1';
        b    <= x"3";
        -- Loop for all hex values
        for i in 0 to 15 loop

            -- Convert decimal value `i` to 4-bit wide binary
            a <= std_logic_vector(to_unsigned(i, a'length));
            wait for 10 ns;

        end loop;

        c_in <= '0';
        b    <= x"7";
        -- Loop for all hex values
        for i in 0 to 15 loop

            -- Convert decimal value `i` to 4-bit wide binary
            a <= std_logic_vector(to_unsigned(i, a'length));
            wait for 10 ns;

        end loop;

        report "Stimulus process finished";
        wait;

    end process stimuli;

end architecture tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_adder_4bit of tb_adder_4bit is
    for tb
    end for;
end cfg_tb_adder_4bit;
