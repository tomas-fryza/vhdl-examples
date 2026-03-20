-- Use Serial monitor, such as:
-- https://hhdsoftware.com/online-serial-port-monitor

library ieee;
use ieee.std_logic_1164.all;

entity uart_top is
    port (
        clk          : in  std_logic;
        btnu         : in  std_logic;
        sw           : in  std_logic_vector(7 downto 0);
        btnd         : in  std_logic;
        uart_rxd_out : out std_logic;
        led16_b      : out std_logic;
        led17_g      : out std_logic
    );
end entity uart_top;

architecture Behavioral of uart_top is

    component debounce
        Port ( clk       : in  STD_LOGIC;
               rst       : in  STD_LOGIC;
               btn_in    : in  STD_LOGIC;
               btn_state : out STD_LOGIC;
               btn_press : out STD_LOGIC);
    end component; 

    component uart_tx
        port (
            clk         : in  std_logic;
            rst         : in  std_logic;
            data        : in  std_logic_vector(7 downto 0);
            tx_start    : in  std_logic;
            tx          : out std_logic;
            tx_complete : out std_logic
        );
    end component;

    -- Internal signal(s)
    signal sig_tx_en : std_logic;

begin

    debounce_inst : debounce
        port map (
            clk       => clk,
            rst       => btnu,
            btn_in    => btnd,
            btn_state => led16_b,
            btn_press => sig_tx_en
        );

    uart_tx_inst : uart_tx
        port map (
            clk         => clk,
            rst         => btnu,
            data        => sw,
            tx_start    => sig_tx_en,
            tx          => uart_rxd_out,
            tx_complete => led17_g
        );

end architecture Behavioral;
