
### Learning objectives

* Use git and markdown README files
* Create and clone repositories through GitHub
* Commit, push, and pull changes to the repository

<a name="preparation"></a>

## Pre-Lab preparation

1. If you don't have any, create a free account on [GitHub](https://github.com/signup?source=login).

2. Optional: For future synchronization between your local folders and GitHub, download and install [git](https://git-scm.com/).

<a name="partXX"></a>

## Part XX: GitHub

**Git** is a free and open source distributed version control system, and available on Windows, Mac, and Linux platforms.



**GitHub** is a code hosting platform of git for collaboration and version control. GitHub lets you (and others) work together on projects.

1. In GitHub, create a new public repository titled **vhdl-course**. Initialize README, [`.gitignore`](https://raw.githubusercontent.com/iDoka/eda-scripts/master/gitignore/vivado.gitignore), and [MIT license](https://choosealicense.com/licenses/mit/).

2. Use one of the available git manuals, such as [[1]](https://medium.com/swlh/how-to-make-the-perfect-readme-md-on-github-92ed5771c061) or [[2]](https://help.github.com/en/articles/basic-writing-and-formatting-syntax) and add the following sections to your online README.md file.

* Headers H1, H2, H3
* Emphasis (*italics*, **bold**)
* Lists (ordered, unordered)
* Link
* Table
* Listing of VHDL source code (with syntax highlighting)

<a name="part2"></a>

## Part 2: Local repository

1. Use your favorite file manager and run Git Bash (Windows) or Terminal (Linux) inside your home folder `Documents`.

2. With help of `git` command, clone a local copy of your public repository.

   > **Important:** To avoid future problems, never use national characters (such as éščřèêö, ...) and spaces in folder- and file-names.
   >
   > **Help:** Useful git command is `git clone` - Create a local copy of remote repository. This command is executed just once; later synchronization between remote and local repositories is performed differently.
   >
   > Useful bash commands are `cd` - Change working directory. `mkdir` - Create directory. `ls` - List information about files in the current directory. `ls -a` - List information aout all files in the current directory. `pwd` - Print the name of the current working directory.

   ```bash
   ## Windows Git Bash or Linux:
   $ git clone https://github.com/your-github-account/vhdl-course
   $ cd vhdl-course/
   $ ls
   .gitignore  LICENSE  README.md
   ```

3. Set username and email for your repository (values will be associated with your later commits):

   ```shell
   $ git config user.name "your-git-user-name"
   $ git config user.email "your-email@address.com"
   ```

   You can verify that the changes were made correctly by:

   ```shell
   $ git config --list
   ```

4. Each computer exercise will be located in a separate folder, eg `01-gates` for the first exercise, `02-logic` for the second, `03-vivado` for the third, etc. Create a new working folder `labs/01-gates` for this exercise.

   ```bash
   ## Windows Git Bash or Linux:
   $ mkdir 01-gates
   ```

5. Use your favorite text editor, such as VS Code, Notepad++, etc. and create a new file `README.md` in your `01-gates/` folder. Copy/paste [report template](https://raw.githubusercontent.com/tomas-fryza/vhdl-course/master/labs/01-gates/report.md) to your `01-gates/README.md` file.

6. Synchronize the contents of your working folder with the local and remote repository. This way you are sure that you will not lose any of your changes. To do that, use git commands to add, commit, and push all local changes to your remote repository. Check GitHub web page for changes.

   > **Help:** Useful git commands are `git status` - Get state of working directory and staging area. `git add` - Add new and modified files to the staging area. `git commit` - Record changes to the local repository. `git push` - Push changes to remote repository. `git pull` - Update local repository and working folder. Note that, a brief description of useful git commands can be found [here](https://github.com/tomas-fryza/vhdl-course/wiki/Useful-Git-commands) and detailed description of all commands is [here](https://github.com/joshnh/Git-Commands).

   ```bash
   ## Windows Git Bash or Linux:
   $ git status
   $ git add -A
   $ git status
   $ git commit -m "Creating 01-gates lab"
   $ git status
   $ git push
   $ git status
   ```

   ![git](images/git_basics.png)


6. [MIT license](https://choosealicense.com/licenses/mit/)

7. Sayan Mondal. [How to make the perfect Readme.md on GitHub](https://medium.com/swlh/how-to-make-the-perfect-readme-md-on-github-92ed5771c061)

8. GitHub, Inc. [Basic writing and formatting syntax](https://help.github.com/en/articles/basic-writing-and-formatting-syntax)

9. GitHub, Inc. [Mastering Markdown](https://guides.github.com/features/mastering-markdown/)




<a name="partXX"></a>

## Part XX: VHDL code for traffic light controller

Let an intersection contains two one-way streets with a fixed time control system in which traffic lights are configured to turn on the green, yellow, and red color after a given period. If it is red in one direction on the traffic light, it is green in the other, and green in the first direction can only occur when it is red in the other direction, etc.

   > The exercise is inspired by the references [[3]](https://www.youtube.com/watch?v=6_Rotnw1hFM), [[1]](https://www.allaboutcircuits.com/technical-articles/implementing-a-finite-state-machine-in-vhdl/), [[4]](https://vhdlwhiz.com/n-process-state-machine/), while several changes have been made to preserve the programming style from the previous exercises, such as:
   >
   >* Use `numeric_std` package instead of `IEEE.STD_LOGIC_unsigned`,
   >* Types for internal signal/constants changed from `STD_LOGIC_VECTOR(3 downto 0)` to `unsigned`,
   >* Edge detector `clk'event and clk = '1'` changed to `rising_edge(clk)`.

1. Perform the following steps to model the traffic light controller in Vivado.

   1. Create a new Vivado RTL project `traffic` in your `08-traffic_lights` working folder.

   2. Create a VHDL source file `tlc` for the traffic light controller circuit.

   3. Choose default board: `Nexys A7-50T`.

   4. Open the [Traffic light controller](https://www.edaplayground.com/x/5HBi) example and copy/paste the `design.vhd` code to your `tlc.vhd` file.

   5. Copy source file of clock enable circuit from previous labs to `traffic/traffic.srcs/sources_1/new/` folder and add it to the project.

   6. Complete the traffic light code according to the following description.

      The controller contains six states and sets the semaphore outputs according to the following table. It remains in each of the states for a certain time.

      | **Current state** | **Direction South** | **Direction West** | **Delay** |
      | :-- | :-: | :-: | :-: |
      | `WEST_STOP`  | red    | red    | 2 sec |
      | `WEST_GO`    | red    | green  | 4 sec |
      | `WEST_WAIT`  | red    | yellow | 1 sec |
      | `SOUTH_STOP` | red    | red    | 2 sec |
      | `SOUTH_GO`   | green  | red    | 4 sec |
      | `SOUTH_WAIT` | yellow | red    | 1 sec |

2. Draw Moore-based state diagram according to the table. Note that, Moore's output(s) depends only on the present state.

3. In VHDL it is possible to define a new data type, which contains the names of our states.

   ```vhdl
   architecture Behavioral of tlc is

     -- Define the FSM states
     type t_state is (
       WEST_STOP,
       WEST_GO,
       WEST_WAIT,
       SOUTH_STOP,
       SOUTH_GO,
       SOUTH_WAIT
     );

     -- Define the signal that uses different states
     signal sig_state : t_state;
   ...
   ```

   The FSM function is divided into two processes, where the first is sequential and it entirely controls state changes by CASE statement. The second is a combinatorial process, it is sensitive to state changes, and sets the output signals accordingly. This is an example of a Moore state machine because the output is set based on the active state. FSM behavior can be written in one to three processes. The differences between these approaches are described in [detail here](https://vhdlwhiz.com/n-process-state-machine/).

4. Complete CASE/WHEN statements in both sequential and combinatorial processes.

   **Sequential process:**

    ```vhdl
    --------------------------------------------------------
    -- p_traffic_fsm:
    -- A sequential process with synchronous reset and
    -- clock_en entirely controls the sig_state signal
    -- by CASE statement.
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
    ```

   **Combinatorial process:**

    ```vhdl
    --------------------------------------------------------
    -- p_output_fsm:
    -- A combinatorial process is sensitive to state
    -- changes and sets the output signals accordingly.
    -- This is an example of a Moore state machine and
    -- therefore the output is set based on the active
    -- state only.
    --------------------------------------------------------
    p_output_fsm : process (sig_state) is
    begin

      case sig_state is
        when WEST_STOP =>
          south <= c_RED;
          west  <= c_RED;

        when WEST_GO =>
          -- WRITE OTHER STATES HERE


        when others =>
          south <= c_RED;
          west  <= c_RED;
        end case;

      end process p_output_fsm;

    end Behavioral;
    ```

<a name="part4"></a>

## Part 4: Traffic light controller simulation

1. Perform the following steps to simulate traffic light controller.

   1. Create a VHDL [simulation source](https://www.edaplayground.com/x/5HBi) `tb_tlc`. Note that the maximum value of clock enable circuit is set to 1 for the simulation, ie the traffic light controller changes its state with a frequency of 100&nbsp;MHz and not 4&nbsp;Hz.
   2. Change the duration of simulation to `2000ns` in Vivado menu **Tools > Settings... > Simulation > Simulation**.
   3. Run the simulation, and verify that the controller works correctly (reset, timing, output lights, states).

      > To display internal signal values perform the followings:
      >
      > 1. Select `uut_tlc` in **Scope** folder.
      > 2. Right click to `sig_state` signal name in **Objects** folder.
      > 3. Add this signal by selecting **Add to Wave Window** command.
      > 4. Click to **Relaunch Simulation** icon.
      >
      >    ![Internal signals simulation](images/vivado_signals.png)

<a name="part5"></a>

## Part 5: Top level VHDL code

1. Perform the following steps to implement the traffic light controller on the Nexys A7 board.

   1. Create a new design source `top` in your project.

   2. Use **Define Module** dialog and define I/O ports of entity `top` as follows.

      | **Port name** | **Direction** | **Type** | **Description** |
      | :-: | :-: | :-- | :-- |
      | `CLK100MHZ` | in | `std_logic` | Main clock |
      | `LED16_R` | out | `std_logic` | South: Red |
      | `LED16_G` | out | `std_logic` | South: Green |
      | `LED16_B` | out | `std_logic` | South: Blue |
      | `LED17_R` | out | `std_logic` | West: Red |
      | `LED17_G` | out | `std_logic` | West: Green |
      | `LED17_B` | out | `std_logic` | West: Blue |
      | `BTNC` | in | `std_logic` | Synchronous reset |

   3. Use direct instantiation and define an architecture of the top level.

      ```vhdl
      ----------------------------------------------------------
      -- Architecture body for top level
      ----------------------------------------------------------

      architecture Behavioral of top is

      begin
        --------------------------------------------------------
        -- Instance (copy) of tlc entity
        --------------------------------------------------------
        tlc : entity work.tlc
          port map (
            clk      => CLK100MHZ,
            south(2) => LED16_R,
            -- MAP OTHER RGB LEDS (SOUTH and WEST) HERE


            west(0)  => LED17_B,
            rst      => BTNC
          );

      end Behavioral;
      ```

   4. Create a new [constraints XDC](https://raw.githubusercontent.com/Digilent/digilent-xdc/master/Nexys-A7-50T-Master.xdc) file: `nexys-a7-50t` and uncomment used pins according to top entity.

   5. Compile the project and download the generated bitstream `traffic/traffic.runs/impl_1/top.bit` into the FPGA chip.

   6. Observe the functionality of the traffic light controller.

      ![Nexys A7 board](images/nexys_a7_traffic.jpg)

   7. Use **IMPLEMENTATION > Open Implemented Design > Schematic** to see the generated structure.




<a name="challenges"></a>

## Challenges

3. Follow the [exercise inspired by prof. Jon Valvano](https://arduining.com/2015/09/18/traffic-light-states-machine-with-arduino/) from University of Texas and desing an enhanced traffic light controller for the intersection of two equally busy one-way streets. The controller using two sensors and two traffic lights in three colors. Two sensors detects the presence of cars in each direction and the goal is to maximize traffic flow, minimize waiting time at a red light, and avoid accidents.

   ![Enhanced traffic light controller for the intersection](images/lab8_traffic_light_intersection.png)




3. LBEbooks, Lesson 92 - Example 62: [Traffic Light Controller](https://www.youtube.com/watch?v=6_Rotnw1hFM)

5. Jon Valvano. [Traffic Light, Finite State Machine with Arduino](https://arduining.com/2015/09/18/traffic-light-states-machine-with-arduino/)
