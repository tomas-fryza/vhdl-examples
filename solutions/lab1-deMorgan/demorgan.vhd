-------------------------------------------------
--! @brief Example to demonstrate De Morgan's Laws.
--! @version 1.4
--! @copyright (c) 2019-2026 Tomas Fryza, MIT license
--!
--! This example implements the original logic function
--! and its modified versions using De Morgan's Laws.
--! By comparing the output signals for the expressions,
--! the verification of the laws is confirmed.
-------------------------------------------------

library ieee; -- Standard library
    -- Package for data type and logic operations
    use ieee.std_logic_1164.all;

-------------------------------------------------

entity demorgan is
    port (
        c     : in    std_logic;
        b     : in    std_logic;
        a     : in    std_logic;
        f_org : out   std_logic; --! Original function
        f_and : out   std_logic; --! (N)AND version
        f_or  : out   std_logic  --! (N)OR version
    );
end entity demorgan;

-------------------------------------------------

architecture behavioral of demorgan is
begin

    -- Original logic function
    f_org <= not(c and b) or (not(b) and a);

    -- Use DeMorgans laws and modify the function
    f_and <= not((c and b) and not(not(b) and a));
    f_or  <= (not(c) or not(b)) or not(b or not(a));

end architecture behavioral;
