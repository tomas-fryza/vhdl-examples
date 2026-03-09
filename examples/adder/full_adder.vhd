-------------------------------------------------
--! @brief Full adder
--! @version 1.0
--! @copyright (c) 2024 Tomas Fryza, MIT license
--!
--! This VHDL module implements a full adder, which adds
--! three binary inputs 'a', 'b', and 'c_in', and produces
--! a sum output 'sum' and a carry output 'c_out'.
--! The outputs are computed by simple VHDL assignment
--! statements.
--!
--! Developed using TerosHDL, Vivado 2023.2, and EDA Playground.
--! Tested on Nexys A7-50T board and xc7a50ticsg324-1L FPGA.
-------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;

-------------------------------------------------

entity full_adder is
    port (
        c_in  : in    std_logic; --! Input carry
        b     : in    std_logic; --! Input b
        a     : in    std_logic; --! Input a
        c_out : out   std_logic; --! Output carry
        sum   : out   std_logic  --! Output sum
    );
end entity full_adder;

-------------------------------------------------

architecture Behavioral of full_adder is
    -- Internal signals between gates
    signal sig_tmp_0 : std_logic;
    signal sig_tmp_1 : std_logic;
begin

    -- Output sum
    sig_tmp_0 <= b xor a;
    sum       <= c_in xor sig_tmp_0;

    -- Output carry
    sig_tmp_1 <= c_in and sig_tmp_0;
    c_out     <= sig_tmp_1 or (b and a);

end Behavioral;
