-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Thu, 10 Apr 2025 18:59:05 GMT
-- Request id : cfwk-fed377c2-67f814f99600d

library ieee;
    use ieee.std_logic_1164.all;

entity tb_debounce is
end entity tb_debounce;

architecture tb of tb_debounce is
    component debounce is
        generic ( DB_TIME : time );
        port (
            clk     : in    std_logic;
            btn_in  : in    std_logic;
            btn_out : out   std_logic;
            edge    : out   std_logic;
            rise    : out   std_logic;
            fall    : out   std_logic
        );
    end component debounce;

    signal clk     : std_logic;
    signal btn_in  : std_logic;
    signal btn_out : std_logic;
    signal edge    : std_logic;
    signal rise    : std_logic;
    signal fall    : std_logic;

    constant TBPERIOD   : time      := 10 ns; -- ***EDIT*** Put right period here
    signal   tbclock    : std_logic := '0';
    signal   tbsimended : std_logic := '0';

begin
    dut : debounce
        generic map ( DB_TIME => 25 ns )
        port map (
            clk     => clk,
            btn_in  => btn_in,
            btn_out => btn_out,
            edge    => edge,
            rise    => rise,
            fall    => fall
        );

    -- Clock generation
    tbclock <= not tbclock after TBPERIOD / 2 when tbsimended /= '1' else
               '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= tbclock;

    stimuli : process is
    begin
        btn_in <= '0';
        wait for 50 * TBPERIOD;

        btn_in <= '1';
        wait for 11 ns;
        btn_in <= '0';
        wait for 11 ns;
        btn_in <= '1';
        wait for 11 ns;
        btn_in <= '0';
        wait for 11 ns;
        btn_in <= '1';
        wait for 100 * TBPERIOD;

        btn_in <= '0';
        wait for 11 ns;
        btn_in <= '1';
        wait for 11 ns;
        btn_in <= '0';
        wait for 100 * TBPERIOD;

        -- Stop the clock and hence terminate the simulation
        tbsimended <= '1';
        wait;
    end process stimuli;

end architecture tb;
