-------------------------------------------------
--! @brief Top level implementation for binary counter(s)
--! @version 1.1
--! @copyright (c) 2019-2025 Tomas Fryza, MIT license
--!
--! This VHDL file implements a top-level design for a counter
--! display system. It consists of two simple counters: a 4-bit
--! counter counting at 250 ms and a 16-bit counter counting at
--! 2 ms. The counts are displayed on a 7-segment display, and
--! LEDs. Clock enables are used to control the counting frequency.
--!
--! Developed using TerosHDL, Vivado 2023.2, and EDA Playground.
--! Tested on Nexys A7-50T board and xc7a50ticsg324-1L FPGA.
-------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;

-------------------------------------------------

entity top_level is
  port (
    CLK100MHZ : in    std_logic;                     --! Main clock
    LED       : out   std_logic_vector(15 downto 0); --! Show 16-bit counter value
    CA        : out   std_logic;                     --! Cathode of segment A
    CB        : out   std_logic;                     --! Cathode of segment B
    CC        : out   std_logic;                     --! Cathode of segment C
    CD        : out   std_logic;                     --! Cathode of segment D
    CE        : out   std_logic;                     --! Cathode of segment E
    CF        : out   std_logic;                     --! Cathode of segment F
    CG        : out   std_logic;                     --! Cathode of segment G
    DP        : out   std_logic;                     --! Decimal point
    AN        : out   std_logic_vector(7 downto 0);  --! Common anodes of all on-board displays
    BTNC      : in    std_logic                      --! Synchronous reset
  );
end entity top_level;

-------------------------------------------------

architecture behavioral of top_level is

  -- Component declaration for clock enable
  component clock_en is
    generic (
      n_periods : integer
    );
    port (
      clk   : in    std_logic;
      rst   : in    std_logic;
      pulse : out   std_logic
    );
  end component clock_en;

  -- Component declaration for simple counter
  component counter is
    generic (
      n_bits : integer
    );
    port (
      clk   : in    std_logic;
      rst   : in    std_logic;
      en    : in    std_logic;
      count : out   std_logic_vector(NBIT - 1 downto 0)
    );
  end component counter;

  -- Component declaration for bin2seg
  component bin2seg is
    port (
      clear : in    std_logic;
      bin   : in    std_logic_vector(3 downto 0);
      seg   : out   std_logic_vector(6 downto 0)
    );
  end component bin2seg;

  -- Local signals for first counter: 4-bit @ 250 ms
  signal sig_en_250ms   : std_logic;                    --! Clock enable signal for 4-bit counter
  signal sig_count_4bit : std_logic_vector(3 downto 0); --! 4-bit counter value

  -- Local signal for second counter: 16-bit @ 2 ms
  signal sig_en_2ms : std_logic; --! Clock enable signal for 16-bit counter

begin

  -- Component instantiation of clock enable for 250 ms
  clk_en0 : component clock_en
    generic map (
      n_periods => 25_000_000
    )
    port map (
      clk   => CLK100MHZ,
      rst   => BTNC,
      pulse => sig_en_250ms
    );

  -- Component instantiation of 4-bit simple counter
  counter0 : component counter
    generic map (
      n_bits => 4
    )
    port map (
      clk   => CLK100MHZ,
      rst   => BTNC,
      en    => sig_en_250ms,
      count => sig_count_4bit
    );

  -- Component instantiation of bin2seg
  display : component bin2seg
    port map (
      clear  => BTNC,
      bin    => sig_count_4bit,
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

  -- Set display position
  AN <= b"1111_1110";

  -- Component instantiation of clock enable for 2 ms
  clk_en1 : component clock_en
    generic map (
      n_periods => 200_000
    )
    port map (
      clk   => CLK100MHZ,
      rst   => BTNC,
      pulse => sig_en_2ms
    );

  -- Component instantiation of 16-bit simple counter
  counter1 : component counter
    generic map (
      n_bits => 16
    )
    port map (
      clk   => CLK100MHZ,
      rst   => BTNC,
      en    => sig_en_2ms,
      count => LED
    );

end architecture behavioral;
