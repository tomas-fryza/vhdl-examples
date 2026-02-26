-------------------------------------------------
--! @brief Top level implementation for 4-bit ALU
--! @version 1.0
--! @copyright (c) 2025 Tomas Fryza, MIT license
--!
--! This VHDL module integrates a 4-bit ALU. The results are
--! shown on the 7-segment display, and the flag outputs are
--! indicated by RGB LEDs.
--!
--! Developed using TerosHDL, Vivado 2023.2.
--! Tested on Nexys A7-50T board and xc7a50ticsg324-1L FPGA.
-------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;

-------------------------------------------------

entity top_level is
    port (
        SW_A       : in    std_logic_vector(3 downto 0); --! First operand A
        SW_B       : in    std_logic_vector(3 downto 0); --! Second operand B
        SW_OPER    : in    std_logic_vector(2 downto 0); --! ALU operation selector
        LED_RESULT : out   std_logic_vector(3 downto 0); --! Show result
        LED_RED    : out   std_logic;                    --! Show output carry flag
        LED_BLUE   : out   std_logic;                    --! Show zero flag
        CA         : out   std_logic;                    --! Cathode of segment A
        CB         : out   std_logic;                    --! Cathode of segment B
        CC         : out   std_logic;                    --! Cathode of segment C
        CD         : out   std_logic;                    --! Cathode of segment D
        CE         : out   std_logic;                    --! Cathode of segment E
        CF         : out   std_logic;                    --! Cathode of segment F
        CG         : out   std_logic;                    --! Cathode of segment G
        DP         : out   std_logic;                    --! Decimal point
        AN         : out   std_logic_vector(7 downto 0)  --! Common anodes of all on-board displays
    );
end entity top_level;

-------------------------------------------------

architecture behavioral of top_level is
    -- Component declaration for 4-bit alu
    component alu_4bit is
        port (
            a      : in    std_logic_vector(3 downto 0);
            b      : in    std_logic_vector(3 downto 0);
            oper   : in    std_logic_vector(2 downto 0);
            result : out   std_logic_vector(3 downto 0);
            carry  : out   std_logic;
            zero   : out   std_logic
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

    --! Local signal for alu result
    signal sig_tmp : std_logic_vector(3 downto 0);
begin

    -- Component instantiation of 4-bit alu
    adder : component alu_4bit
        port map (
            a      => SW_A,
            b      => SW_B,
            oper   => SW_OPER,
            result => sig_tmp,
            carry  => LED_RED,
            zero   => LED_BLUE
        );

    -- Component instantiation of bin2seg
    display : component bin2seg
        port map (
            clear  => '0',
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

    -- Display output value on LEDs
    LED_RESULT <= sig_tmp;

    -- Set display position
    AN <= b"1111_1110";

end architecture behavioral;
