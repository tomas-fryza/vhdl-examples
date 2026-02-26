-------------------------------------------------
--! @brief One-digit 7-segment display decoder
--! @version 1.3
--! @copyright (c) 2018-2025 Tomas Fryza, MIT license
--!
--! This VHDL file represents a binary-to-seven-segment decoder
--! for a one-digit display with Common Anode configuration
--! (active-low). The decoder defines 16 hexadecimal symbols:
--! `0, 1, ..., 9, A, b, C, d, E, F`. All segments are turned
--! off when `clear` signal is high. Note that Decimal Point
--! functionality is not implemented.
--!
--! Developed using TerosHDL, Vivado 2020.2, and EDA Playground.
--! Tested on Nexys A7-50T board and xc7a50ticsg324-1L FPGA.
-------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;

-------------------------------------------------

entity bin2seg is
    port (
        clear : in    std_logic;                    --! Clear the display
        bin   : in    std_logic_vector(3 downto 0); --! Binary representation of one hexadecimal symbol
        seg   : out   std_logic_vector(6 downto 0)  --! Seven active-low segments from A to G
    );
end entity bin2seg;

-------------------------------------------------

architecture behavioral of bin2seg is
begin

    --! This combinational process decodes binary input
    --! `bin` into 7-segment display output `seg` for a
    --! Common Anode configuration. When either `bin` or
    --! `clear` changes, the process is triggered. Each
    --! bit in `seg` represents a segment from A to G.
    --! The display is cleared if `clear` is set to 1.
    p_7seg_decoder : process (bin, clear) is
    begin

        if (clear = '1') then
            seg <= "1111111";  -- Clear the display
        else

            case bin is

                when x"0" =>
                    seg <= "0000001";

                when x"1" =>
                    seg <= "1001111";

                -- WRITE YOUR CODE HERE
                -- 2, 3, 4, 5, 6

                when x"2" =>
                    seg <= "0010010";

                when x"3" =>
                    seg <= "0000110";

                when x"4" =>
                    seg <= "1001100";

                when x"5" =>
                    seg <= "0100100";

                when x"6" =>
                    seg <= "0100000";

                when x"7" =>
                    seg <= "0001111";

                when x"8" =>
                    seg <= "0000000";

                -- WRITE YOUR CODE HERE
                -- 9, A, b, C, d

                when x"9" =>
                    seg <= "0000100";

                when x"A" =>
                    seg <= "0001000";

                when x"b" =>
                    seg <= "1100000";

                when x"C" =>
                    seg <= "0110001";

                when x"d" =>
                    seg <= "1000010";

                when x"E" =>
                    seg <= "0110000";

                when others =>
                    seg <= "0111000";

            end case;

        end if;

    end process p_7seg_decoder;

end architecture behavioral;
