-------------------------------------------------
--! @brief Clock enable generator (single-cycle pulse)
--! @version 1.4
--! @copyright (c) 2019-2026 Tomas Fryza, MIT license
--!
--! This design generates a single-clock-cycle enable
--! pulse every G_MAX clock cycles.
--
-- Notes:
-- - Synchronous design (rising edge of clk)
-- - High-active synchronous reset
-- - Output pulse width = one clock period
-- - G_MAX must be greater than 0
-------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;

-------------------------------------------------

entity clk_en is
    generic (
        G_MAX : positive := 3  --! Number of clock cycles between pulses
    );
    port (
        clk : in  std_logic;  --! Main clock
        rst : in  std_logic;  --! High-active synchronous reset
        ce  : out std_logic   --! One-clock-cycle enable pulse
    );
end entity clk_en;

-------------------------------------------------

architecture behavioral of clk_en is

    --! Local counter
    signal sig_cnt : integer range 0 to G_MAX - 1;

begin

    --! Count the number of clock pulses from zero to G_MAX-1.
    p_clk_enable : process (clk) is
    begin
        if rising_edge(clk) then          -- Synchronous process
            if rst = '1' then             -- High-active reset
                sig_cnt <= 0;
                ce      <= '0';

            elsif sig_cnt = G_MAX-1 then  -- Generate single pulse
                sig_cnt <= 0;
                ce      <= '1';

            else                          -- Counting
                sig_cnt <= sig_cnt + 1;
                ce      <= '0';
            end if;                       -- Each `if` must end by `end if`
        end if;
    end process p_clk_enable;

end architecture behavioral;
