-------------------------------------------------
--! @brief 2-bit binary comparator.
--! @version 1.2
--! @copyright (c) 2020-2026 Tomas Fryza, MIT license
--!
--! A digital or **binary comparator** compares digital
--! signals A, B and produce outputs depending upon the
--! condition of those inputs. Two-bit binary comparator
--! use `when/else` assignments to distinguish three
--! states: greater than, equal, and less than.
--!
--! Wavedrom example, see <https://wavedrom.com/>:
--! {signal: [
--!  {name: 'b[1:0]', wave: '333333', data: ['0','1','2','1','2','2']},
--!  {name: 'a[1:0]', wave: '333333', data: ['0','1','3','2','1','2']},
--!  {},
--!  {name: 'b_gt', wave: 'l...hl'},
--!  {name: 'b_a_eq', wave: 'h.l..h'},
--!  {name: 'a_gt', wave: 'l.h.l.'},
--! ]}
-------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;

-------------------------------------------------

entity compare_2bit is
    port (
        b      : in    std_logic_vector(1 downto 0); --! Input bus b[1:0]
        a      : in    std_logic_vector(1 downto 0); --! Input bus a[1:0]
        b_gt   : out   std_logic;                    --! Output is `1` if b > a
        b_a_eq : out   std_logic;                    --! Output is `1` if b = a
        a_gt   : out   std_logic                     --! Output is `1` if b < a
    );
end entity compare_2bit;

-------------------------------------------------

architecture behavioral of compare_2bit is
begin
    ---------------------------------------------
    -- Method 1: Behavioral (recommended for design)
    ---------------------------------------------
    -- b_gt <= '1' when (b > a) else
    --         '0';

    b_a_eq <= '1' when (b = a) else
            '0';

    a_gt <= '1' when (b < a) else
            '0';

    ---------------------------------------------
    -- Method 2: Gate-level implementation (for learning only)
    -- This logic is derived from the truth table for
    -- a 2-bit magnitude comparator.
    ---------------------------------------------
    b_gt <= (b(1) and not(a(1))) or
            (b(0) and not(a(1)) and not (a(0))) or
            (b(1) and b(0) and not(a(0)));

end architecture behavioral;

-- K-Map
-- b_gt:           a1 a0
--            00  01  11  10
--           +---+---+---+---+
--        00 |   |   |   |   |
--           +---+---+---+---+
--        01 | 1 |   |   |   |
-- b1 b0     +---+---+---+---+
--        11 | 1 | 1 |   | 1 |
--           +---+---+---+---+
--        10 | 1 | 1 |   |   |
--           +---+---+---+---+
