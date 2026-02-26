-------------------------------------------------
--! @brief Binary to 7-segment decoder (common anode, 1 digit)
--! @version 1.4
--! @copyright (c) 2018-2026 Tomas Fryza, MIT license
--!
--! This design decodes a 4-bit binary input into control
--! signals for a 7-segment common-anode display. It
--! supports hexadecimal characters:
--!
--!   0, 1, 2, 3, 4, 5, 6, 7, 8, 9, A, b, C, d, E, F
--
-- Notes:
-- - Common anode: segment ON = 0, OFF = 1
-- - No decimal point is implemented
-- - Purely combinational (no clock)
-------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;

-------------------------------------------------

entity bin2seg is
    port (
        bin : in  std_logic_vector(3 downto 0);  --! 4-bit hexadecimal input
        seg : out std_logic_vector(6 downto 0)   --! {a,b,c,d,e,f,g} active-low outputs
    );
end entity bin2seg;

-------------------------------------------------

architecture behavioral of bin2seg is
begin

    --! This combinational process decodes binary input
    --! `bin` into 7-segment display output `seg` for a
    --! Common Anode configuration (active-low outputs).
    --! The process is triggered whenever `bin` changes.

    p_7seg_decoder : process (bin) is
    begin
        case bin is
            when x"0" =>
                seg <= "0000001";
            when x"1" =>
                seg <= "1001111";

            -- TODO: Complete settings for 2, 3, 4, 5, 6

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

            -- TODO: Complete settings for 9, A, b, C, d

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

            -- Default case (e.g., for undefined values)
            when others =>
                seg <= "0111000";
        end case;
    end process p_7seg_decoder;

end architecture behavioral;
