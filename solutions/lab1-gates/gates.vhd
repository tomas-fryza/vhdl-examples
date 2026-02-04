-------------------------------------------------
--! @brief Basic logic gates (AND, OR, XOR)
--! @version 1.2
--! @copyright (c) 2019-2026 Tomas Fryza, MIT license
--!
--! This entity implements three basic combinational
--! logic functions for two single-bit input signals
--! A and B.
--
-- Outputs:
--   y_and = A AND B
--   y_or  = A OR  B
--   y_xor = A XOR B
-------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;

-------------------------------------------------

entity gates is
    port (
        a     : in    std_logic; --! First input
        b     : in    std_logic; --! Second input
        y_and : out   std_logic; --! Logic AND
        y_or  : out   std_logic; --! Logic OR
        y_xor : out   std_logic  --! Logic XOR
    );
end entity gates;

-------------------------------------------------

architecture behavioral of gates is
begin

    y_and <= a and b;
    y_or <= a or b;
    y_xor <= a xor b;

end architecture behavioral;
