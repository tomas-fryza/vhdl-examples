library ieee;
use ieee.std_logic_1164.all;

entity debounce is
    port (
        clk         : in  std_logic;
        rst         : in  std_logic;
        btn_in      : in  std_logic;  -- Bouncey button input
        btn_state   : out std_logic;  -- Debounced level
        btn_press   : out std_logic;  -- 1-clock press pulse
        btn_release : out std_logic   -- 1-clock release pulse
    );
end entity debounce;

architecture Behavioral of debounce is

    ----------------------------------------------------------------
    -- Constants
    ----------------------------------------------------------------
    constant C_SHIFT_LEN : positive := 8;  -- Debounce history
    constant C_MAX       : positive := 2;  -- Sampling period
                                           -- 2 for simulation
                                           -- 100_000 (1 ms) for implementation !!!

    ----------------------------------------------------------------
    -- Internal signals
    ----------------------------------------------------------------
    signal ce_sample : std_logic;
    signal sync0     : std_logic;
    signal sync1     : std_logic;
    signal shift_reg : std_logic_vector(C_SHIFT_LEN-1 downto 0);
    signal debounced : std_logic;
    signal delayed   : std_logic;

    ----------------------------------------------------------------
    -- Component declaration for clock enable
    ----------------------------------------------------------------
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
    -- Clock enable instance (your module)
    ----------------------------------------------------------------
    clock_0 : clk_en
        generic map ( G_MAX => C_MAX )
        port map (
            clk => clk,
            rst => rst,
            ce  => ce_sample
        );

    ----------------------------------------------------------------
    -- Synchronizer + debounce
    ----------------------------------------------------------------
    p_debounce : process(clk)
    begin
        if rising_edge(clk) then

            if rst = '1' then
                sync0     <= '0';
                sync1     <= '0';
                shift_reg <= (others => '0');
                debounced <= '0';
                delayed   <= '0';

            else
                -- Input synchronizer
                sync1 <= sync0;
                sync0 <= btn_in;

                -- Sample only when enable pulse occurs
                if ce_sample = '1' then

                    -- Shift values to the left and load a new sample as LSB
                    shift_reg <= shift_reg(C_SHIFT_LEN-2 downto 0) & sync1;

                    -- Check if all bits are '1'
                    if shift_reg = (shift_reg'range => '1') then
                        debounced <= '1';
                    -- Check if all bits are '0'
                    elsif shift_reg = (shift_reg'range => '0') then
                        debounced <= '0';
                    end if;

                end if;

                -- One clock delayed output
                delayed <= debounced;
            end if;

        end if;
    end process;

    ----------------------------------------------------------------
    -- Outputs
    ----------------------------------------------------------------
    btn_state <= debounced;

    -- One-clock pulse when button pressed and released
    btn_press   <= debounced and not(delayed);
    btn_release <= not(debounced) and delayed;

end architecture Behavioral;
