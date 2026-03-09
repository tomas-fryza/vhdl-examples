--! @title Traffic light controller using a FSM
--! @author Tomas Fryza
--! Dept. of Radio Electronics, Brno Univ. of Technology, Czechia
--! @version 0.2
--! @date 2023-04-30
--!
--! @copyright Copyright (c) 2020 by Tomas Fryza
--! This work is licensed under the terms of the MIT license.
--!
--! This code is inspired by:
--!   * LBEbooks, Lesson 92 - Example 62: Traffic Light Controller
--!     https://www.youtube.com/watch?v=6_Rotnw1hFM
--!   * David Williams, Implementing a Finite State Machine in VHDL
--!     https://www.allaboutcircuits.com/technical-articles/implementing-a-finite-state-machine-in-vhdl/
--!   * VHDLwhiz, One-process vs two-process vs three-process state machine
--!     https://vhdlwhiz.com/n-process-state-machine/
--!
--! @details
--! Tested on Nexys A7-50T board, xc7a50ticsg324-1L FPGA
--! Software: TerosHDL, Vivado 2020.2, EDA Playground
--!

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

----------------------------------------------------------
-- Entity declaration for traffic light controller
----------------------------------------------------------

entity tlc is
  port (
    clk   : in    std_logic;                    --! Main clock
    rst   : in    std_logic;                    --! High-active synchronous reset
    south : out   std_logic_vector(2 downto 0); --! Traffic light for "south" direction
    west  : out   std_logic_vector(2 downto 0)  --! Traffic light for "west" direction
  );
end entity tlc;

----------------------------------------------------------
-- Architecture declaration for traffic light controller
----------------------------------------------------------

architecture Behavioral of tlc is

  --! Define the FSM states
  type t_state is (
    WEST_STOP,
    WEST_GO,
    WEST_WAIT,
    SOUTH_STOP,
    SOUTH_GO,
    SOUTH_WAIT
  );

  --! Define the signal that uses different states
  signal sig_state : t_state;

  --! Internal clock enable
  signal sig_en : std_logic;

  --! Local delay counter
  signal sig_cnt : unsigned(4 downto 0);

  -- Specific values for local counter
  constant c_DELAY_4SEC : unsigned(4 downto 0) := b"1_0000"; --! 4-second delay
  constant c_DELAY_2SEC : unsigned(4 downto 0) := b"0_1000"; --! 2-second delay
  constant c_DELAY_1SEC : unsigned(4 downto 0) := b"0_0100"; --! 1-second delay

  -- Output traffic lights' values
  constant c_RED    : std_logic_vector(2 downto 0) := b"100"; --! RGB settings for red color
  constant c_YELLOW : std_logic_vector(2 downto 0) := b"110"; --! RGB settings for yellow color
  constant c_GREEN  : std_logic_vector(2 downto 0) := b"010"; --! RGB settings for green color

begin

  --------------------------------------------------------
  -- Instance (copy) of clock_en entity generates
  -- an enable pulse every 250 ms (4 Hz)
  --------------------------------------------------------
  clk_en0 : entity work.clock_en
    generic map ( g_MAX => 1 )
      -- FOR SIMULATION, KEEP THIS VALUE TO 1
      -- FOR IMPLEMENTATION, CALCULATE VALUE: 250 ms / (1/100 MHz)
      -- 1   @ 10 ns
      -- ??? @ 250 ms
    port map (
      clk => clk,
      rst => rst,
      ce  => sig_en
    );

  --------------------------------------------------------
  --! A sequential process with synchronous reset and
  --! clock_en entirely controls the sig_state signal
  --! by CASE statement.
  --------------------------------------------------------
  p_traffic_fsm : process (clk) is
  begin

    if (rising_edge(clk)) then
      if (rst = '1') then                    -- Synchronous reset
        sig_state <= WEST_STOP;              -- Init state
        sig_cnt   <= (others => '0');        -- Clear delay counter
      elsif (sig_en = '1') then
        -- Every 250 ms, CASE checks the value of sig_state
        -- local signal and changes to the next state
        -- according to the delay value.
        case sig_state is

          when WEST_STOP =>
            -- Count to 2 secs
            if (sig_cnt < c_DELAY_2SEC) then
              sig_cnt <= sig_cnt + 1;
            else
              -- Move to the next state
              sig_state <= WEST_GO;
              -- Reset delay counter value
              sig_cnt   <= (others => '0');
            end if;

          when WEST_GO =>
            -- WRITE OTHER STATES HERE
            -- Count to 4 secs
            if (sig_cnt < c_DELAY_4SEC) then
              sig_cnt <= sig_cnt + 1;
            else
              -- Move to the next state
              sig_state <= WEST_WAIT;
              -- Reset local counter value
              sig_cnt   <= (others => '0');
            end if;

            when WEST_WAIT =>
            -- Count to 1 sec
            if (sig_cnt < c_DELAY_1SEC) then
              sig_cnt <= sig_cnt + 1;
            else
              -- Move to the next state
              sig_state <= SOUTH_STOP;
              -- Reset local counter value
              sig_cnt   <= (others => '0');
            end if;

            when SOUTH_STOP =>
            -- Count to 2 secs
            if (sig_cnt < c_DELAY_2SEC) then
              sig_cnt <= sig_cnt + 1;
            else
              -- Move to the next state
              sig_state <= SOUTH_GO;
              -- Reset local counter value
              sig_cnt   <= (others => '0');
            end if;

            when SOUTH_GO =>
            -- Count to 4 secs
            if (sig_cnt < c_DELAY_4SEC) then
              sig_cnt <= sig_cnt + 1;
            else
              -- Move to the next state
              sig_state <= SOUTH_WAIT;
              -- Reset local counter value
              sig_cnt   <= (others => '0');
            end if;

            when SOUTH_WAIT =>
            -- Count to 1 sec
            if (sig_cnt < c_DELAY_1SEC) then
              sig_cnt <= sig_cnt + 1;
            else
              -- Move to the next state
              sig_state <= WEST_STOP;
              -- Reset local counter value
              sig_cnt   <= (others => '0');
            end if;

          when others =>
            -- It is a good programming practice to use the
            -- OTHERS clause, even if all CASE choices have
            -- been made.
            sig_state <= WEST_STOP;
            sig_cnt   <= (others => '0');

        end case;

      end if; -- Synchronous reset
    end if; -- Rising edge
  end process p_traffic_fsm;

  --------------------------------------------------------
  --! A combinatorial process is sensitive to state
  --! changes and sets the output signals accordingly.
  --! This is an example of a Moore state machine and
  --! therefore the output is set based on the active
  --! state only.
  --------------------------------------------------------
  p_output_fsm : process (sig_state) is
  begin

    case sig_state is
      when WEST_STOP =>
        south <= c_RED;
        west  <= c_RED;

      when WEST_GO =>
        -- WRITE OTHER STATES HERE
        south <= c_RED;
        west  <= c_GREEN;

      when WEST_WAIT =>
        south <= c_RED;
        west  <= c_YELLOW;

      when SOUTH_STOP =>
        south <= c_RED;
        west  <= c_RED;

      when SOUTH_GO =>
        south <= c_GREEN;
        west  <= c_RED;

      when SOUTH_WAIT =>
        south <= c_YELLOW;
        west  <= c_RED;

      when others =>
        south <= c_RED;
        west  <= c_RED;
    end case;

  end process p_output_fsm;

end Behavioral;
