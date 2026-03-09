-----------------------------------------------------------
--! @brief Display driver top-level
--! @version 1.2
--! @copyright (c) 2020-2026 Tomas Fryza, MIT license
--!
--! Drives a 2-digit 7-segment display using multiplexing.
--! Input data is split into high and low nibbles for each digit.
--
-- Notes:
-- - Supports 2-digit display
-- - Uses clock enable and counter for digit multiplexing
-- - Anode logic is active-low for common-anode displays
-----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity display_driver is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        data  : in  std_logic_vector(7 downto 0);  -- Vector of input bits, 4 per digit
        seg   : out std_logic_vector(6 downto 0);
        anode : out std_logic_vector(1 downto 0)
    );
end entity display_driver;

architecture Behavioral of display_driver is

        -- Component declaration for clock enable
        component clk_en is
            generic ( G_MAX : positive );
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
    
    -- Internal signals
    signal sig_en    : std_logic;
    signal sig_digit : std_logic_vector(0 downto 0);  -- Can be scalable
    signal sig_bin   : std_logic_vector(3 downto 0);

begin

    ------------------------------------------------------------------------
    -- Clock enable generator for refresh timing
    ------------------------------------------------------------------------
    clock_0 : clk_en
        generic map ( G_MAX => 16 ) -- Adjust for flicker-free multiplexing
        port map (                  -- For simulation: 16
            clk => clk,             -- For implementation: 1_600_000
            rst => rst,
            ce  => sig_en
        );

    ------------------------------------------------------------------------
    -- N-bit counter for digit selection
    ------------------------------------------------------------------------
    counter_0 : counter
       generic map ( G_BITS => 1 )
       port map (
           clk => clk,
           rst => rst,
           en  => sig_en,
           cnt => sig_digit
       );

    ------------------------------------------------------------------------
    -- Digit select
    ------------------------------------------------------------------------
    sig_bin <= data(3 downto 0) when sig_digit = "0" else
               data(7 downto 4);

    ------------------------------------------------------------------------
    -- 7-segment decoder
    ------------------------------------------------------------------------
    decoder_0 : bin2seg
        port map (
            bin => sig_bin,
            seg => seg
        );

    ------------------------------------------------------------------------
    -- Anode select process
    ------------------------------------------------------------------------
    p_anode_select : process (sig_digit) is
    begin
        case sig_digit is
            when "0" =>
                anode <= "10";  -- Right digit active
            when "1" =>
                anode <= "01";  -- Left digit active
            when others =>
                anode <= "11";  -- All off
        end case;
    end process;

end Behavioral;
