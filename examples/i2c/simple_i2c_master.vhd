library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity simple_i2c_master is
    port (
        clk       : in  STD_LOGIC;
        rst       : in  STD_LOGIC;
        start     : in  STD_LOGIC;
        addr      : in  STD_LOGIC_VECTOR(6 downto 0);
        rw    : in  STD_LOGIC;  -- 0 = write, 1 = read
        -- data_in   : in  STD_LOGIC_VECTOR(7 downto 0);
        busy      : out STD_LOGIC;
        -- ack_error : out STD_LOGIC;
        scl       : out STD_LOGIC;
        sda       : out STD_LOGIC
    );
end entity;

architecture rtl of simple_i2c_master is

    type state_type is (IDLE, GEN_START, SEND_BIT, DONE);
    signal current_state : state_type := IDLE;

    signal clk_div  : unsigned(7 downto 0) := (others => '0');
    -- signal tick     : std_logic := '0';

    signal scl_int  : std_logic := '1';
    signal sda_int  : std_logic := '1';

    signal shift_reg : std_logic_vector(7 downto 0);
    signal bit_cnt   : integer range 0 to 7 := 0;

    signal phase : std_logic := '0'; -- 0 = SCL low, 1 = SCL high

begin

    ----------------------------------------------------------------
    -- FSM
    ----------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                current_state <= IDLE;
                scl_int <= '1';
                sda_int <= '1';
                busy <= '0';
                phase <= '0';

            else

                case current_state is

                    ------------------------------------------------
                    when IDLE =>
                        scl_int <= '1';
                        sda_int <= '1';
                        busy <= '0';

                        if start = '1' then
                            busy <= '1';
                            shift_reg <= addr & rw;
                            bit_cnt <= 7;
                            current_state <= GEN_START;
                        end if;

                    ------------------------------------------------
                    when GEN_START =>
                        -- START = SDA goes low while SCL high
                        scl_int <= '1';
                        sda_int <= '0';
                        phase <= '0';
                        current_state <= SEND_BIT;

                    ------------------------------------------------
                    when SEND_BIT =>
                        if phase = '0' then
                            -- SCL low: set data
                            scl_int <= '0';
                            sda_int <= shift_reg(bit_cnt);
                            phase <= '1';

                        else
                            -- SCL high: clock the bit
                            scl_int <= '1';
                            phase <= '0';

                            if bit_cnt = 0 then
                                current_state <= DONE;
                            else
                                bit_cnt <= bit_cnt - 1;
                            end if;
                        end if;

                    ------------------------------------------------
                    when DONE =>
                        -- Hold bus (no STOP yet)
                        scl_int <= '1';
                        sda_int <= '1';
                        busy <= '0';
                        current_state <= IDLE;

                    -- Default: In case of an unexpected state, return to IDLE
                    when others =>
                        current_state <= IDLE;

                end case;
            end if;
        end if;
    end process;

    scl <= scl_int;
    sda <= sda_int;

end architecture;
