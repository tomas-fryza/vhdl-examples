
-- An I2C Controller in VHDL
-- https://github.com/aslak3/i2c-controller

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity i2c_controller is
    port (
        clock      : in  STD_LOGIC;                      -- Master clock
        reset      : in  STD_LOGIC;                      -- Master reset
        trigger    : in  STD_LOGIC;                      -- Continue on after pause
        restart    : in  STD_LOGIC;                      -- Generates a new START
        last_byte  : in  STD_LOGIC;                      -- This is the last byte to read/write
        address    : in  STD_LOGIC_VECTOR (6 downto 0);  -- Slave address
        read_write : in  STD_LOGIC;                      -- 0=write, 1=read
        write_data : in  STD_LOGIC_VECTOR (7 downto 0);  -- Data to write
        read_data  : out STD_LOGIC_VECTOR (7 downto 0);  -- Data we have read
        ack_error  : out STD_LOGIC;                      -- 0=ACK, 1=NAK
        busy       : out STD_LOGIC;                      -- Controller is processing
        scl        : inout STD_LOGIC;                    -- Tri-state
        sda        : inout STD_LOGIC);                   -- Ditto
end entity;

architecture behavioral of i2c_controller is
    type T_STATE is (START1, START2,
        WRITING_DATA, WRITING_ACK, WRITE_WAITING,
        READING_DATA, READING_ACK, READ_WAITING,
        STOP1, STOP2, STOP3,
        RESTART1
    );
    signal running : STD_LOGIC := '0';                -- Not idle; trigger recieved
    signal pause_running : STD_LOGIC := '0';        -- Used to wait for next trigger
    signal running_clock : STD_LOGIC;                -- Generator of 100KHz ish SCL
    signal previous_running_clock : STD_LOGIC;        -- Used to find the edge
    signal state : T_STATE := START1;                -- Current state
    signal scl_local : STD_LOGIC := '1';            -- Local copies of output
    signal sda_local : STD_LOGIC := '1';            -- Ditto

begin
    process (reset, clock)
    variable i2c_clock_counter : UNSIGNED (6 downto 0);    -- Slows down the SCL from main clock
    begin
        if (reset = '1') then
            i2c_clock_counter := (others => '0');
            running <= '0';
        elsif (clock'Event and clock = '1') then
            if (trigger = '1') then
                -- On a trigger, enter running state and clear the counter
                running <= '1';
                i2c_clock_counter := (others => '0');
            end if;
            if (running = '1') then
                -- If we are running, inc the counter and extract the MSB for 2nd process
                i2c_clock_counter := i2c_clock_counter + 1;
                previous_running_clock <= running_clock;
                running_clock <= i2c_clock_counter (6);
            end if;
            if (pause_running = '1') then
                -- Handle the 2nd process wanting to wait for a trigger (eg. the next byte to write)
                running <= '0';
            end if;
        end if;
    end process;

    process (reset, clock)
    variable clock_flip : STD_LOGIC := '0';                    -- Used to toggle the scl_local
    variable bit_counter : INTEGER range 0 to 8 := 0;        -- Used in read/write to count bits
    variable data_to_write : STD_LOGIC_VECTOR (7 downto 0);    -- May be a slave address or actual data
    begin
        if (reset = '1') then
            -- Tri-state outputs and reset the state for the first trigger
            scl_local <= '1';
            sda_local <= '1';
            state <= START1;
        elsif (clock'Event and clock = '1') then
            -- Assume we are not pausing
            pause_running <= '0';

            if (restart = '1') then
                -- On restart force the state
                state <= RESTART1;
            end if;

            if (running = '1' and running_clock = '1' and previous_running_clock = '0') then
                case state is
                    when START1 =>
                        scl_local <= '1';
                        sda_local <= '1';
                        state <= START2;

                    when START2 =>
                        -- Prepare for sending the address by setting bit count up and setting up the
                        -- byte value we are writing to the address + read/write mode
                        sda_local <= '0';
                        clock_flip := '0';
                        bit_counter := 8;
                        data_to_write := address & read_write;
                        state <= WRITING_DATA;

                    when WRITING_DATA =>
                        -- Two cycles per bit
                        scl_local <= clock_flip;
                        -- Assert the actual bit we are writing using the bit_counter
                        sda_local <= data_to_write (bit_counter - 1);
                        if (clock_flip = '1') then
                            -- Clock going down, then next bit and move to ACK when all are sent
                            bit_counter := bit_counter - 1;
                            if (bit_counter = 0) then
                                state <= WRITING_ACK;
                            end if;
                        end if;
                        clock_flip := not clock_flip;

                    when WRITING_ACK =>
                        scl_local <= clock_flip;
                        -- Tri-state the SDA as an input
                        sda_local <= '1';
                        if (clock_flip = '1') then
                            -- Latch the SDA input
                            ack_error <= sda;
                            if (last_byte = '1') then
                                -- Last byte to write? Generate a STOP sequence
                                state <= STOP1;
                            else
                                -- Otherwise wait for the next trigger. We might be reading or writing now, as
                                -- this byte sent might have been the slave address
                                pause_running <= '1';
                                if (read_write = '0') then
                                    state <= WRITE_WAITING;
                                else
                                    state <= READ_WAITING;
                                end if;
                            end if;
                        end if;
                        clock_flip := not clock_flip;

                    when WRITE_WAITING =>
                        -- Get ready for the next byte to write
                        data_to_write := write_data;
                        bit_counter := 8;
                        state <= WRITING_DATA;

                    when READING_DATA =>
                        scl_local <= clock_flip;
                        -- Tri-state the SDA so we can input on it
                        sda_local <= '1';
                        if (clock_flip = '1') then
                            -- Clock going down, then decreemnt the bit count and at the end, switch to reading
                            -- ACK state
                            bit_counter := bit_counter - 1;
                            if (bit_counter = 0) then
                                state <= READING_ACK;
                            end if;
                            -- Get the actual data bit
                            read_data (bit_counter) <= sda;
                        end if;
                        clock_flip := not clock_flip;

                    when READING_ACK =>
                        scl_local <= clock_flip;
                        -- ACK or NAK based on wether this is the last byte
                        sda_local <= last_byte;
                        if (clock_flip = '1') then
                            -- Clock going down? If this is the last byte we need to STOP,
                            -- otherwise wait on trigger for the next byte to read
                            if (last_byte = '1') then
                                state <= STOP1;
                            else
                                pause_running <= '1';
                                state <= READ_WAITING;
                            end if;
                        end if;
                        clock_flip := not clock_flip;

                    when READ_WAITING =>
                        -- Prepare the bit counter
                        bit_counter := 8;
                        state <= READING_DATA;

                    when STOP1 =>
                        sda_local <= '0';
                        scl_local <= '0';
                        state <= STOP2;

                    when STOP2 =>
                        scl_local <= '1';
                        state <= STOP3;

                    when STOP3 =>
                        -- Wait for next trigger to start the next transaction
                        sda_local <= '1';
                        pause_running <= '1';
                        state <= START1;

                    when RESTART1 =>
                        -- Full START by setting the outputs to 0 seems to be needed
                        scl_local <= '0';
                        sda_local <= '0';
                        state <= START1;
                end case;
            end if;
        end if;
    end process;

    busy <= running;
    -- Tri-state if the internal signal is 1
    scl <= 'Z' when (scl_local = '1') else '0';
    sda <= 'Z' when (sda_local = '1') else '0';
end architecture;
