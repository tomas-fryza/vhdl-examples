-------------------------------------------------
--! @brief Top level of 7-segment display decoder
--! @version 1.4
--! @copyright (c) 2020-2026 Tomas Fryza, MIT license
--!
--! Implementation of two 7-segment displays on
--! Nexys A7-50 FPGA board. Display position is
--! selected by BTND button, and the input data is
--! displayed on LEDs.
-------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;

-------------------------------------------------

entity segment_top is
    port (
        sw_r  : in    std_logic_vector(3 downto 0); --! Data for right display
        sw_l  : in    std_logic_vector(3 downto 0); --! Data for left display
        led_r : out   std_logic_vector(3 downto 0); --! Show right data
        led_l : out   std_logic_vector(3 downto 0); --! Show left data
        seg   : out   std_logic_vector(6 downto 0); --! Seven-segment cathodes CA..CG (active-low)
        dp    : out   std_logic;                    --! Decimal point
        an    : out   std_logic_vector(7 downto 0); --! Seven-segment anodes AN7..AN0 (active-low)
        btnd  : in    std_logic                     --! Switch between displays
    );
end entity segment_top;

-------------------------------------------------

architecture behavioral of segment_top is

    -- Declare component `bin2seg`
    component bin2seg is
        port (
            bin   : in    std_logic_vector(3 downto 0);
            seg   : out   std_logic_vector(6 downto 0)
        );
    end component;

    --! Internal signal for selected 4-bit input
    signal sig_tmp : std_logic_vector(3 downto 0);
begin

    --! Instantiate decoder
    display : component bin2seg
        port map (
            bin => sig_tmp,
            seg => seg
        );

    -- Turn off decimal point (inactive = '1')
    dp <= '1';

    -- Display input value(s) on LEDs
    led_r <= sw_r;
    led_l <= sw_l;

    -- Select left or right 4-bit input
    sig_tmp <= sw_l when (btnd = '1') else
               sw_r;

    -- Disable unused digits (active-low logic)
    an(7 downto 2) <= b"11_1111";

    -- Enable only one digit at a time
    an(1) <= not(btnd);
    an(0) <= btnd;

end architecture behavioral;
