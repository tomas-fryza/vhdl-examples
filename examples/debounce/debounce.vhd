-- https://stackoverflow.com/questions/61630181/vhdl-button-debouncing-or-not-as-the-case-may-be

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity debounce is
    generic ( DB_TIME : time := 25 ms );
    port (
        clk     : in    std_logic;
        btn_in  : in    std_logic; -- Asynchronous and noisy input
        btn_out : out   std_logic; -- Synchronised, debounced and filtered output
        edge    : out   std_logic;
        rise    : out   std_logic;
        fall    : out   std_logic
    );
end entity debounce;

architecture v1 of debounce is
    constant CLK_PERIOD : time     := 10 ns;
    constant MAX_COUNT  : natural  := DB_TIME / CLK_PERIOD;
    constant SYNC_BITS  : positive := 2;  -- Number of bits in the synchronisation buffer (2 minimum)

    signal sync_buffer : std_logic_vector(SYNC_BITS - 1 downto 0);
    alias  sync_input  : std_logic is sync_buffer(SYNC_BITS - 1);
    signal sig_count   : natural range 0 to MAX_COUNT - 1;
    signal sig_btn     : std_logic;

begin
    p_debounce : process (clk) is
        variable edge_internal : std_logic;
        variable rise_internal : std_logic;
        variable fall_internal : std_logic;

    begin
        if rising_edge(clk) then
            -- Synchronise the asynchronous input
            -- MSB of sync_buffer is the synchronised input
            sync_buffer <= sync_buffer(SYNC_BITS - 2 downto 0) & btn_in;

            edge <= '0';
            rise <= '0';
            fall <= '0';

            -- If successfully debounced, notify what happened, and reset the sig_count
            if (sig_count = MAX_COUNT - 1) then
                sig_btn   <= sync_input;
                edge      <= edge_internal;
                rise      <= rise_internal;
                fall      <= fall_internal;
                sig_count <= 0;
            elsif (sync_input /= sig_btn) then
                sig_count <= sig_count + 1;
            else
                sig_count <= 0;
            end if;
        end if;

        -- Edge detection
        edge_internal := sync_input xor sig_btn;
        rise_internal := sync_input and not sig_btn;
        fall_internal := not sync_input and sig_btn;
        btn_out       <= sig_btn;

    end process p_debounce;

end architecture v1;
