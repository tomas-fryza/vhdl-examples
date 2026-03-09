-------------------------------------------------
--! @brief Top level design with debouncer and counter
--! @version 1.0
--! @copyright (c) 2024 Tomas Fryza, MIT license
--!
--! This VHDL module implements a top-level design that integrates
--! a debouncer and a simple counter. The debouncer is used to debounce
--! a button input, and the counter increments based on the debounced
--! signal.
--!
--! Dependencies:
--!  debounce.vhdl
--!  counter.vhdl
--!  clock_en.vhdl
--!
--! Developed using TerosHDL, Vivado 2023.2, and EDA Playground.
--! Tested on Nexys A7-50T board and xc7a50ticsg324-1L FPGA.
-------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;

-------------------------------------------------

entity top_level is
    port (
        CLK100MHZ : in    std_logic;                    --! Main clock
        LED       : out   std_logic_vector(3 downto 0); --! Show 4-bit counter value
        LED16_B   : out   std_logic;                    --! Show debounced signal
        BTNC      : in    std_logic;                    --! Synchronous reset
        BTNR      : in    std_logic                     --! Bouncey button to increment 4-bit counter
    );
end entity top_level;

-------------------------------------------------

architecture Behavioral of top_level is
    -- Component declaration for clock enable
    component clock_en is
        generic ( N_PERIODS : integer );
        port (
            clk   : in    std_logic;
            rst   : in    std_logic;
            pulse : out   std_logic
        );
    end component;

    -- Component declaration for button debouncer
    component debounce is
        port (
            clk      : in    std_logic;
            rst      : in    std_logic;
            en       : in    std_logic;
            bouncey  : in    std_logic;
            clean    : out   std_logic;
            pos_edge : out   std_logic;
            neg_edge : out   std_logic
        );
    end component;

    -- Component declaration for simple counter
    component counter is
        generic ( N_BITS : integer );
        port (
            clk   : in    std_logic;
            rst   : in    std_logic;
            en    : in    std_logic;
            count : out   std_logic_vector(N_BITS - 1 downto 0)
        );
    end component;

    -- Local signals
    --! Clock enable signal for debouncer
    signal sig_en_2ms : std_logic;
    --! Edge-driven signal that lasts for only one clock cycle
    signal sig_event : std_logic;
begin

    -- Component instantiation of clock enable for 2 ms
    clk_en : clock_en
        generic map ( N_PERIODS => 200_000 )
        port map (
            clk   => CLK100MHZ,
            rst   => BTNC,
            pulse => sig_en_2ms
        );

    -- Component instantiation of button debouncer
    display : debounce
        port map (
            clk      => CLK100MHZ,
            rst      => BTNC,
            en       => sig_en_2ms,
            bouncey  => BTNR,
            clean    => LED16_B,
            pos_edge => sig_event,
            neg_edge => open
        );

    -- Component instantiation of 4-bit simple counter
    counter : counter
        generic map ( N_BITS => 4 )
        port map (
            clk   => CLK100MHZ,
            rst   => BTNC,
            en    => sig_event,
            count => LED
        );

end Behavioral;
