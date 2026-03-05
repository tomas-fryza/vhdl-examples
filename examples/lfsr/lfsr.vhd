-------------------------------------------------
--! @brief LFSR (Linear Feedback Shift Register)
--! @version 1.1
--! @copyright (c) 2024-2025 Tomas Fryza, MIT license
--!
--! Implements an N-bit LFSR counter with clock enable and loading
--! functionality. The width of the counter is controlled by the
--! generic parameter N_BITS.
--!
--! Developed using TerosHDL, Vivado 2023.2, and EDA Playground.
--! Tested on Nexys A7-50T board and xc7a50ticsg324-1L FPGA.
--!
--! Inspired by:
--!   * https://nandland.com/lfsr-linear-feedback-shift-register/
--!   * https://docs.xilinx.com/v/u/en-US/xapp052
-------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;

-------------------------------------------------

entity lfsr is
  generic (
    n_bits : integer := 4 --! Default number of bits
  );
  port (
    clk      : in    std_logic;                             --! Main clock
    rst      : in    std_logic;                             --! High-active synchronous reset
    en       : in    std_logic;                             --! Clock enable input
    load     : in    std_logic;                             --! Control signal to load default/seed value
    lfsr_in  : in    std_logic_vector(n_bits - 1 downto 0); --! Default/seed value
    done     : out   std_logic;                             --! Sequence completed
    lfsr_out : out   std_logic_vector(n_bits - 1 downto 0)  --! Counter value
  );
end entity lfsr;

-------------------------------------------------

architecture behavioral of lfsr is

  --! Internal register
  signal sig_reg : std_logic_vector(n_bits - 1 downto 0);

  --! Internal feedback with xnor gate(s)
  signal sig_fb : std_logic;

begin

  --! The synchronous process controls the loading of starting
  --! data and the shifting of the internal register based on
  --! the clock (clk) and the enable (en) signals.
  p_lfsr : process (clk) is
  begin

    if (rising_edge(clk)) then
      if (rst = '1') then
        sig_reg <= (others => '0');

      -- Load `starting` data
      elsif (load = '1') then
        sig_reg <= lfsr_in;

      -- Clock enable activated
      elsif (en = '1') then
        -- Shift internal register
        sig_reg(n_bits - 1 downto 1) <= sig_reg(n_bits - 2 downto 0);
        sig_reg(0)                   <= sig_fb;
      end if;
    end if;

  end process p_lfsr;

  g_4bit : if n_bits = 4 generate
    -- Create feedback for 4-bit LFSR counter
    -- https://docs.xilinx.com/v/u/en-US/xapp052
    sig_fb <= sig_reg(3) xnor sig_reg(2);
  end generate g_4bit;

  g_5bit : if n_bits = 5 generate
    -- Create feedback for 5-bit LFSR counter
    sig_fb <= sig_reg(4) xnor sig_reg(2);
  end generate g_5bit;

  g_8bit : if n_bits = 8 generate
    -- Create feedback for 5-bit LFSR counter
    sig_fb <= sig_reg(7) xnor sig_reg(5) xnor sig_reg(4) xnor sig_reg(3);
  end generate g_8bit;

  -- Assign internal register to output
  lfsr_out <= sig_reg;

  -- Create a `done` output pulse
  done <= '1' when (sig_reg = lfsr_in) else
          '0';

end architecture behavioral;
