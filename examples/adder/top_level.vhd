-------------------------------------------------
--! @brief Top level implementation for 4-bit adder
--! @version 1.1
--! @copyright (c) 2019-2024 Tomas Fryza, MIT license
--!
--! This VHDL module integrates a 4-bit adder and a binary-to-
--! 7-segment decoder to perform addition on two 4-bit binary
--! numbers represented by on-bboard switches 'SW_B' and 'SW_A'.
--! The result is shown on the 7-segment display, and the carry
--! output is indicated by 'LED_RED'. The input values are
--! displayed on LEDs.
--!
--! Developed using TerosHDL, Vivado 2023.2, and EDA Playground.
--! Tested on Nexys A7-50T board and xc7a50ticsg324-1L FPGA.
-------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;

-------------------------------------------------

entity top_level is
    port (
        SW_B    : in    std_logic_vector(3 downto 0); --! First operand b[3:0]
        SW_A    : in    std_logic_vector(3 downto 0); --! Second operand b[3:0]
        LED_B   : out   std_logic_vector(3 downto 0); --! Show binary value b[3:0]
        LED_A   : out   std_logic_vector(3 downto 0); --! Show binary value a[3:0]
        LED_RED : out   std_logic;                    --! Show output carry
        CA      : out   std_logic;                    --! Cathode of segment A
        CB      : out   std_logic;                    --! Cathode of segment B
        CC      : out   std_logic;                    --! Cathode of segment C
        CD      : out   std_logic;                    --! Cathode of segment D
        CE      : out   std_logic;                    --! Cathode of segment E
        CF      : out   std_logic;                    --! Cathode of segment F
        CG      : out   std_logic;                    --! Cathode of segment G
        DP      : out   std_logic;                    --! Decimal point
        AN      : out   std_logic_vector(7 downto 0); --! Common anodes of all on-board displays
        BTNC    : in    std_logic                     --! Clear the display
    );
end entity top_level;

-------------------------------------------------

architecture Behavioral of top_level is
    -- Component declaration for 4-bit added
    component adder_4bit is
        port (
            c_in   : in    std_logic;
            b      : in    std_logic_vector(3 downto 0);
            a      : in    std_logic_vector(3 downto 0);
            c_out  : out   std_logic;
            result : out   std_logic_vector(3 downto 0)
        );
    end component;

    -- Component declaration for bin2seg
    component bin2seg is
        port (
            clear : in    std_logic;
            bin   : in    std_logic_vector(3 downto 0);
            seg   : out   std_logic_vector(6 downto 0)
        );
    end component;

    --! Local signal for adder result
    signal sig_tmp : std_logic_vector(3 downto 0);
begin

    -- Component instantiation of 4-bit adder
    adder : adder_4bit
        port map (
            c_in   => '0',
            b      => SW_B,
            a      => SW_A,
            c_out  => LED_RED,
            result => sig_tmp
        );

    -- Component instantiation of bin2seg
    display : bin2seg
        port map (
            clear  => BTNC,
            bin    => sig_tmp,
            seg(6) => CA,
            seg(5) => CB,
            seg(4) => CC,
            seg(3) => CD,
            seg(2) => CE,
            seg(1) => CF,
            seg(0) => CG
        );

    -- Turn off decimal point
    DP <= '1';

    -- Display input values on LEDs
    LED_B <= SW_B;
    LED_A <= SW_A;

    -- Set display position
    AN <= b"1111_1110";

end Behavioral;
