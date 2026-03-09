-------------------------------------------------
--! @brief UART Transmitter
--! @version 1.1
--! @copyright (c) 2025 Tomas Fryza, MIT license
--!
--! This module implements a UART (Universal Asynchronous
--! Receiver Transmitter) transmitter using a Finite State
--! Machine (FSM) in 8N1 mode with variable baudrate.
--!
--! See also:
--!   https://nandland.com/uart-serial-port-module/
--!
--! Developed using TerosHDL and Vivado 2020.2.
--! Tested on Nexys A7-50T board and xc7a50ticsg324-1L FPGA.
-------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

-------------------------------------------------

entity uart_tx is
    generic (
        CLK_FREQ : integer := 100_000_000;
        BAUDRATE : integer := 9_600
    );
    port (
        clk      : in    std_logic;                    --! Main clock
        rst      : in    std_logic;                    --! High-active synchronous reset
        tx_data  : in    std_logic_vector(7 downto 0); --! Data to transmit
        tx_start : in    std_logic;                    --! Start transmission
        tx       : out   std_logic;                    --! UART Tx line
        done     : out   std_logic                     --! Transmission completed
    );
end entity uart_tx;

-------------------------------------------------

architecture Behavioral of uart_tx is
    type   state_type is (IDLE, START_BIT, DATA_BITS, STOP_BIT);
    signal state : state_type;

    constant N_PERIODS : integer := (CLK_FREQ / BAUDRATE);

    signal bit_idx : integer range 0 to 7;
    signal periods : integer range 0 to N_PERIODS - 1;
    signal reg     : std_logic_vector(7 downto 0);

begin
    -- UART Transmitter FSM
    p_transmitter : process (clk) is
    begin
        if rising_edge(clk) then
            if (rst = '1') then
                tx    <= '1';
                done  <= '0';
                state <= IDLE;

            else
                case state is

                    when IDLE =>
                        tx   <= '1';
                        done <= '0';

                        if (tx_start = '1') then
                            periods <= 0;
                            state   <= START_BIT;
                        end if;

                    when START_BIT =>
                        tx      <= '0';
                        reg     <= tx_data;
                        bit_idx <= 0;

                        -- Wait for bit period according to baudrate
                        if (periods = N_PERIODS - 1) then
                            state   <= DATA_BITS;
                            periods <= 0;
                        else
                            periods <= periods + 1;
                        end if;

                    when DATA_BITS =>
                        -- Transmit LSB
                        tx <= reg(0);

                        -- Wait for bit period according to baudrate
                        if (periods = N_PERIODS - 1) then
                            -- Shift data register
                            reg     <= '0' & reg(7 downto 1);
                            periods <= 0;

                            -- Send all data bits
                            if (bit_idx = 7) then
                                state <= STOP_BIT;
                            else
                                bit_idx <= bit_idx + 1;
                            end if;
                        else
                            periods <= periods + 1;
                        end if;

                    when STOP_BIT =>
                        tx   <= '1';
                        done <= '1';

                        -- Wait for bit period according to baudrate
                        if (periods = N_PERIODS - 1) then
                            state <= IDLE;
                        else
                            periods <= periods + 1;
                        end if;

                    when others =>
                        state <= IDLE;

                end case;
            end if;
        end if;
    end process p_transmitter;

end Behavioral;
