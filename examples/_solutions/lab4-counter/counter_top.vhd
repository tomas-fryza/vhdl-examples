-------------------------------------------------
--! @brief Top level implementation for binary counter(s)
--! @version 1.2
--! @copyright (c) 2019-2026 Tomas Fryza, MIT license
--!
--! This VHDL file implements a top-level design for a counter
--! display system. It consists of two simple counters: a 4-bit
--! counter counting at 250 ms and a 16-bit counter counting at
--! 2 ms. The counts are displayed on a 7-segment display, and
--! LEDs. Clock enables are used to control the counting frequency.
-------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;

-------------------------------------------------

entity counter_top is
    port (
        clk  : in  std_logic;                     --! Main clock
        btnu : in  std_logic;                     --! Synchronous reset
        led  : out std_logic_vector(9 downto 0);  --! Show 10-bit counter value
        seg  : out std_logic_vector(6 downto 0);  --! Seven-segment cathodes CA..CG (active-low)
        dp   : out std_logic;                     --! Decimal point
        an   : out std_logic_vector(7 downto 0)   --! Seven-segment anodes AN7..AN0 (active-low)
    );
end entity counter_top;

-------------------------------------------------

architecture Behavioral of counter_top is

    -- Component declaration for clock enable
    component clk_en is
        generic ( G_MAX : integer );
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            ce  : out std_logic
        );
    end component clk_en;

    -- Component declaration for binary counter
    component counter is
        generic ( G_BITS : positive );
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            en  : in  std_logic;
            cnt : out std_logic_vector(G_BITS - 1 downto 0)
        );
    end component counter;

    -- Component declaration for bin2seg
    component bin2seg is
        port (
            bin : in  std_logic_vector(3 downto 0);
            seg : out std_logic_vector(6 downto 0)
        );
    end component bin2seg;

    -- Internal signals for the first counter: 4-bit @ 500 ms
    signal sig_en_0 : std_logic;                     --! Clock enable signal for 4-bit counter
    signal sig_cnt  : std_logic_vector(3 downto 0);  --! 4-bit counter value

    -- Internal signal for the second counter: 10-bit @ 20 ms
    signal sig_en_1 : std_logic;  --! Clock enable signal for 10-bit counter

begin

    -- Component instantiation of clock enable for 500 ms
    clock_0 : clk_en
        generic map ( G_MAX => 50_000_000 )
        port map (
            clk => clk,
            rst => btnu,
            ce  => sig_en_0
        );

    -- Component instantiation of 4-bit binary counter
    counter_0 : counter
        generic map ( G_BITS => 4 )
        port map (
            clk => clk,
            rst => btnu,
            en  => sig_en_0,
            cnt => sig_cnt
        );

    -- Component instantiation of bin2seg
    decoder_0 : bin2seg
        port map (
            bin => sig_cnt,
            seg => seg
        );

    -- Turn off decimal point
    dp <= '1';

    -- Set display position
    an <= b"1111_1110";

    -- Component instantiation of clock enable for 20 ms
    clock_1 : clk_en
        generic map ( G_MAX => 2_000_000 )
        port map (
            clk => clk,
            rst => btnu,
            ce  => sig_en_1
        );

    -- Component instantiation of 10-bit binary counter
    counter_1 : counter
        generic map ( G_BITS => 10 )
        port map (
            clk => clk,
            rst => btnu,
            en  => sig_en_1,
            cnt => led
        );

end Behavioral;
