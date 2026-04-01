library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------
-- I2C Master Transmitter Entity (Minimal)
entity simple_i2c is
    port (
        clk          : in    std_logic;                     -- Main clock
        rst          : in    std_logic;                     -- Synchronous reset
        addr         : in    std_logic_vector(6 downto 0);  -- 7-bit slave address
        start        : in    std_logic;                     -- Start transmission
        scl          : out   std_logic;                     -- I2C clock
        sda          : inout std_logic;                     -- I2C data (open-drain)
        ack_error    : out   std_logic;                     -- ACK error flag
        busy         : out   std_logic                      -- Busy signal
    );
end entity;

-------------------------------------------------
-- Architecture
architecture Behavioral of simple_i2c is

    constant MAX : integer := 2; -- small for simulation

    type state_type is (
        IDLE,
        START_COND,
        SEND_ADDR,
        ACK_BIT,
        STOP_COND
    );

    signal state     : state_type;
    signal clk_cnt   : integer range 0 to MAX-1;
    signal bit_cnt   : integer range 0 to 7;

    signal scl_int   : std_logic := '1';

    -- Open-drain handling
    signal sda_out   : std_logic := '1'; -- '0' = drive low, '1' = release
    signal sda_in    : std_logic;

    signal shift_reg : std_logic_vector(7 downto 0);

begin

    -- Outputs
    scl <= scl_int;

    -- Open-drain SDA: drive 0 or release (Z)
    sda <= '0' when sda_out = '0' else '1';

    -- Read actual bus level
    sda_in <= sda;

    -------------------------------------------------
    -- FSM
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state      <= IDLE;
                scl_int    <= '1';
                sda_out    <= '1';
                clk_cnt    <= 0;
                bit_cnt    <= 0;
                ack_error  <= '0';
                busy       <= '0';

            else
                case state is

                    -------------------------------------------------
                    when IDLE =>
                        scl_int   <= '1';
                        sda_out   <= '1'; -- release
                        busy      <= '0';
                        ack_error <= '0';

                        if start = '1' then
                            shift_reg <= addr & '0'; -- write bit
                            state <= START_COND;
                            clk_cnt <= 0;
                        end if;

                    -------------------------------------------------
                    -- START condition
                    -- SDA goes low while SCL is high
                    when START_COND =>
                        scl_int <= '1';
                        sda_out <= '0';
                        busy    <= '1';

                        if clk_cnt = MAX-1 then
                            clk_cnt <= 0;
                            bit_cnt <= 7;
                            state <= SEND_ADDR;
                        else
                            clk_cnt <= clk_cnt + 1;
                        end if;

                    -------------------------------------------------
                    -- Send address byte (MSB first)
                    when SEND_ADDR =>
                        scl_int <= '0';
                        sda_out <= shift_reg(bit_cnt);
                        busy    <= '1';

                        if clk_cnt = MAX-1 then
                            scl_int <= '1'; -- data valid on rising edge

                            if bit_cnt = 0 then
                                state <= ACK_BIT;
                            else
                                bit_cnt <= bit_cnt - 1;
                            end if;

                            clk_cnt <= 0;
                        else
                            clk_cnt <= clk_cnt + 1;
                        end if;

                    -------------------------------------------------
                    -- ACK bit
                    when ACK_BIT =>
                        scl_int <= '0';
                        sda_out <= '1'; -- RELEASE line!
                        busy    <= '1';

                        if clk_cnt = MAX-1 then
                            scl_int <= '1'; -- slave drives SDA now

                            -- sample ACK
                            if sda_in = '1' then
                                ack_error <= '1'; -- NACK
                            else
                                ack_error <= '0'; -- ACK received
                            end if;

                            clk_cnt <= 0;
                            state <= STOP_COND;
                        else
                            clk_cnt <= clk_cnt + 1;
                        end if;

                    -------------------------------------------------
                    -- STOP condition
                    -- SDA goes high while SCL is high
                    when STOP_COND =>
                        scl_int <= '1';
                        sda_out <= '0';
                        busy    <= '1';

                        if clk_cnt = MAX-1 then
                            sda_out <= '1'; -- release → pulled high
                            state <= IDLE;
                            clk_cnt <= 0;
                        else
                            clk_cnt <= clk_cnt + 1;
                        end if;

                    -------------------------------------------------
                    when others =>
                        state <= IDLE;

                end case;
            end if;
        end if;
    end process;

end Behavioral;
