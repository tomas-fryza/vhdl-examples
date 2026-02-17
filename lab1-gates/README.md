# Laboratory 1: Basic logic gates

<!--
![Logo](../../logolink_eng.jpg)
<p align="center">
  The Study of Modern and Developing Engineering BUT<br>
  CZ.02.2.69/0.0/0.0/18_056/0013325
</p>

![Screenshot od EDA Playground](images/screenshot_eda.png)
-->

* [Task 1: Introduction to VHDL](#task1)
* [Task 2: De Morgan's laws](#task2)
* [Optional tasks](#tasks)
* [Questions](#questions)
* [References](#references)

### Objectives

After completing this laboratory, students will be able to:

* Describe the main parts of a VHDL file
* Use Vivado development tool
* Implement basic combinational logic using VHDL operators
* Create a simple VHDL testbench
* Simulate a design and analyze waveforms
* Use De Morgan's and Distributive laws

### Background

Digital systems are built from **logic gates**, which implement Boolean functions. In this laboratory, three fundamental gates are implemented:

   * **AND**: Output is `1` only when both inputs are `1`.
   * **OR**: Output is `1` when at least one input is `1`.
   * **XOR**: Output is `1` when inputs are different.

      ![basic-logic-gates](images/gates.png)

De Morgan's laws are two fundamental rules in Boolean algebra that are used to simplify Boolean expressions:

   * De Morgan's law for AND: The complement of the product of two operands is equal to the sum of the complements of the operands.
   * De Morgan's law for OR: The complement of the sum of two operands is equal to the product of the complements of the operands.

      ![demorgan](images/demorgan.png)

   <!-- https://latexeditor.lagrida.com/ font size 16
   \begin{align*}
      \overline{a\cdot b} =&~ \overline{a} + \overline{b}\\
      \overline{a+b} =&~ \overline{a}\cdot \overline{b}\\
   \end{align*}
   -->

**Hardware Description Languages** (HDLs) are used to model, design, and simulate digital hardware systems by describing their structure and behavior. VHDL and Verilog are the two most widely used HDLs, both allowing engineers to create designs for digital circuits such as processors, controllers, and FPGA implementations. **VHDL** is strongly typed and more verbose, making it popular in academic, aerospace, and safety-critical applications, while **Verilog** has a C-like syntax and is often considered easier to learn and more concise. Both languages support parallel hardware behavior and timing, which distinguishes them from traditional software programming languages. Designs written in VHDL or Verilog can be simulated for verification and synthesized into real hardware.

[VHDL (VHSIC Hardware Description Language)](https://ieeexplore.ieee.org/document/8938196) is a programming language used to describe the behavior and structure of digital circuits. The acronym VHSIC (Very High Speed Integrated Circuits) in the language's name comes from the U.S. government program that funded early work on the standard. VHDL is a formal notation intended for use in all phases of the creation of electronic systems. Since it is both machine and human readable, it supports the design, development, verification, synthesis, and testing of hardware designs; the communication of hardware design data; and the maintenance, modification, and procurement of hardware.

 > **Note:** IEEE standards for VHDL language:
 > * IEEE Std 1076-1987
 > * IEEE Std 1076-1993
 > * IEEE Std 1076-2002
 > * IEEE Std 1076-2008
 > * IEEE Std 1076-2019

[Vivado Design Suite](https://www.amd.com/en/products/software/adaptive-socs-and-fpgas/vivado.html) is a comprehensive design environment developed by AMD (formerly Xilinx) for the design, analysis, and implementation of programmable logic devices, such as FPGAs (Field-Programmable Gate Arrays) and SoCs (System on Chips). It provides a set of tools and features for digital design, synthesis, simulation, and implementation of electronic systems.

<a name="task1"></a>

## Task 1: Introduction to VHDL

Design a circuir that implements the following logic functions:

   - one 2-input **AND** gate,
   - one 2-input **OR** gate,
   - one 2-input **XOR** gate.

The module shall have two single-bit inputs `a`, `b` and three single-bit outputs `y_and`, `y_or`, `y_xor`.

   - Use **combinational logic only**
   - Use **concurrent signal assignments** (`<=`)
   - Do not use clocks or sequential logic
   - The design must be synthesizable
   - All input combinations must be verified by simulation

      ![schema of gates](images/schematic_gates.png)

1. Run Vivado and create a new project:

   > **Note:** When running for the first time, it is recommended to specify the project directory and target language in the **Tools > Settings...** menu.
   >
   > ![settings](images/vivado_vhdl.png)

   1. Project name: `gates`
   2. Project location: your working folder, such as `Documents`
   3. Project type: **RTL Project** (Note, the Register-Transfer Level refers to a level of abstraction used to describe how the data is transferred and processed inside hardware.)
   4. Create a new VHDL source file: `gates`
   5. Do not add any constraints now
   6. Choose a default board: `Nexys A7-50T` (will be used later in the lab)
   7. Click **Finish** to create the project
   8. Define I/O ports of new module `gates`:
      * Port name: `a`, Direction: `in`
      * `b`, `in`
      * `y_and`, `out`
      * `y_or`, `out`
      * `y_xor`, `out`

2. Open the generated file `gates.vhd` located in **Design Sources** and take a look at the basic parts of the VHDL source code, such as [entity](https://github.com/tomas-fryza/vhdl-examples/wiki/Entity), [architecture](https://github.com/tomas-fryza/vhdl-examples/wiki/Architecture), and the useful VHDL operators.

   | **Operator** | **Description** |
   | :-: | :-- |
   | `<=` | Value assignment |
   | `and` | Logical AND |
   | `nand` | Logical AND with negated output |
   | `or` | Logical OR |
   | `nor` | Logical OR with negated output |
   | `not` | Negation |
   | `xor` | Exclusive OR |
   | `xnor` | Exclusive OR with negated output |
   | `-- comment` | Comments |

   **Help:** The `std_logic` data type provides several values.

   ```vhdl
   type std_logic is (
       'U',  -- Uninitialized state used as a default value
       'X',  -- Forcing unknown
       '0',  -- Forcing zero. Transistor driven to GND
       '1',  -- Forcing one. Transistor driven to VCC
       'Z',  -- High impedance. 3-state buffer outputs
       'W',  -- Weak unknown. Bus terminators
       'L',  -- Weak zero. Pull down resistors
       'H',  -- Weak one. Pull up resistors
       '-'   -- Don't care state used for synthesis and advanced modeling
   );
   ```

3. Complete the `architecture` sections so that it implements output functions using **concurrent signal assignments** (`<=`). Note: **Concurrent** means that all assignments exist and operate at the same time, just like real hardware. There is **no execution order** between them.

   ```vhdl
   library ieee;
       use ieee.std_logic_1164.all;
   -----------------------------------------------
   entity gates is
       port (
           a     : in    std_logic;
           b     : in    std_logic;
           y_and : out   std_logic;
           y_or  : out   std_logic;
           y_xor : out   std_logic
       );
   end entity gates;
   -----------------------------------------------
   architecture Behavioral of gates is
       -- Declaration part, can be empty
   begin
       -- Body part
       y_and <= a and b;
       y_or  <= a or b;
       y_xor <= a xor b;
   end Behavioral;
   ```

4. Create a truth table for all input combinations.

5. The primary approach to testing VHDL designs involves creating a **testbench**. A testbench is essentially a separate VHDL file that stimulates the design under test (DUT) with various input values and monitors its outputs to verify correct functionality. The testbench typically includes DUT component instantiation and stimulus generation.

   ![testench idea](images/testbench.png)

   Navigate to **File > Add Sources... Alt+A > Add or create simulation sources** and proceed to create a new VHDL file named `gates_tb` (ensuring it has the same filename as the tested entity but sufixed with `_tb`). This time, click **OK** to define an empty module. Subsequently, locate the newly created simulation file under **Simulation Sources > sim_1**.

   Generate the testbench file using the [online generator](https://vhdl.lapinoo.net/testbench/), then copy and paste its contents into your `gates_tb.vhd` file. Afterwards, fill in the test cases within the `stimuli` process for all input combinations.

   ```vhdl
   library ieee;
   use ieee.std_logic_1164.all;
   -----------------------------------------------
   entity tb_gates is
   end tb_gates;
   -----------------------------------------------
   architecture tb of tb_gates is

       component gates
           port (a     : in  std_logic;
                 b     : in  std_logic;
                 y_and : out std_logic;
                 y_or  : out std_logic;
                 y_xor : out std_logic);
       end component;

       signal a     : std_logic;
       signal b     : std_logic;
       signal y_and : std_logic;
       signal y_or  : std_logic;
       signal y_xor : std_logic;

   begin

       dut : gates
       port map (a     => a,
                 b     => b,
                 y_and => y_and,
                 y_or  => y_or,
                 y_xor => y_xor);

       stimuli : process
       begin
           -- ***EDIT*** Adapt initialization as needed
           b <= '0';
           a <= '0';
           wait for 100 ns;


           -- TODO: Apply all input combinations


           wait;
       end process;

   end tb;
   ```

6. Use **Flow > Run Simulation > Run Behavioral Simulation** and run Vivado simulator. To see the whole simulated signals, it is recommended to select **View > Zoom Fit**.

   ![Vivado-simulation](images/vivado_simulation_zoom.png)

   Verify that the behavior corresponds exactly to the truth table above.

7. Use **Flow > Open Elaborated design** and see the schematic after RTL analysis. Note that RTL (Register Transfer Level) represents digital circuit at the abstract level.

   <!--![Vivado-rtl](images/vivado_rtl.png)-->

   <!--![Vivado-commands](images/vivado_basic-commands_labels.png)-->

8. To cleanup generated files, close simulation window, right click to SIMULATION or Run Simulation option, and select **Reset Behavioral Simulation** or type some the following command(s) to the Tcl console:

   ```tcl
   # Close the current simulation session
   close_sim

   # Reset the current project to its starting condition, clean out generated files
   reset_project
   ```

   <!-- ![Reset simulation](images/screenshot_vivado_reset_simul.png)-->

<a name="task2"></a>

## Task 2: De Morgan's laws

1. Propose a 3-input logic function, use De Morgan's laws, and implement the function using only NAND or NOR operators.

2. Create a new Vivado project `deMorgan` and source file `demorgan.vhd` with the following I/O ports:

   * Port name: `a`, Direction: `in`
   * `b`, `in`
   * `c`, `in`
   * `f_org`, `out`
   * `f_nand`, `out`
   * `f_nor`, `out`

   Complete the `architecture`, add a new simulation source file `demorgan_tb.vhd`, and verify that `f_org`, `f_nand`, and `f_nor` are identical for all 8 input combinations.

3. Use **Flow > Open Elaborated design** and see the schematic after RTL analysis.

<a name="tasks"></a>

## Optional tasks

1. Implement XOR using only AND, OR, NOT.

<!--
2. Choose one of the distributive laws and verify, using VHDL, that both sides of the equation represent the same logic function.

   ![Distributive laws](images/distributive.png)

   <!-- https://latexeditor.lagrida.com/ font size 16
   \begin{align*}
      (a\cdot b) + (a\cdot c) =& ~ a\cdot (b+c)\\
      (a+b)\cdot (a+c) =& ~ a+ (b\cdot c)\\
   \end{align*}
   ->
-->

2. If you want to use online [EDA Playground](https://www.edaplayground.com) tool, you will need Google account, Facebook account, or register your account on EDA Playground.

3. In addition to the professional Vivado tool, which requires significant local disk storage, other simulation tools are available, including TerosHDL and ghdl.

   [TerosHDL](https://terostechnology.github.io/terosHDLdoc/) is an open-source tool designed to streamline FPGA development by providing a unified workflow for simulation and synthesis using VHDL. [GHDL](https://github.com/ghdl/ghdl) is a free and open-source VHDL simulator that is a popular choice for hobbyists and students. It is a good option for learning VHDL and for simulating small-scale designs.

   * Try to [install ghdl](https://github.com/tomas-fryza/vhdl-examples/wiki/How-to-install-ghdl-on-Windows-and-Linux) on Windows, Linux, or macOS.

   * Try to [install TerosHDL](https://github.com/tomas-fryza/vhdl-examples/wiki/How-to-install-TerosHDL-on-Windows-and-Linux) on Windows, Linux, or macOS.

<a name="questions"></a>

## Questions

1. What are the two main parts of a VHDL file? What is the purpose of each?

2. Using Boolean algebra, express XOR using only AND, OR, and NOT operators.

3. What happens if you remove the final `wait;` statement in the testbench?

4. What does the `'U'` value in `std_logic` represent?

<a name="references"></a>

## References

1. Real Digital. [Creating Your First Project in Vivado](https://www.realdigital.org/doc/4ddc6ee53d1a2d71b25eaccc29cdec4b)

2. Tomas Fryza. [Example of basic OR, AND, XOR gates](https://www.edaplayground.com/x/5L92)

3. CodeCogs. [Online LaTeX Equation Editor](https://www.codecogs.com/latex/eqneditor.php)

4. CircuitVerse. [Online Digital Logic Circuit Simulator](https://circuitverse.org/)

5. [Online VHDL Testbench Template Generator](https://vhdl.lapinoo.net/testbench/)

6. Xilinx University Program. [Vivado FPGA Design Flow on Zynq](https://github.com/xupgit/FPGA-Design-Flow-using-Vivado)
