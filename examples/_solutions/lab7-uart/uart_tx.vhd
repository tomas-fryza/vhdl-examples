-----------------------------------------------------------
--! @brief UART Transmitter
--! @version 1.2
--! @copyright (c) 2025-2026 Tomas Fryza, MIT license
--!
--! This module implements a UART (Universal Asynchronous
--! Receiver Transmitter) transmitter using a Finite State
--! Machine (FSM) in 8N1 mode with variable baudrate.
--
-- See also:
--   https://nandland.com/uart-serial-port-module/
-----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------
-- UART Transmitter Entity
entity uart_tx is
    port (
        clk          : in  std_logic;              --! Main clock
        rst          : in  std_logic;              --! High-active synchronous reset
        data         : in  std_logic_vector(7 downto 0);  --! Data to transmit
        tx_start     : in  std_logic;              --! Start transmission signal
        tx           : out std_logic;              --! UART transmit line
        tx_complete  : out std_logic               --! Transmission completion signal
    );
end entity uart_tx;

-------------------------------------------------
-- UART Transmitter Architecture
architecture Behavioral of uart_tx is

    -- FSM State definitions
    type state_type is (IDLE, TRANSMIT_START_BIT, TRANSMIT_DATA, TRANSMIT_STOP_BIT);
    signal current_state : state_type;
    
    -- Constants for baud rate and clock frequency
    constant CLK_FREQ : integer := 100_000_000;  -- System clock frequency (100 MHz)
    constant BAUDRATE : integer := 9_600;        -- Baud rate (9600 Bd)

    -- Number of clock cycles per bit period for baud rate timing
    -- constant N_PERIODS : integer := CLK_FREQ / BAUDRATE;  -- For implementation
    constant N_PERIODS : integer := 2;  -- For simulation

    -- Internal signals
    signal current_bit_index : integer range 0 to 7;            -- Index for current bit being transmitted
    signal shift_reg         : std_logic_vector(7 downto 0);    -- Data shift register
    signal baud_count        : integer range 0 to N_PERIODS-1;  -- Clock cycles for one bit period

begin
    --! UART Transmitter FSM process driven by the main clock (clk)
    p_transmitter : process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                -- Reset state and outputs
                tx                <= '1';   -- UART line idle (high)
                tx_complete       <= '0';   -- Transmission not completed
                current_state     <= IDLE;  -- Start in IDLE state
                current_bit_index <= 0;     -- Reset bit index
                shift_reg         <= (others => '0');  -- Clear shift register
                baud_count        <= 0;     -- Reset the baud rate counter

            else
                case current_state is

                    -- IDLE: Wait for the start signal to begin transmission
                    when IDLE =>
                        tx          <= '1';
                        tx_complete <= '0';

                        if tx_start = '1' then
                            -- When start signal received, prepare to send start bit
                            shift_reg <= data;       -- Load data into shift register
                            current_bit_index <= 0;  -- Start transmitting the least significant bit
                            baud_count <= 0;         -- Reset baud count for the new transmission
                            current_state <= TRANSMIT_START_BIT;  -- Transition to start bit state
                        end if;

                    -- TRANSMIT_START_BIT: Transmit the start bit (low)
                    when TRANSMIT_START_BIT =>
                        tx <= '0';  -- Start bit is always '0'

                        -- Wait for the baud period to complete
                        if baud_count = N_PERIODS - 1 then
                            current_state <= TRANSMIT_DATA;  -- Move to transmit data state
                            baud_count <= 0;                 -- Reset baud counter for the data bits
                        else
                            baud_count <= baud_count + 1;    -- Increment the baud counter
                        end if;

                    -- TRANSMIT_DATA: Transmit the 8 data bits, LSB first
                    when TRANSMIT_DATA =>
                        tx <= shift_reg(0);  -- Transmit the least significant bit (LSB)

                        -- Wait for the baud period to complete
                        if baud_count = N_PERIODS - 1 then
                            shift_reg <= '0' & shift_reg(7 downto 1);  -- Shift the data right by one bit

                            -- Check if all 8 data bits have been transmitted
                            if current_bit_index = 7 then
                                current_state <= TRANSMIT_STOP_BIT;
                            else
                                current_bit_index <= current_bit_index + 1;  -- Move to next bit
                            end if;

                            baud_count <= 0;  -- Reset baud counter for the next bit
                        else
                            baud_count <= baud_count + 1;  -- Increment the baud counter
                        end if;

                    -- TRANSMIT_STOP_BIT: Transmit the stop bit (high)
                    when TRANSMIT_STOP_BIT =>
                        tx          <= '1';  -- Stop bit is always '1'
                        tx_complete <= '1';  -- Indicate transmission is complete

                        -- Wait for the baud period to complete before going back to IDLE
                        if baud_count = N_PERIODS - 1 then
                            current_state <= IDLE;
                        else
                            baud_count <= baud_count + 1;  -- Increment the baud counter
                        end if;

                    -- Default: In case of an unexpected state, return to IDLE
                    when others =>
                        current_state <= IDLE;

                end case;
            end if;
        end if;
    end process p_transmitter;

end Behavioral;
