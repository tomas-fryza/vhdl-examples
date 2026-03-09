# Lab 5: Latches and Flip-flops

### Learning objectives

After completing this lab you will be able to:

* Use latches and flip-flops
* Use VHDL synchronous processes
* Understand the asynchronous and synchronous resets

In this laboratory exercise, you will study the differences between a statically controlled latch and flip-flops that are synchronized with a clock signal. In VHDL, combinational and synchronous processes will be used and the difference between asynchronous and synchronous reset will be illustrated.

### Table of contents

* [Pre-Lab preparation](#preparation)
* [Part 1: Synchronize Git and create a new folder](#part1)
* [Part 2: D latch](#part2)
* [Part 3: VHDL code for flip-flops](#part3)
* [Experiments on your own](#experiments)
* [Post-Lab report](#report)
* [References](#references)

<a name="preparation"></a>

## Pre-Lab preparation

1. Write characteristic equations and complete truth tables for D, JK, T flip-flops where `q(n)` represents main output value before the clock edge and `q(n+1)` represents output value after the clock edge.

   ![Characteristic equations](images/eq_flip_flops.png)
<!--
https://editor.codecogs.com/
\begin{align*}
    q_{n+1}^D =&~D \\
    q_{n+1}^{JK} =& \\
    q_{n+1}^T =& \\
\end{align*}
-->

   **D-type FF**
   | **clk** | **d** | **q(n)** | **q(n+1)** | **Comments** |
   | :-: | :-: | :-: | :-: | :-- |
   | ![rising](images/eq_uparrow.png) | 0 | 0 | 0 | `q(n+1)` has the same level as `d` |
   | ![rising](images/eq_uparrow.png) | 0 | 1 |  |  |
   | ![rising](images/eq_uparrow.png) | 1 |  |  |  |
   | ![rising](images/eq_uparrow.png) | 1 |  |  |  |

   **JK-type FF**
   | **clk** | **j** | **k** | **q(n)** | **q(n+1)** | **Comments** |
   | :-: | :-: | :-: | :-: | :-: | :-- |
   | ![rising](images/eq_uparrow.png) | 0 | 0 | 0 | 0 | Output did not change |
   | ![rising](images/eq_uparrow.png) | 0 | 0 | 1 | 1 | Output did not change |
   | ![rising](images/eq_uparrow.png) | 0 |  |  |  |  |
   | ![rising](images/eq_uparrow.png) | 0 |  |  |  |  |
   | ![rising](images/eq_uparrow.png) | 1 |  |  |  |  |
   | ![rising](images/eq_uparrow.png) | 1 |  |  |  |  |
   | ![rising](images/eq_uparrow.png) | 1 |  |  |  |  |
   | ![rising](images/eq_uparrow.png) | 1 |  |  |  |  |

   **T-type FF**
   | **clk** | **t** | **q(n)** | **q(n+1)** | **Comments** |
   | :-: | :-: | :-: | :-: | :-- |
   | ![rising](images/eq_uparrow.png) | 0 | 0 | 0 | Output did not change |
   | ![rising](images/eq_uparrow.png) | 0 | 1 |  |  |
   | ![rising](images/eq_uparrow.png) | 1 |  |  |  |
   | ![rising](images/eq_uparrow.png) | 1 |  |  |  |

<a name="part1"></a>

## Part 1: Synchronize repositories and create a new folder

1. Run Git Bash (Windows) of Terminal (Linux), navigate to your working directory, and update local repository.

   > **Help:** Useful bash and git commands are `cd` - Change working directory. `mkdir` - Create directory. `ls` - List information about files in the current directory. `pwd` - Print the name of the current working directory. `git status` - Get state of working directory and staging area. `git pull` - Update local repository and working folder.

   ```bash
   ## Windows Git Bash or Linux:
   $ git pull
   ```

2. Create a new working folder `05-ffs` for this exercise.

3. Use your favorite text editor, such as VS Code, Notepad++, etc. and create a new file `README.md` in your `05-ffs/` folder. Copy/paste [report template](https://raw.githubusercontent.com/tomas-fryza/digital-electronics-1/master/labs/05-ffs/report.md) to your `05-ffs/README.md` file.

<a name="part2"></a>

## Part 2: D latch

There are two types of memory elements based on the type of triggering that is suitable to operate it:

* Latches
* Flip-flops

Both are used as data storage elements. Latches operate with enable signal, which is level sensitive. Whereas, flip-flops are edge sensitive and operate with clock signal transitions.

A latch has two stable states (high and low) and it works like a storage device by holding the data through a feedback lane. It stores 1-bit of data. The latches can be classified into different types which include mainly S-R latch, Gated S-R latch, D latch but also JK latch, and T latch.

A D-type latch has two outputs Q and /Q and two inputs: data input D and enable. It consistes of Gated S-R latch but because the inputs are complements of each other, it eliminates the combinations of S & R are of same value.

![D-type Latch](images/d-latch_schema.png)

As the output is same as the input D, D latch is also called as **Transparent latch**.

![D-type Latch timing](images/d-latch_timing.png)
<!--
https://wavedrom.com/
{signal: [
  ["Inputs",
    {name: "en", wave: "l..h...l.", },
    {name: "d",  wave: "lp.lphnhl", },
  ],
  {},
  ["Outputs",
    {name: "q",  wave: "l...phnh.", },
    {name: "/q", wave: "h...nlpl.", },
  ],
],
  foot: {
    text: "     hold              enable (transparent)        hold    ",
  },
}
-->

A D-type latch can be modeled in VHDL as follows.

   ```vhdl
   library ieee;
     use ieee.std_logic_1164.all;
   -------------------------------------
   entity d_latch is
       port (
           en    : in    std_logic;
           d     : in    std_logic;
           q     : out   std_logic;
           q_bar : out   std_logic
       );
   end entity d_latch;
   -------------------------------------
   architecture Behavioral of d_latch is
   begin
       p_d_latch : process (en, d) is
       begin
           if (en = '1') then
               q     <= d;
               q_bar <= not d;
           end if;
       end process p_d_latch;
   end Behavioral;
   ```

<a name="part3"></a>

## Part 3: VHDL code for flip-flops

The basic difference between a latch and a flip-flop is a gating or clocking mechanism: flip-flop is edge-triggered and a latch is level triggered.

1. Perform the following steps to model D-type flip-flop entity in Vivado.

   1. Create a new Vivado RTL project `flip_flops` in your `05-ffs` working folder.
   2. Create a VHDL source file `d_ff_rst` for D-type flip-flop circuit with synchronous reset.
   3. Choose default board: `Nexys A7-50T`.
   4. Define entity with `clk`, `rst`, `d`, `q`, `q_bar` ports.

      | **Port name** | **Direction** | **Type** | **Description** |
      | :-: | :-: | :-- | :-- |
      | `clk`   | input  | `std_logic` | Main clock |
      | `rst`   | input  | `std_logic` | High-active synchronous reset |
      | `d`     | input  | `std_logic` | Data input |
      | `q`     | output | `std_logic` | Main output |
      | `q_bar` | output | `std_logic` | Complementary output |

   5. Use the following architecture example and complete the synchronous reset [assignment](https://github.com/tomas-fryza/digital-electronics-1/wiki/Signal-assignments).

      ```vhdl
      architecture Behavioral of d_ff_rst is
      begin
          --------------------------------------------------------
          -- p_d_ff_rst:
          -- D type flip-flop with a high-active sync reset and
          -- rising-edge clk.
          -- q(n+1) = d
          --------------------------------------------------------
          p_d_ff_rst : process (clk) is
          begin
              if rising_edge(clk) then  -- Synchronous process

                  -- USE HIGH-ACTIVE RESET HERE

                      q     <= d;
                      q_bar <= not d;
              end if;
          end process p_d_ff_rst;
      end Behavioral;
      ```

   6. Create a VHDL simulation source `tb_ff_rst`, use the following testbench example, and simulate the circuit. Verify the synchronous reset.

      ```vhdl
      library ieee;
        use ieee.std_logic_1164.all;

      ------------------------------------------------------------
      -- Entity declaration for testbench
      ------------------------------------------------------------
      entity tb_ff_rst is
        -- Entity of testbench is always empty
      end entity tb_ff_rst;

      ------------------------------------------------------------
      -- Architecture body for testbench
      ------------------------------------------------------------
      architecture testbench of tb_ff_rst is

          constant c_CLK_100MHZ_PERIOD : time := 10 ns;

          --Local signals
          signal sig_clk_100MHz : std_logic;
          signal sig_rst        : std_logic;
          signal sig_data       : std_logic;
          signal sig_dq         : std_logic;
          signal sig_dq_bar     : std_logic;

      begin
          -- Connecting testbench signals with d_ff_rst entity
          -- (Unit Under Test)
          uut_d_ff_rst : entity work.d_ff_rst
              port map (
                  clk   => sig_clk_100MHz,
                  rst   => sig_rst,
                  d     => sig_data,
                  q     => sig_dq,
                  q_bar => sig_dq_bar
              );

          --------------------------------------------------------
          -- Clock generation process
          --------------------------------------------------------
          p_clk_gen : process is
          begin
              while now < 300 ns loop -- 30 periods of 100MHz clock
                  sig_clk_100MHz <= '0';
                  wait for c_CLK_100MHZ_PERIOD / 2;
                  sig_clk_100MHz <= '1';
                  wait for c_CLK_100MHZ_PERIOD / 2;
              end loop;
              wait;                -- Process is suspended forever
          end process p_clk_gen;

          --------------------------------------------------------
          -- Reset generation process
          --------------------------------------------------------
          p_reset_gen : process is
          begin
              sig_rst <= '0';

              -- ACTIVATE AND DEACTIVATE RESET HERE
              -- wait for XXX ns;
              -- sig_rst <= XXX;
              -- wait for XXX ns;
              -- sig_rst <= XXX;

              wait;
          end process p_reset_gen;

          --------------------------------------------------------
          -- Data generation process
          --------------------------------------------------------
          p_stimulus : process is
          begin
              report "Stimulus process started";
              sig_data <='0'; wait for 13 ns;

              -- DEFINE YOUR INPUT DATA HERE

              report "Stimulus process finished";
              wait;
          end process p_stimulus;

      end architecture testbench;
      ```

2. Create other design source VHDL file `t_ff_rst` and define T flip-flop with synchronization reset.

   | **Entity** | **Inputs** | **Outputs** | **Description** |
   | :-- | :-- | :-- | :-- |
   | `t_ff_rst` | `clk`, `rst`, `t` | `q`, `q_bar` | T type flip-flop with a sync reset |

   ```vhdl
   architecture Behavioral of t_ff_rst is
       -- It must use this local signal instead of output ports
       -- because "out" ports cannot be read within the architecture
       signal sig_q : std_logic;
   begin
       --------------------------------------------------------
       -- p_t_ff_rst:
       -- T type flip-flop with a high-active synchro reset and
       -- rising-edge clk.
       -- sig_q = t./sig_q + /t.sig_q
       -- sig_q =  sig_q if t = 0 (no change)
       -- sig_q = /sig_q if t = 1 (inversion)
       --------------------------------------------------------
       p_t_ff_rst : process (clk) is
       begin
           if rising_edge(clk) then

           -- WRITE YOUR CODE HERE

           end if;
       end process p_t_ff_rst;

       -- Output ports are permanently connected to local signal
       q     <= sig_q;
       q_bar <= not sig_q;
   end Behavioral;
   ```

3. Try to simulate both flip-flops together in existing testbench file `tb_ff_rst.vhd` with a maximum duration of 200 ns. Verify the synchronous reset as well.

4. Use **Flow** > **Open Elaborated design** and see the schematic after RTL analysis. Note that RTL (Register Transfer Level) represents digital circuit at the abstract level.

5. When you finish, always synchronize the contents of your working folder with the local and remote versions of your repository. This way you are sure that you will not lose any of your changes. To do that, use git commands to add, commit, and push all local changes to your remote repository. Check GitHub web page for changes.

   > **Help:** Useful git commands are `git status` - Get state of working directory and staging area. `git add` - Add new and modified files to the staging area. `git commit` - Record changes to the local repository. `git push` - Push changes to remote repository. `git pull` - Update local repository and working folder. Note that, a brief description of useful git commands can be found [here](https://github.com/tomas-fryza/digital-electronics-1/wiki/Useful-Git-commands) and detailed description of all commands is [here](https://github.com/joshnh/Git-Commands).

<a name="experiments"></a>

## Experiments on your own

Use D type flip-flops with synchronous reset and perform the following steps to simulate a 4-bit shift register.

   1. Create a new design source `top` in your project.
   2. Use **Define Module** dialog and set ports of `top` entity as follows.

      | **Port name** | **Direction** | **Type** | **Description** |
      | :-: | :-: | :-- | :-- |
      | `CLK100MHZ` | input  | `std_logic` | Main clock |
      | `BTNC` | input  | `std_logic` | Synchronous reset |
      | `SW`   | input  | `std_logic_vector(0 downto 0)` | Shift register serial input |
      | `LED`  | output | `std_logic_vector(3 downto 0)` | Shift register parallel outputs |

   3. Use direct instantiation and define an architecture of the top level.

      ```vhdl
      ------------------------------------------------------------------------
      -- Architecture body for top level
      ------------------------------------------------------------------------
      architecture Behavioral of top is

        -- Internal signals between flip-flops
        signal sig_ff0 : std_logic;

        -- WRITE YOUR CODE HERE

      begin

        --------------------------------------------------------------------
        -- Four instances (copies) of D-type FF entity
        d_ff_0 : entity work.d_ff_rst
            port map (
                clk => CLK100MHZ,
                rst => BTNC,
                -- WRITE YOUR CODE HERE
                
                q   => sig_ff0
            );

        d_ff_1 : entity work.d_ff_rst
            port map (
                clk => CLK100MHZ,
                rst => BTNC,
                -- WRITE YOUR CODE HERE

            );

        -- PUT OTHER TWO FLIP-FLOP INSTANCES HERE

      end Behavioral;
      ```

   4. Create a testbench file `tb_top` and simulate it.

<a name="report"></a>

## Post-Lab report

*Complete all parts of `05-ffs/README.md` file (see Part 1.3) in Czech, Slovak, or English, push it to your GitHub repository, and submit a link to this file via [BUT e-learning](https://moodle.vutbr.cz/). The deadline for submitting the task is the day before the next lab, i.e. in one week.*

*Vypracujte všechny části ze souboru `05-ffs/README.md` (viz Část 1.3) v českém, slovenském, nebo anglickém jazyce, uložte je na váš GitHub repozitář a odevzdejte link na tento soubor prostřednictvím [e-learningu VUT](https://moodle.vutbr.cz/). Termín odevzdání úkolu je den před dalším počítačovým cvičením, tj. za jeden týden.*

<a name="references"></a>

## References

1. GeeksforGeeks. [Latches in Digital Logic](https://www.geeksforgeeks.org/latches-in-digital-logic/)

2. Tutorials Point. [Digital Circuits - Latches](https://www.tutorialspoint.com/digital_circuits/digital_circuits_latches.htm)

3. Elprocus. [Basics of Latches in Digital Electronics](https://www.elprocus.com/basics-of-latches-in-digital-electronics/)

4. Eric Coates. [D Type Flip-flops](https://learnabout-electronics.org/Digital/dig53.php)

5. Digilent. [General .xdc file for the Nexys A7-50T](https://github.com/Digilent/digilent-xdc/blob/master/Nexys-A7-50T-Master.xdc)
