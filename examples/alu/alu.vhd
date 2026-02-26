-------------------------------------------------
--! @brief 4-bit Arithmetic Logic Unit (ALU)
--! @version 1.0
--! @copyright (c) 2025 Tomas Fryza, MIT license
--!
--! This VHDL module implements 4-bit ALU, including
--! 7 operations.
--!
--! Developed using TerosHDL, Vivado 2023.2.
--! Tested on Nexys A7-50T board and xc7a50ticsg324-1L FPGA.
-------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all; -- Package for data type conversions

-------------------------------------------------

entity alu_4bit is
    port (
        a      : in    std_logic_vector(3 downto 0); --! 4-bit inputs
        b      : in    std_logic_vector(3 downto 0);
        oper   : in    std_logic_vector(2 downto 0); --! ALU operation selector
        result : out   std_logic_vector(3 downto 0); --! 4-bit output
        carry  : out   std_logic;                    --! Carry out flag
        zero   : out   std_logic                     --! Zero flag
    );
end entity alu_4bit;

-------------------------------------------------

architecture behavioral of alu_4bit is
    signal sig_res : std_logic_vector(4 downto 0);  -- Extra bit for carry
begin

    p_alu : process (a, b, oper) is
    begin

        case oper is

            when "000" =>  -- NOT A
                sig_res <= '0' & not a;

            when "001" =>  -- ADD
                sig_res <= std_logic_vector(
                    unsigned('0' & a) +
                    unsigned('0' & b));

            when "010" =>  -- SUB
                sig_res <= std_logic_vector(
                    unsigned('0' & a) -
                    unsigned('0' & b));

            when "011" =>  -- Multiply by 2 (Shift Left)
                sig_res <= a(3 downto 0) & '0';

            when "100" =>  -- Divide by 2 (Shift Right)
                sig_res <= "00" & a(3 downto 1);

            when "101" =>  -- Increment A
                sig_res <= std_logic_vector(
                    unsigned('0' & a) + 1);

            when "110" =>  -- Decrement A
                sig_res <= std_logic_vector(
                    unsigned('0' & a) - 1);

            when others =>  -- Default case
                sig_res <= b"0_0000";

        end case;

    end process p_alu;

    -- Assign outputs
    result <= sig_res(3 downto 0);
    carry  <= sig_res(4); -- Carry bit
    zero   <= '1' when sig_res(3 downto 0) = "0000" else
              '0';        -- Zero flag

end architecture behavioral;
