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
        G_MAX : positive := 5  --! Number of clock cycles between pulses
    );
    port (
        clk : in  std_logic;  --! Main clock
        rst : in  std_logic;  --! High-active synchronous reset
        ce  : out std_logic   --! One-clock-cycle enable pulse
    );
end entity clk_en;

-------------------------------------------------

architecture behavioral of clk_en is

    --! Internal counter
    signal sig_cnt : integer range 0 to G_MAX - 1;

begin

    --! Count clock pulses and generate a one-clock-cycle enable pulse
    p_clk_enable : process (clk) is
    begin
        if rising_edge(clk) then  -- Synchronous process
            if rst = '1' then     -- High-active reset
                ce      <= '0';   -- Reset output
                sig_cnt <= 0;     -- Reset internal counter

            elsif sig_cnt = G_MAX-1 then
                ce      <= '1';   -- Set output pulse
                sig_cnt <= 0;     -- Reset internal counter

            else
                ce      <= '0';   -- Clear output
                sig_cnt <= sig_cnt + 1;  --Increment internal counter

            end if;  -- End if for reset/check
        end if;      -- End if for rising_edge
    end process p_clk_enable;

end architecture behavioral;
