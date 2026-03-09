# Laboratory 5: Multiple seven-segment displays

* [Task 1: Two-digit display driver](#task1)
* [Task 2: Top-level design and FPGA implementation](#task2)
* [Optional tasks](#tasks)
* [Questions](#questions)
* [References](#references)

### Objectives

After completing this laboratory, students will be able to:

* Use several 7-segment displays
* Use previously created modules in a new design
* Understand how to use the multiplexer to switch between displays

### Background

The Nexys A7 board provides two four-digit common anode seven-segment LED displays (configured to behave like a single eight-digit display). See [schematic](https://github.com/tomas-fryza/vhdl-examples/blob/master/docs/nexys-a7-sch.pdf) or [reference manual](https://reference.digilentinc.com/reference/programmable-logic/nexys-a7/reference-manual) of the Nexys A7 board and find out the connection of 7-segment displays and push-buttons. What is the difference between NPN and PNP type of BJT (Bipolar Junction Transistor)?

   ![nexys A7 led and segment](images/nexys-a7_leds-display.png)

A common way to control multiple displays is to gradually switch between them. We control (connect to supply voltage) only one of the displays at a time. Due to the physiological properties of human vision, it is necessary that the time required to display the whole value is a maximum of 16&nbsp;ms. If we display four digits, then the duration of one of them is 4&nbsp;ms. If we display eight digits, the time is reduced to 2&nbsp;ms, etc. Here is a general situation with four 7-segment displays.

   ![display multiplexing](images/waveform_multiplexing-general.png)

<a name="task1"></a>

## Task 1: Two-digit display driver

1. Run Vivado, create a new RTL project named `display` and add a VHDL source file `display_driver`. Use the following I/O ports:

   | **Port name** | **Direction** | **Type** | **Description** |
   | :-: | :-: | :-- | :-- |
   | `clk` | in | `std_logic` | Main clock |
   | `rst` | in | `std_logic` | High-active synchronous reset |
   | `data` | in | `std_logic_vector(7 downto 0)` | Vector of input bits, 4 per digit |
   | `seg` | out | `std_logic_vector(6 downto 0)` | {a,b,c,d,e,f,g} active-low outputs |
   | `anode` | out | `std_logic_vector(1 downto 0)` | Anodes AN1..AN0 (active-low) |

2. In your project, add the design source files `clk_en.vhd`, `counter.vhd`, and `bin2seg.vhd` from the previous laba and check the "Copy sources into project".

   ![vivado_copy-sources](images/vivado_copy-sources.png)

3. Use component declaration and instantiation of `clk_en`, `counter`, and `bin2seg`, and define the display driver architecture as follows.

   ![schematic of display driver](images/schematic_display-driver.png)

   ```vhdl
   architecture Behavioral of display_driver is

       -- Component declaration for clock enable
       component clk_en is
           generic ( G_MAX : positive );
           port (
               clk : in  std_logic;
               rst : in  std_logic;
               ce  : out std_logic
           );
       end component clk_en;
    
       -- Component declaration for binary counter
       component counter is
           generic ( G_BITS : positive );
           port (
               clk : in  std_logic;
               rst : in  std_logic;
               en  : in  std_logic;
               cnt : out std_logic_vector(G_BITS - 1 downto 0)
           );
       end component counter;
    
       -- Component declaration for bin2seg
       component bin2seg is

           -- TODO: Add declaration of `bin2seg`

       end component bin2seg;
    
       -- Internal signals
       signal sig_en : std_logic;

       -- TODO: Add needed signals

   begin

       ------------------------------------------------------------------------
       -- Clock enable generator for refresh timing
       ------------------------------------------------------------------------
       clock_0 : component clk_en
           generic map ( G_MAX => 16 )  -- Adjust for flicker-free multiplexing
           port map (                   -- For simulation: 16
               clk => clk,              -- For implementation: 1_600_000
               rst => rst,
               ce  => sig_en
           );

       ------------------------------------------------------------------------
       -- N-bit counter for digit selection
       ------------------------------------------------------------------------
       counter_0 : component counter
           generic map ( G_BITS => 1 )
           port map (
               clk    => clk,
               rst    => rst,
               en     => sig_en,
               cnt(0) => sig_digit  -- std_logic_vector => std_logic
           );                       -- cnt(0) only for 1-bit counter

       ------------------------------------------------------------------------
       -- Digit select
       ------------------------------------------------------------------------
       sig_bin <= data(3 downto 0) when  -- TODO: Complete the multiplexor

       ------------------------------------------------------------------------
       -- 7-segment decoder
       ------------------------------------------------------------------------
       decoder_0 : component bin2seg
           port map (

               -- TODO: Complete the instantiation of `bin2seg`

           );

       ------------------------------------------------------------------------
       -- Anode select process
       ------------------------------------------------------------------------
       p_anode_select : process (sig_digit) is
       begin
           case sig_digit is
               when '0' =>
                   anode <= b"10";  -- Right digit

               -- TODO: Complete the anode selection

               when others =>
                   anode <= b"11";  -- Do not select anything
           end case;
       end process;

   end Behavioral;
   ```

4. Complete all "TODOs" in the architecture.

5. Create a VHDL simulation source file named `display_driver_tb` and [generate a testbench template](https://vhdl.lapinoo.net/testbench/).

6. Set clock period to `10 ns` and verify the functionality of the driver.

   ```vhdl
   stimuli : process
   begin
       data <= (others => '0');

       -- Reset generation
       rst <= '1';
       wait for 100 ns;
       rst <= '0';
       wait for 100 ns;

       data <= x"18";
       wait for 50 * TbPeriod;

       data <= x"19";
       wait for 50 * TbPeriod;

       data <= x"20";
       wait for 50 * TbPeriod;

       -- Stop the clock and hence terminate the simulation
       TbSimEnded <= '1';
       wait;
   end process;
   ```

7. Display all internal signals in the simulation.

   ![Vivado: add internal signal](images/vivado_add-wave.png)

8. Use **Flow > Open Elaborated design** and see the schematic after RTL analysis.

9. Use **Flow > Synthesis > Run Synthesis** and then see the schematic at the gate level.

<a name="task2"></a>

## Task 2: Top-level design and FPGA implementation

1. In your project, create a new VHDL design source file named `display_top`. Define I/O ports as follows.

   | **Port name** | **Direction** | **Type** | **Description** |
   | :-: | :-: | :-- | :-- |
   | `clk` | in | `std_logic` | Main clock |
   | `btnu` | in | `std_logic` | High-active synchronous reset |
   | `sw` | in | `std_logic_vector(7 downto 0)` | Input bits for two digits |
   | `seg` | out | `std_logic_vector(6 downto 0)` | Seven-segment cathodes CA..CG (active-low) |
   | `an` | out | `std_logic_vector(7 downto 0)` | Seven-segment anodes AN7..AN0 (active-low) |
   | `dp` | out | `std_logic` | Seven-segment decimal point (active-low, not used) |

2. **Important note:** Change the `G_MAX` parameter of `clk_en` instantiation in the driver architecture to **1_600_000**!

3. Provide instantiation of the `display_driver` circuit and complete the top-level architecture.

   ![top level ver1](images/top-level_ver1.png)

   ```vhdl
   architecture Behavioral of display_top is

       -- Component declaration for display_driver
       component display_driver is

           -- TODO: Complete declaration of `display_driver`

       end component display_driver;

   begin

       -- Display driver instantiation
       display_0 : display_driver
       port map (

           -- TODO: Complete the instantiation of `display_driver`

       );

       an(7 downto 2) <= b"11_1111";
       dp <= '1';

   end Behavioral;
   ```

4. Create a new constraints file `nexys` (XDC file) and copy relevant pin assignments from the [Nexys A7-50T](../examples/_solutions/nexys.xdc) template.

5. Implement your design to Nexys A7 board:

   1. Click **Generate Bitstream** (the process is time consuming and may take some time).
   2. Open **Hardware Manager**.
   3. Select **Open Target > Auto Connect** (make sure Nexys A7 board is connected and switched on).
   4. Click **Program device** and select the generated file `YOUR-PROJECT-FOLDER/display.runs/impl_1/display_top.bit`.

6. Modify the `G_MAX` parameter in `display_driver.vhd` file so you can not see the display blinking.

7. Use **Implementation > Open Implemented Design > Schematic** to see the generated structure.

<a name="tasks"></a>

## Optional tasks

1. Modify top-level design, use Pmod ports and verify period of anode signals using external logic analyzer.

   ![top level ver2](images/top-level_ver2.png)

   ![pmod ports](images/pmod_table.png)

2. Extend the `display_driver` structure to control four or even eight 7-segment displays.

<a name="references"></a>

## References

<!--
1. Bharadwaj. [Seven Segment Display Working Principle](https://engineeringtutorial.com/seven-segment-display-working-principle/)
-->

1. Digilent blog. [Nexys A7 Reference Manual](https://reference.digilentinc.com/reference/programmable-logic/nexys-a7/reference-manual)

2. [WaveDrom - Digital Timing Diagram everywhere](https://wavedrom.com/)

3. Tomas Fryza. [Driver for 7-segment display](https://www.edaplayground.com/x/3f_A)

4. Digilent. [General .xdc file for the Nexys A7-50T](https://github.com/Digilent/digilent-xdc/blob/master/Nexys-A7-50T-Master.xdc)
