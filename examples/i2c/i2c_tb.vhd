library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity i2c_tb is
end entity;

architecture behavioral of i2c_tb is
    signal i2c_clock : STD_LOGIC;
    signal i2c_reset : STD_LOGIC;
    signal i2c_trigger : STD_LOGIC;
    signal i2c_restart : STD_LOGIC;
    signal i2c_last_byte : STD_LOGIC;
    signal i2c_address : STD_LOGIC_VECTOR (6 downto 0);
    signal i2c_read_write : STD_LOGIC;
    signal i2c_write_data : STD_LOGIC_VECTOR (7 downto 0);
    signal i2c_read_data : STD_LOGIC_VECTOR (7 downto 0);
    signal i2c_ack_error : STD_LOGIC;
    signal i2c_busy : STD_LOGIC;
    signal i2c_scl : STD_LOGIC;
    signal i2c_sda : STD_LOGIC;
begin
    dut: entity work.i2c_controller port map (
        clock => i2c_clock,
        reset => i2c_reset,
        trigger => i2c_trigger,
        restart => i2c_restart,
        last_byte => i2c_last_byte,
        address => i2c_address,
        read_write => i2c_read_write,
        write_data => i2c_write_data,
        read_data => i2c_read_data,
        ack_error => i2c_ack_error,
        busy => i2c_busy,
        scl => i2c_scl,
        sda => i2c_sda
    );

    process
    begin
        i2c_clock <= '0';
        wait for 1 ns;
        i2c_clock <= '1';
        wait for 1 ns;
    end process;

    process
    begin
        -- Reset sequence
        i2c_reset <= '1';
        i2c_trigger <= '0';
        i2c_restart <= '0';
        wait for 2 ns;

        -- Write two bytes
        i2c_reset <= '0';
        i2c_address <= "1101000";
        i2c_read_write <= '0';
        i2c_write_data <= x"00";
        i2c_last_byte <= '0';
        i2c_trigger <= '1';

        wait for 2 ns;
        i2c_trigger <= '0';

        wait until (i2c_busy = '0');
        wait for 1 us;

        i2c_write_data <= x"0f";
        i2c_trigger <= '1';
        i2c_last_byte <= '0';
        wait for 2 ns;
        i2c_trigger <= '0';

        wait until (i2c_busy = '0');
        wait for 1 us;

        i2c_write_data <= x"aa";
        i2c_trigger <= '1';
        i2c_last_byte <= '0';
        wait for 2 ns;
        i2c_trigger <= '0';

        wait until (i2c_busy = '0');
        wait for 2 us;

        -- Read after restart
        i2c_read_write <= '1';
        i2c_write_data <= x"00";
        i2c_last_byte <= '0';
        i2c_trigger <= '1';
        i2c_restart <= '1';
        wait for 2 ns;
        i2c_trigger <= '0';
        i2c_restart <= '0';

        wait until (i2c_busy = '0');
        wait for 1 us;

        i2c_trigger <= '1';
        wait for 2 ns;
        i2c_trigger <= '0';

        wait until (i2c_busy = '0');
        wait for 1 us;

        i2c_trigger <= '1';
        i2c_last_byte <= '1';
        wait for 2 ns;
        i2c_trigger <= '0';

        wait until (i2c_busy = '0');
        wait for 1 us;

        report "+++All good";
        std.env.finish;
    end process;

    process
    begin
        wait on i2c_scl, i2c_sda, i2c_busy;
        report "SCL: " & to_string(i2c_scl) & " SDA: " & to_string(i2c_sda) & " Busy: " & to_string(i2c_busy);
    end process;

end architecture;
