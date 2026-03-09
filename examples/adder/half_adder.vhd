-------------------------------------------------
--! @brief Half adder
--! @version 1.1
--! @copyright (c) 2019-2024 Tomas Fryza, MIT license
--!
--! This VHDL module implements a half adder, which adds
--! two binary inputs 'a' and 'b' and produces sum and
--! carry outputs.
--!
--! Developed using TerosHDL, Vivado 2023.2, and EDA Playground.
--! Tested on Nexys A7-50T board and xc7a50ticsg324-1L FPGA.
-------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;

-------------------------------------------------

entity half_adder is
    port (
        b     : in    std_logic; --! Input b
        a     : in    std_logic; --! Input a
        carry : out   std_logic; --! Output carry
        sum   : out   std_logic  --! Output sum
    );
end entity half_adder;

-------------------------------------------------

architecture Behavioral of half_adder is
begin

    carry <= b and a;
    sum   <= b xor a;

end Behavioral;
