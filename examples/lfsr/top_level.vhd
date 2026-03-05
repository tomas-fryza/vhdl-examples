-------------------------------------------------
--! @brief Top level implementation for binary counter(s)
--! @version 1.0
--! @copyright (c) 2019-2025 Tomas Fryza, MIT license
--!
--! This VHDL file implements a top-level design for LFSR counter(s).
--! It consists of 8-bit counter and 100ms clock enable components.
--! The output values are displayed on LEDs.
--!
--! Developed using TerosHDL, Vivado 2023.2, and EDA Playground.
--! Tested on Nexys A7-50T board and xc7a50ticsg324-1L FPGA.
-------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;

-------------------------------------------------

entity top_level is
  port (
    CLK100MHZ : in    std_logic;                    --! Main clock
    BTNC      : in    std_logic;                    --! Synchronous reset
    BTND      : in    std_logic;                    --! Load default/seed value
    SW        : in    std_logic_vector(7 downto 0); --! Default/seed value
    LED       : out   std_logic_vector(7 downto 0); --! Show counter value
    LED16_B   : out   std_logic                     --! Sequence completed
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

  -- Component declaration for lfsr counter
  component lfsr is
    generic (
      n_bits : integer
    );
    port (
      clk      : in    std_logic;
      rst      : in    std_logic;
      en       : in    std_logic;
      load     : in    std_logic;
      lfsr_in  : in    std_logic_vector(n_bits - 1 downto 0);
      done     : out   std_logic;
      lfsr_out : out   std_logic_vector(n_bits - 1 downto 0)
    );
  end component lfsr;

  -- Local signal(s)
  signal sig_en_100ms : std_logic; --! Clock enable signal

begin

  -- Component instantiation of clock enable for 100 ms
  CLOCKEN_100MSEC : component clock_en
    generic map (
      n_periods => 10_000_000
    )
    port map (
      clk   => CLK100MHZ,
      rst   => BTNC,
      pulse => sig_en_100ms
    );

  -- Component instantiation of 8-bit LFSR
  LFSR_8BIT : component lfsr
    generic map (
      n_bits => 8
    )
    port map (
      clk      => CLK100MHZ,
      rst      => BTNC,
      en       => sig_en_100ms,
      load     => BTND,
      lfsr_in  => SW,
      done     => LED16_R,
      lfsr_out => LED
    );

end architecture behavioral;
