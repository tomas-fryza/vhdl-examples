# Laboratory 6: Button debounce

* [Task 1: Debounce button](#task1)
* [Task 2: Top-level design and FPGA implementation](#task2)
* [Optional tasks](#tasks)
* [Questions](#questions)
* [References](#references)

### Objectives

After completing this laboratory, students will be able to:

* Understand mechanical switch bounce
* Implement a digital debouncer in VHDL
* Design and use a two flip-flop synchronizer for asynchronous inputs
* Use edge detectors
* Integrate multiple components into a top-level VHDL design
* Apply debouncing and edge detection in a real FPGA application

### Background

The Nexys A7 FPGA board provides five **push buttons**. Refer to the [schematic](https://github.com/tomas-fryza/vhdl-examples/blob/master/docs/nexys-a7-sch.pdf) or the board [reference manual](https://reference.digilentinc.com/reference/programmable-logic/nexys-a7/reference-manual) to determine how the push-buttons are conected and what is their active level.

   ![nexys A7 led and segment](images/nexys-a7_leds-display.png)

A **bouncy button**, also known as a **switch bounce**, refers to the phenomenon where the electrical contacts in a mechanical switch make multiple rapid transitions between open and closed states when pressed or released. These transitions typically occur over a period of **1–25 ms**.

As a result, a single press may be interpreted by digital logic as **multiple presses**, which can cause incorrect behavior in digital circuits. Examples of real push buttons are shown below. (Note that the active level of the buttons in these examples is low, while the buttons on the Nexys A7 board may use a different active level.)

   ![bouncey button](images/bouncey4.png)

   ![bouncey button](images/bouncey6.png)

The main methods to eliminate switch bounce are:

   1. **[Hardware debouncing](https://www.digikey.ee/en/articles/how-to-implement-hardware-debounce-for-switches-and-relays)** uses additional analog or digital circuitry to filter the bouncing signal before it reaches the digital logic. Typical components include: resistors, capacitors, Schmitt triggers.

      ![hardware debouncer](images/debouncer_hardware.png)

   2. In FPGA designs, debouncing is typically implemented using **synchronous digital logic** described in HDL. Common techniques include: shift-register filters, counters, finite state machines, timer-based filters.

   3. **Combination approach**. In many practical systems, a combination of **hardware filtering** and **digital debouncing logic** is used to achieve robust signal conditioning.

<a name="task1"></a>

## Task 1: Debounce button

1. Run Vivado, create a new RTL project named `debounce`, and create a VHDL design source file named `debounce`. Use the following I/O ports:

      | **Port name** | **Direction** | **Type** | **Description** |
      | :-: | :-: | :-- | :-- |
      | `clk` | in  | `std_logic` | Main clock |
      | `rst` | in  | `std_logic` | High-active synchronous reset |
      | `btn_in` | in  | `std_logic` | Raw push-button input (may contain bounce) |
      | `btn_state` | out | `std_logic` | Debounced button level |
      | `btn_press` | out | `std_logic` | One-clock pulse generated when the button is pressed |

2. In your project, add the design source file `clk_en.vhd` from the previous lab(s). When adding the file in Vivado, enable the **Copy sources into project** option so that the file is copied into the current project directory.

   ![vivado_copy-sources](images/vivado_copy-sources.png)

3. Instantiate the `clk_en` module and implement the button debouncer architecture using the following sections:

   1. The **synchronizer** consists of two flip-flops (`sync0` and `sync1`) used to safely synchronize the asynchronous input signal to the system clock. The input signal `btn_in` is first registered by `sync0` and then by `sync1` on consecutive clock cycles. This reduces the risk of metastability when processing the push-button input.

   2. The **shift register**, defined by `shift_reg`, is a vector of flip-flops that stores the recent history of the synchronized input signal. Each time the clock-enable signal is asserted, the value of `sync1` is shifted into the register while the oldest value is discarded. By evaluating the contents of this register, the debounce logic can determine whether the button input has remained stable (either high or low) for several samples, effectively filtering out bounce.

   3. Generate the **output signals**. The debounced signal `btn_state` represents the stable state of the button after filtering out bouncing. The signal `btn_press` is a one-clock pulse generated when the button transitions from released (`0`) to pressed (`1`).

   ```vhdl
   architecture Behavioral of debounce is
       ----------------------------------------------------------------
       -- Constants
       ----------------------------------------------------------------
       constant C_SHIFT_LEN : positive := 4;  -- Debounce history
       constant C_MAX       : positive := 2;  -- Sampling period
                                              -- 2 for simulation
                                              -- 200_000 (2 ms) for implementation !!!

       ----------------------------------------------------------------
       -- Internal signals
       ----------------------------------------------------------------
       signal ce_sample : std_logic;
       signal sync0     : std_logic;
       signal sync1     : std_logic;
       signal shift_reg : std_logic_vector(C_SHIFT_LEN-1 downto 0);
       signal debounced : std_logic;
       signal delayed   : std_logic;

       ----------------------------------------------------------------
       -- Component declaration for clock enable
       ----------------------------------------------------------------
       component clk_en is
           generic ( G_MAX : positive );
           port (
               clk : in  std_logic;
               rst : in  std_logic;
               ce  : out std_logic
           );
       end component clk_en;

   begin
       ----------------------------------------------------------------
       -- Clock enable instance
       ----------------------------------------------------------------
       clock_0 : clk_en
           generic map ( G_MAX => C_MAX )
           port map (
               clk => clk,
               rst => rst,
               ce  => ce_sample
           );

       ----------------------------------------------------------------
       -- Synchronizer + debounce
       ----------------------------------------------------------------
       p_debounce : process(clk)
       begin
           if rising_edge(clk) then
               if rst = '1' then
                   sync0     <= '0';
                   sync1     <= '0';
                   shift_reg <= (others => '0');
                   debounced <= '0';
                   delayed   <= '0';

               else
                   -- Input synchronizer
                   sync1 <= sync0;
                   sync0 <= btn_in;

                   -- Sample only when enable pulse occurs
                   if ce_sample = '1' then

                       -- Shift values to the left and load a new sample as LSB
                       shift_reg <= shift_reg(C_SHIFT_LEN-2 downto 0) & sync1;

                       -- Check if all bits are '1'
                       if shift_reg = (shift_reg'range => '1') then
                           debounced <= '1';
                       -- Check if all bits are '0'
                       elsif shift_reg = (shift_reg'range => '0') then
                           debounced <= '0';
                       end if;

                   end if;

                   -- One clock delayed output
                   delayed <= debounced;
               end if;
           end if;
       end process;

       ----------------------------------------------------------------
       -- Outputs
       ----------------------------------------------------------------
       btn_state <= debounced;

       -- One-clock pulse when button pressed
       btn_press <= debounced and not(delayed);

   end Behavioral;
   ```

   > **Note:** The `&` operator is used to **join (concatenate)** two or more arrays or elements into a single, larger array. It does not perform a logical AND (that's done with the keyword `and`). Instead, it simply places bits (or elements) side by side.
   >
   > **Example:** It combines operands from left to right and the result is a new vector whose length is the sum of the operand lengths.
   >
   >    ```vhdl
   >    signal vect   : std_logic_vector(3 downto 0) := b"1010";
   >    signal result : std_logic_vector(4 downto 0);
   >
   >    result <= '1' & vect;  -- result = b"1_1010"
   >    ```

4. Create a VHDL simulation source file named `debounce_tb` and [generate a testbench template](https://vhdl.lapinoo.net/testbench/).

5. Set the clock period to `constant TbPeriod : time := 10 ns;` and verify the functionality of the debouncer.

   ```vhdl
       stimuli : process
       begin
           btn_in <= '0';

           -- Reset generation
           rst <= '1';
           wait for 50 ns;
           rst <= '0';

           -- Simulate button bounce on press
           report "Simulating button press with bounce";

           wait for 100 ns;
           btn_in <= '1';
           wait for 50 ns;
           btn_in <= '0';
           wait for 50 ns;
           btn_in <= '1';
           wait for 250 ns;
           btn_in <= '0';  -- Final stable press

           -- Simulate button bounce on release
           report "Simulating button release with bounce";

           wait for 20 ns;
           btn_in <= '1';
           wait for 60 ns;
           btn_in <= '0';
           wait for 30 ns;
           btn_in <= '1';
           wait for 50 ns;
           btn_in <= '0';  -- Final release
           wait for 300 ns;

           -- Stop the clock and hence terminate the simulation
           report "Simulation finished";
           TbSimEnded <= '1';
           wait;

       end process;
   ```

6. Display the internal signals named `shift_reg`, `debounced`, and `delayed` in the waveform during the simulation.

   <!--
   ![Vivado: add internal signal](images/vivado_add-wave.png)
   -->

7. Use **Flow > Open Elaborated design** and see the schematic after RTL analysis.

8. Use **Flow > Synthesis > Run Synthesis** and then see the schematic at the gate level.

9. (Optional) Extend the edge detector to also detect transitions from high to low. Add an output signal `btn_release` to the entity and architecture. Which logic operation did you use to generate this signal (see figure below)?

   ![edge detector](images/waveform_edge_detect.png)

<a name="task2"></a>

## Task 2: Top-level design and FPGA implementation

Choose one of the following variants and implement a button-triggered binary counter on the Nexys A7 board using LEDs (variant 1) or a 7-segment display driver (variant 2).

### Variant 1: LEDs

**Important:** Change the `C_MAX` constant in the `debounce` architecture to `200_000`. What is the resulting clock enable period for a 100&nbsp;MHz clock (10&nbsp;ns period)?

1. In your project, create a new VHDL design source file named `debounce_counter_top`. Define I/O ports as follows.

   | **Port name** | **Direction** | **Type** | **Description** |
   | :-: | :-: | :-- | :-- |
   | `clk` | in | `std_logic` | Main clock |
   | `btnu` | in | `std_logic` | High-active synchronous reset |
   | `btnd` | in | `std_logic` | Increment counter |
   | `led` | out | `std_logic_vector(7 downto 0)` | Counter value |
   | `led16_b` | out | `std_logic` | Button indicator |

2. In your project, add the design source file `counter.vhd` from the previous lab(s). When adding the file in Vivado, enable the **Copy sources into project** option so that the file is copied into the current project directory.

3. Instantiate the `debounce` and `counter` circuits, and complete the top-level architecture according to the following schematic and template.

   ![top level ver1](images/top-level_ver1.png)

   ```vhdl
   architecture Behavioral of debounce_counter_top is

       component debounce is
           Port ( clk       : in  STD_LOGIC;
                  rst       : in  STD_LOGIC;
                  btn_in    : in  STD_LOGIC;
                  btn_state : out STD_LOGIC;
                  btn_press : out STD_LOGIC);
       end component debounce;

       component counter is

           -- TODO: Add component declaration of `counter`

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

           );

   end Behavioral;
   ```

4. Complete all **TODO** items in the architecture section.

5. Create a new constraints file named `nexys` (XDC file) and copy relevant pin assignments from the [Nexys A7-50T](../examples/nexys.xdc) template.

6. Implement your design to Nexys A7 board:

   1. Click **Generate Bitstream** (the process is time consuming and may take some time).
   2. Open **Hardware Manager**.
   3. Select **Open Target > Auto Connect** (make sure Nexys A7 board is connected and switched on).
   4. Click **Program device** and select the generated file `YOUR-PROJECT-FOLDER/debounce.runs/impl_1/debounce_counter_top.bit`.

7. Use **Implementation > Open Implemented Design > Schematic** to see the generated structure.

### Variant 2: Display driver

**Important:** Change the `C_MAX` constant in the debouncer architecture to `200_000`. What is the resulting clock enable period for a 100&nbsp;MHz clock (10&nbsp;ns period)?

1. In your project, create a new VHDL design source file named `debounce_counter_top`. Define I/O ports as follows.

   | **Port name** | **Direction** | **Type** | **Description** |
   | :-: | :-: | :-- | :-- |
   | `clk` | in | `std_logic` | Main clock |
   | `btnu` | in | `std_logic` | High-active synchronous reset |
   | `btnd` | in | `std_logic` | Increment counter |
   | `seg` | out | `std_logic_vector(6 downto 0)` | Seven-segment cathodes CA..CG (active-low) |
   | `an` | out | `std_logic_vector(7 downto 0)` | Seven-segment anodes AN7..AN0 (active-low) |
   | `dp` | out | `std_logic` | Seven-segment decimal point (active-low, not used) |
   | `led16_b` | out | `std_logic` | Button indicator |

2. In your project, add the design source files `display_driver.vhd`, `counter.vhd`, and `bin2seg.vhd` from the previous lab(s). When adding the file in Vivado, enable the **Copy sources into project** option so that the file is copied into the current project directory.

3. Provide an instantiation of the `debounce`, `counter`, and `display_driver` circuits and complete the top-level architecture according to the following schematic and template.

   ![top level ver2](images/top-level_ver2.png)

   ```vhdl
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

       end component counter;

       component display_driver is

           -- TODO: Add component declaration of `display_driver`

       end component display_driver;

       -- Internal signal(s)
       signal sig_cnt_en : std_logic;

       -- TODO: Add other needed signal(s)

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

           );

       ------------------------------------------------------------------------
       -- Display driver
       ------------------------------------------------------------------------
       display_0 : display_driver
           port map (

               -- TODO: Add component instantiation of `display_driver`

           );

       -- Disable other digits and decimal points
       an(7 downto 2) <= b"11_1111";
       dp             <= '1';

   end Behavioral;
   ```

4. Complete all **TODO** items in the architecture.

5. Create a new constraints file named `nexys` (XDC file) and copy relevant pin assignments from the [Nexys A7-50T](../examples/nexys.xdc) template.

6. Implement your design to Nexys A7 board:

   1. Click **Generate Bitstream** (the process is time consuming and may take some time).
   2. Open **Hardware Manager**.
   3. Select **Open Target > Auto Connect** (make sure Nexys A7 board is connected and switched on).
   4. Click **Program device** and select the generated file `YOUR-PROJECT-FOLDER/debounce.runs/impl_1/debounce_counter_top.bit`.

6. Use **Implementation > Open Implemented Design > Schematic** to see the generated structure.

<a name="tasks"></a>

## Optional tasks

1. Combine both variants from Task 2 and implement a button-triggered binary counter on the Nexys A7 board using LEDs and 7-segment display driver.

2. Extend the debouncer to detect when the button is held down for a **longer period** of time. If the button remains pressed for a predefined duration (for example 500 ms), generate a new output signal `btn_long`. Use a counter driven by the system clock to measure the press duration.

<!--
3. Modify the design so that the debouncer can handle multiple push buttons. Change the input and output signals to `std_logic_vector` and use a **`generate` statement** to instantiate one debouncer for each button. This approach allows the same module to be replicated automatically for all buttons while keeping the design scalable and easy to maintain.

> **Optional technical note:** You can use a `for-generate` loop to create multiple instances of the debouncer module, one per button input.
-->

<a name="questions"></a>

## Questions

1. What is switch bounce, and why is it a problem in digital circuits?

2. What is the purpose of the two flip-flop synchronizer (`sync0`, `sync1`)?

3. Explain how the shift register is used for debouncing.

4. In the expression below, what is the purpose of the `&` operator?

   ```vhdl
   shift_reg <= shift_reg(C_SHIFT_LEN-2 downto 0) & sync1;
   ```

5. For a 100 MHz clock and `C_MAX = 200_000`, what is the clock enable period? Show your calculation.

6. What is the difference between an edge detector and a level detector?

7. Explain how a rising-edge (or falling-edge) detector works using two signals (current and delayed). What condition must be met to generate a pulse?

<a name="references"></a>

## References

1. Clive Maxfield. [How to Implement Hardware Debounce for Switches and Relays When Software Debounce Isn’t Appropriate](https://www.digikey.ee/en/articles/how-to-implement-hardware-debounce-for-switches-and-relays)

2. Jacob Chisholm. [VHDL: Debouncer](https://jchisholm204.github.io/posts/vhdl_debouncer/)

3. DigiKey TechForum. [Debounce Logic Circuit (VHDL)](https://forum.digikey.com/t/debounce-logic-circuit-vhdl/12573)
