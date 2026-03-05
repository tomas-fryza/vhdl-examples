-------------------------------------------------
--! @brief Binary to 7-segment decoder (common anode, 1 digit)
--! @version 1.5
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
                seg <= b"000_0001";
            when x"1" =>
                seg <= b"100_1111";
            when x"2" =>
                seg <= b"001_0010";
            when x"3" =>
                seg <= b"000_0110";
            when x"4" =>
                seg <= b"100_1100";
            when x"5" =>
                seg <= b"010_0100";
            when x"6" =>
                seg <= b"010_0000";
            when x"7" =>
                seg <= b"000_1111";
            when x"8" =>
                seg <= b"000_0000";
            when x"9" =>
                seg <= b"000_0100";
            when x"A" =>
                seg <= b"000_1000";
            when x"b" =>
                seg <= b"110_0000";
            when x"C" =>
                seg <= b"011_0001";
            when x"d" =>
                seg <= b"100_0010";
            when x"E" =>
                seg <= b"011_0000";
            when x"F" =>
                seg <= b"011_1000";

            -- Default case (e.g., for undefined values)
            when others =>
                seg <= b"111_1111";  -- All segments off
        end case;
    end process p_7seg_decoder;

end architecture behavioral;
