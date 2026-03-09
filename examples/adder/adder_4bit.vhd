-------------------------------------------------
--! @brief Implementation of 4-bit adder
--! @version 1.1
--! @copyright (c) 2019-2024 Tomas Fryza, MIT license
--!
--! This VHDL module defines the structure of a 4-bit adder.
--! It instantiates four full adders to perform the addition
--! operation. The carry-out signal from each full adder is
--! propagated to the carry-in of the next full adder.
--!
--! Developed using TerosHDL, Vivado 2023.2, and EDA Playground.
--! Tested on Nexys A7-50T board and xc7a50ticsg324-1L FPGA.
-------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;

-------------------------------------------------

entity adder_4bit is
    port (
        c_in   : in    std_logic;                    --! Carry-in signal
        b      : in    std_logic_vector(3 downto 0); --! 4-bit input vector 'b'
        a      : in    std_logic_vector(3 downto 0); --! 4-bit input vector 'a'
        c_out  : out   std_logic;                    --! Carry-out signal
        result : out   std_logic_vector(3 downto 0)  --! 4-bit sum output
    );
end entity adder_4bit;

-------------------------------------------------

architecture Behavioral of adder_4bit is
    -- Component declaration for full adder
    component full_adder is
        port (
            c_in  : in    std_logic;
            b     : in    std_logic;
            a     : in    std_logic;
            c_out : out   std_logic;
            sum   : out   std_logic
        );
    end component;

    -- Local signals for carry propagation
    signal sig_c0 : std_logic;
    signal sig_c1 : std_logic;
    signal sig_c2 : std_logic;
begin

    -- Component instantiations for each bit position
    -- 1st full adder
    FA0 : full_adder
        port map (
            c_in  => c_in,
            b     => b(0),
            a     => a(0),
            c_out => sig_c0,
            sum   => result(0)
        );

    -- 2nd full adder
    FA1 : full_adder
        port map (
            c_in  => sig_c0,
            b     => b(1),
            a     => a(1),
            c_out => sig_c1,
            sum   => result(1)
        );

    -- 3rd full adder
    FA2 : full_adder
        port map (
            c_in  => sig_c1,
            b     => b(2),
            a     => a(2),
            c_out => sig_c2,
            sum   => result(2)
        );

    -- 4th full adder
    FA3 : full_adder
        port map (
            c_in  => sig_c2,
            b     => b(3),
            a     => a(3),
            c_out => c_out,
            sum   => result(3)
        );

end Behavioral;

-------------------------------------------------
-- See file full_adder.vhd
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
