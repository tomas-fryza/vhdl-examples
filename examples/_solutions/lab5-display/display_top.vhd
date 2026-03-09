library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity display_top is
    Port ( clk  : in  STD_LOGIC;
           btnu : in  STD_LOGIC;
           sw   : in  STD_LOGIC_VECTOR(7 downto 0);
           seg  : out STD_LOGIC_VECTOR(6 downto 0);
           an   : out STD_LOGIC_VECTOR(7 downto 0);
           dp   : out STD_LOGIC);
end display_top;

architecture Behavioral of display_top is

    -- Component declaration for display_driver
    component display_driver is
    Port ( clk   : in  STD_LOGIC;
           rst   : in  STD_LOGIC;
           data  : in  STD_LOGIC_VECTOR(7 downto 0);
           seg   : out STD_LOGIC_VECTOR(6 downto 0);
           anode : out STD_LOGIC_VECTOR(1 downto 0));
    end component display_driver;

begin

    -- Display driver instantiation
    display_1 : display_driver
    port map (
       clk  => clk,
       rst   => btnu,
       data  => sw,
       seg   => seg,
       anode => an(1 downto 0)
    );

    an(7 downto 2) <= b"11_1111";
    dp <= '1';

end Behavioral;
