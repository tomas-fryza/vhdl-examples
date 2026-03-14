library ieee;
use ieee.std_logic_1164.all;

entity debounce is
    port (
        clk         : in  std_logic;
        rst         : in  std_logic;
        btn_in      : in  std_logic;

        btn_state   : out std_logic;  -- debounced level
        btn_press   : out std_logic;  -- 1-clock press pulse
        btn_release : out std_logic   -- 1-clock release pulse
    );
end entity debounce;

architecture Behavioral of debounce is

    ----------------------------------------------------------------
    -- constants
    ----------------------------------------------------------------
    constant C_SHIFT_LEN : positive := 8;  -- debounce history
    constant C_MAX       : positive := 2;  -- sampling period
                                           -- 100_000 for implementation

    ----------------------------------------------------------------
    -- signals
    ----------------------------------------------------------------
    signal ce_sample : std_logic;

    signal sync0 : std_logic;
    signal sync1 : std_logic;

    signal shift_reg : std_logic_vector(C_SHIFT_LEN-1 downto 0);

    signal debounced      : std_logic;
    signal debounced_prev : std_logic;

    -- Component declaration for clock enable
    component clk_en is
        generic ( G_MAX : positive );
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            ce  : out std_logic
        );
    end component clk_en;
    
begin

    ----------------------------------------------------------------
    -- clock enable instance (your module)
    ----------------------------------------------------------------
    clk_enable_inst : clk_en
    generic map ( G_MAX => C_MAX )
    port map (
        clk => clk,
        rst => rst,
        ce  => ce_sample
    );

    ----------------------------------------------------------------
    -- synchronizer + debounce
    ----------------------------------------------------------------
    p_debounce : process(clk)
    begin
        if rising_edge(clk) then

            if rst = '1' then

                sync0 <= '0';
                sync1 <= '0';
                shift_reg <= (others => '0');

                debounced <= '0';
                debounced_prev <= '0';

            else

                -- input synchronizer
                sync1 <= sync0;
                sync0 <= btn_in;

                -- sample only when enable pulse occurs
                if ce_sample = '1' then

                    shift_reg <= shift_reg(C_SHIFT_LEN-2 downto 0) & sync1;

                    if shift_reg = (shift_reg'range => '1') then
                        debounced <= '1';

                    elsif shift_reg = (shift_reg'range => '0') then
                        debounced <= '0';

                    end if;

                end if;

                debounced_prev <= debounced;

            end if;

        end if;
    end process;

    ----------------------------------------------------------------
    -- outputs
    ----------------------------------------------------------------
    btn_state <= debounced;

    -- one-clock pulse when button pressed and released
    btn_press <= not(debounced_prev) and debounced;
    btn_release <= debounced_prev and not(debounced);

end architecture Behavioral;
