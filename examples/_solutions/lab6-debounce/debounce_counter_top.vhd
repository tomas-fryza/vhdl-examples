library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------
entity debounce_counter_top is
    Port ( clk     : in  STD_LOGIC;
           btnu    : in  STD_LOGIC;
           btnd    : in  STD_LOGIC;
           led     : out STD_LOGIC_VECTOR(7 downto 0);
           led16_b : out STD_LOGIC);
end debounce_counter_top;
----------------------------------------------
architecture Behavioral of debounce_counter_top is

    -- Component declaration of `debounce`
    component debounce is
        Port ( clk       : in  STD_LOGIC;
               rst       : in  STD_LOGIC;
               btn_in    : in  STD_LOGIC;
               btn_state : out STD_LOGIC;
               btn_press : out STD_LOGIC);
    end component debounce;

    component counter is
        -- TODO: Add component declaration of `counter`
        generic ( G_BITS : positive );
        port (
            clk : in  std_logic;                             --! Main clock
            rst : in  std_logic;                             --! High-active synchronous reset
            en  : in  std_logic;                             --! Clock enable input
            cnt : out std_logic_vector(G_BITS - 1 downto 0)  --! Counter value
        );
    end component counter;

    -- Internal signal(s)
    signal sig_cnt_en : std_logic;

begin

    ------------------------------------------------------------------------
    -- Button debouncer
    ------------------------------------------------------------------------
    debounce_0 : debounce
        port map (
            clk       => clk,
            rst       => btnu,
            btn_in    => btnd,
            btn_press => sig_cnt_en,
            btn_state => led16_b
        );

    ------------------------------------------------------------------------
    -- Counter
    ------------------------------------------------------------------------
    counter_0 : counter
        generic map ( G_BITS => 8 )
        port map (
            -- TODO: Add component instantiation of `counter`
            clk => clk,
            rst => btnu,
            en  => sig_cnt_en,
            cnt => led
        );

end Behavioral;
