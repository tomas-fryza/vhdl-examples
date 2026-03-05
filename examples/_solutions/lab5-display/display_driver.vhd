library ieee;
use ieee.std_logic_1164.all;

entity display_driver is
    generic (
        N_DIGITS : positive := 2
    );
    port (
        clk  : in  std_logic;
        rst  : in  std_logic;  -- synchronous reset
        data : in  std_logic_vector(N_DIGITS*4-1 downto 0);  -- vector of input bits, 4 per digit
        seg  : out std_logic_vector(6 downto 0);
        dp   : out std_logic;
        an   : out std_logic_vector(7 downto 0)
    );
end entity display_driver;

architecture behavioral of display_driver is


-- TBD






    -- Signals
    signal refresh_ce : std_logic;                            -- one-cycle enable for multiplexing
    signal digit_cnt  : std_logic_vector(2 downto 0);         -- digit selector (3 bits max for 8 digits)
    signal curr_digit : integer range 0 to N_DIGITS-1;        -- current digit index
    signal digit_bin  : std_logic_vector(3 downto 0);         -- current 4-bit value to decode

begin

    ------------------------------------------------------------------------
    -- Clock enable generator for refresh timing
    ------------------------------------------------------------------------
    ce_i : entity work.clock_enable
        generic map (
            MAX => 50_000   -- adjust for flicker-free multiplexing
        )
        port map (
            clk => clk,
            rst => rst,
            ce  => refresh_ce
        );

    ------------------------------------------------------------------------
    -- N-bit counter for digit selection
    ------------------------------------------------------------------------
    digit_counter_i : entity work.bin_counter
        generic map (G_BITS => 3)  -- enough to count 0..7
        port map (
            clk => clk,
            rst => rst,
            en  => refresh_ce,
            cnt => digit_cnt
        );

    ------------------------------------------------------------------------
    -- Select 4-bit digit value from input vector
    ------------------------------------------------------------------------
    digit_bin <= data( (curr_digit+1)*4-1 downto curr_digit*4 );

    ------------------------------------------------------------------------
    -- 7-segment decoder
    ------------------------------------------------------------------------
    bin2seg_i : entity work.bin2seg
        port map (
            bin => digit_bin,
            seg => seg
        );

    ------------------------------------------------------------------------
    -- Decimal point (optional, always off)
    ------------------------------------------------------------------------
    dp <= '0';

    ------------------------------------------------------------------------
    -- Digit anodes (active high)
    ------------------------------------------------------------------------
    an <= (others => '0');                  -- default all off
    an(curr_digit) <= '1';                  -- enable only the active digit

end architecture behavioral;
