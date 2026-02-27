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
        clk  : in  std_logic;                      --! Main clock
        led  : out std_logic_vector(15 downto 0);  --! Show 16-bit counter value
        seg  : out std_logic_vector(6 downto 0);   --! Seven-segment cathodes CA..CG (active-low)
        dp   : out std_logic;                      --! Decimal point
        an   : out std_logic_vector(7 downto 0);   --! Seven-segment anodes AN7..AN0 (active-low)
        btnu : in  std_logic                       --! Synchronous reset
    );
end entity counter_top;

-------------------------------------------------

architecture behavioral of counter_top is

    -- Component declaration for clock enable
    component clk_en is
        generic (
            G_MAX : integer
        );
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            ce  : out std_logic
        );
    end component clk_en;

    -- Component declaration for binary counter
    component counter is
        generic (
            G_BITS : positive
        );
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

    -- Local signals for first counter: 4-bit @ 250 ms
    signal sig_en_250ms : std_logic;                     --! Clock enable signal for 4-bit counter
    signal sig_cnt_4bit : std_logic_vector(3 downto 0);  --! 4-bit counter value

    -- Local signal for second counter: 16-bit @ 2 ms
    signal sig_en_2ms : std_logic;  --! Clock enable signal for 16-bit counter

begin

    -- Component instantiation of clock enable for 250 ms
    clk_en0 : component clk_en
        generic map (
            G_MAX => 25_000_000
        )
        port map (
            clk => clk,
            rst => btnu,
            ce  => sig_en_250ms
        );

    -- Component instantiation of 4-bit simple counter
    counter0 : component counter
        generic map (
            G_BITS => 4
        )
        port map (
            clk => clk,
            rst => btnu,
            en  => sig_en_250ms,
            cnt => sig_cnt_4bit
        );

    -- Component instantiation of bin2seg
    display : component bin2seg
        port map (
            bin => sig_cnt_4bit,
            seg => seg
        );

    -- Turn off decimal point
    dp <= '1';

    -- Set display position
    an <= b"1111_1110";

    -- Component instantiation of clock enable for 2 ms
    clk_en1 : component clk_en
        generic map (
            G_MAX => 200_000
        )
        port map (
            clk => clk,
            rst => btnu,
            ce  => sig_en_2ms
        );

    -- Component instantiation of 16-bit simple counter
    counter1 : component counter
        generic map (
            G_BITS => 16
        )
        port map (
            clk => clk,
            rst => btnu,
            en  => sig_en_2ms,
            cnt => led
        );

end architecture behavioral;
