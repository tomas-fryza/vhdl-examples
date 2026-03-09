-------------------------------------------------
--! @brief Blinking LED example
--! @version 1.0
--! @copyright (c) 2024 Tomas Fryza, MIT license
--!
--! VHDL example for a simple LED controller using a clock
--! signal and a synchronous reset. It implements a process
--! for counting cycles and toggling the LED state based on
--! the internal counter.
--!
--! Developed using TerosHDL, Vivado 2020.2, and EDA Playground.
--! Tested on Nexys A7-50T board and xc7a50ticsg324-1L FPGA.
-------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

-------------------------------------------------

entity blink is
    port (
        clk : in    std_logic; --! Main clock signal
        rst : in    std_logic; --! Asynchronous reset
        led : out   std_logic  --! LED pin
    );
end entity blink;

-------------------------------------------------

architecture Behavioral of blink is
    --! Number of bits for internal counter
    constant NBIT : integer := 24;
    --! Internal counter
    signal sig_internal_cnt : unsigned(NBIT - 1 downto 0);
begin

    --! The process is responsible for counting cycles and
    --! resetting an internal counter (`sig_internal_cnt`)
    --! to zero on a synchronous reset. On each rising
    --! edge of the clock, the counter is incremented.
    p_blink : process (clk) is
    begin

        if (rising_edge(clk)) then
            if (rst = '1') then
                sig_internal_cnt <= (others => '0');
            else
                sig_internal_cnt <= sig_internal_cnt + 1;
            end if;
        end if;

    end process p_blink;

    -- MSB of internal counter connect to LED
    led <= std_logic(sig_internal_cnt(NBIT - 1));

end Behavioral;
