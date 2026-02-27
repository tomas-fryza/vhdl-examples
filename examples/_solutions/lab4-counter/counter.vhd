-------------------------------------------------
--! @brief N-bit synchronous up counter with enable
--! @version 1.4
--! @copyright (c) 2019-2026 Tomas Fryza, MIT license
--!
--! This design implements a parameterizable N-bit
--! binary up counter with synchronous, high-active
--! reset and clock enable input. The counter wraps
--! around to zero after reaching its maximum value
--! (2^G_BITS − 1).
--
-- Notes:
-- - Synchronous design (rising edge of clk)
-- - High-active synchronous reset
-- - Enable input controls counting
-- - Modulo 2^N operation (automatic wrap-around)
-- - Integer-based internal counter
-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  -- Package for data types conversion

-------------------------------------------------

entity counter is
    generic (
        G_BITS : positive := 3  --! Default number of bits
    );
    port (
        clk : in  std_logic;                             --! Main clock
        rst : in  std_logic;                             --! High-active synchronous reset
        en  : in  std_logic;                             --! Clock enable input
        cnt : out std_logic_vector(G_BITS - 1 downto 0)  --! Counter value
    );
end entity counter;

-------------------------------------------------

architecture behavioral of counter is

    -- Maximum counter value = 2^G_BITS - 1
    constant C_MAX : integer := 2**G_BITS - 1;

    -- Integer counter with defined range
    signal sig_cnt : integer range 0 to C_MAX;

begin

    --! Clocked process with synchronous reset which implements
    --! N-bit up counter.

    p_counter : process (clk) is
    begin
        if rising_edge(clk) then
            if rst = '1' then    -- Synchronous, active-high reset
                sig_cnt <= 0;

            elsif en = '1' then  -- Clock enable activated
                if sig_cnt = C_MAX then
                    sig_cnt <= 0;
                else
                    sig_cnt <= sig_cnt + 1;
                end if;          -- Each `if` must end by `end if`
            end if;
        end if;
    end process p_counter;

    -- Convert integer to std_logic_vector
    cnt <= std_logic_vector(to_unsigned(sig_cnt, G_BITS));

end architecture behavioral;
