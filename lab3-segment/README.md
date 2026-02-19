# Lab 3: Seven-segment display decoder

* [Part 1: VHDL code for seven-segment display decoder](#part1)
* [Part 2: Structural modeling, instantiation](#part2)
* [Part 3: Top level VHDL code](#part3)
* [Part 4: Implement to FPGA](#part4)
* [Optional tasks](#tasks)
* [Questions](#questions)
* [References](#references)

### Objectives

After completing this laboratory, students will be able to:

* Use 7-segment display
* Use VHDL processes
* Understand the structural modeling and instantiation in VHDL
* Implement design to real hardware

### Background

The Nexys A7 board provides two four-digit common anode seven-segment LED displays (configured to behave like a single eight-digit display). See [schematic](https://github.com/tomas-fryza/vhdl-examples/blob/master/docs/nexys-a7-sch.pdf) or [reference manual](https://reference.digilentinc.com/reference/programmable-logic/nexys-a7/reference-manual) of the Nexys A7 board and find out the connection of 7-segment displays and push-buttons. What is the difference between NPN and PNP type of BJT (Bipolar Junction Transistor).

   ![nexys A7 led and segment](../lab2-comparator/images/nexys-a7_leds-display.png)

The Binary to 7-Segment Decoder converts 4-bit binary data to 7-bit control signals which can be displayed on 7-segment display. A display consists of 7 LED segments to display the decimal digits `0` to `9` and letters `A` to `F`. Complete the decoder truth table for **common anode** (active low) 7-segment display.

   ![https://lastminuteengineers.com/seven-segment-arduino-tutorial/](images/7-Segment-Display-Number-Formation-Segment-Contol.png)

   | **Symbol** | **Inputs** | **a** | **b** | **c** | **d** | **e** | **f** | **g** |
   | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: |
   | 0 | 0000 | 0 | 0 | 0 | 0 | 0 | 0 | 1 |
   | 1 | 0001 | 1 | 0 | 0 | 1 | 1 | 1 | 1 |
   | 2 |      |   |   |   |   |   |   |   |
   | 3 |      |   |   |   |   |   |   |   |
   | 4 |      |   |   |   |   |   |   |   |
   | 5 |      |   |   |   |   |   |   |   |
   | 6 |      |   |   |   |   |   |   |   |
   | 7 | 0111 | 0 | 0 | 0 | 1 | 1 | 1 | 1 |
   | 8 | 1000 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
   | 9 |      |   |   |   |   |   |   |   |
   | A |      |   |   |   |   |   |   |   |
   | b |      |   |   |   |   |   |   |   |
   | C |      |   |   |   |   |   |   |   |
   | d |      |   |   |   |   |   |   |   |
   | E | 1110 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
   | F | 1111 | 0 | 1 | 1 | 1 | 0 | 0 | 0 |

<!--
   > Note that, there are other types of segment displays, [such as 14- or 16-segment](http://avtanski.net/projects/lcd/).
   >
   > ![other displays](images/7-14-segment-display.jpg) &nbsp; &nbsp; &nbsp; &nbsp;
   > ![other displays](images/16-segment-display.png)
-->

<a name="part1"></a>

## Part 1: VHDL code for seven-segment display decoder

1. Run Vivado and create a new project:

   1. Project name: `segment`
   2. Project location: your working folder, such as `Documents`
   3. Project type: **RTL Project** (Note, the Register-Transfer Level refers to a level of abstraction used to describe how the data is transferred and processed inside hardware.)
   4. Create a new VHDL source file: `bin2seg`
   5. Do not add any constraints now
   6. Choose a default board: `Nexys A7-50T`
   7. Click **Finish** to create the project
   8. Define I/O ports of new module:
      * `bin`, `in`, Bus: `check`, MSB: `3`, LSB: `0`
      * `seg`, `out`, Bus: `check`, MSB: `6`, LSB: `0`

      | **Port name** | **Direction** | **Type** | **Description** |
      | :-: | :-: | :-- | :-- |
      | `bin` | input   | `std_logic_vector(3 downto 0)` | 4-bit input |
      | `seg` | output  | `std_logic_vector(6 downto 0)` | {a,b,c,d,e,f,g} active-low |

2. Use [combinational process](https://github.com/tomas-fryza/vhdl-examples/wiki/Processes) and complete an architecture of the decoder.

   The process statement is very similar to the classical programming language. The code inside the process statement is executed sequentially. The process statement is declared in the concurrent section of the architecture, so two different processes are executed concurrently.

   ```vhdl
   process_label : process (sensitivity_list) is
       -- Declarative part (can be empty)
   begin
       -- Sequential statements
   end process process_label;
   ```

   In the process sensitivity list are declared all the signal which the process is sensitive to. In the following example, the process is evaluated any time a transaction is scheduled on the signal `bin` only. Inside a process, `case`-`when` [assignments](https://github.com/tomas-fryza/vhdl-examples/wiki/Signal-assignments) can be used.

   ```vhdl
   -- This combinational process decodes binary input
   -- `bin` into 7-segment display output `seg` for a
   -- Common Anode configuration. When `bin` changes,
   -- the process is triggered.
   p_7seg_decoder : process (bin) is
   begin
       case bin is
           when x"0" =>
               seg <= "0000001";
           when x"1" =>
               seg <= "1001111";

           -- WRITE YOUR CODE HERE
           -- 2, 3, 4, 5, 6

           when x"7" =>
               seg <= "0001111";
           when x"8" =>
               seg <= "0000000";

           -- WRITE YOUR CODE HERE
           -- 9, A, b, C, d

           when x"E" =>
               seg <= "0110000";
           when others =>
               seg <= "0111000";
       end case;
   end process p_7seg_decoder;
   ```

3. Create a VHDL simulation source `bin2seg_tb`, [generate testbench template](https://vhdl.lapinoo.net/testbench/), complete all test cases, and verify the functionality of your decoder.

   ```vhdl
   -- Test case 1: Input binary value 0000
   bin <= x"0";
   wait for 50 ns;
   assert seg = "0000001"
     report "0 does not map to 0000001" severity error;

   -- WRITE YOUR CODE HERE
   ```

   > **Note:** Test cases can be also generated by a loop. IMPORTANT: In the following example you have to also include `ieee.numeric_std.all` package for data types conversion.
   >
   > ```vhdl
   >   library ieee;
   >     use ieee.std_logic_1164.all;
   >     use ieee.numeric_std.all; -- Definition of "to_unsigned"
   >
   >   ...
   >   -- Loop for all hex values
   >   for i in 0 to 15 loop
   >
   >     -- Convert decimal value `i` to 4-bit wide binary
   >     bin <= std_logic_vector(to_unsigned(i, 4));
   >     wait for 50 ns;
   >
   >   end loop;
   > ```

4. Use **Flow > Open Elaborated design** and see the schematic after RTL analysis. Note that RTL (Register Transfer Level) represents digital circuit at the abstract level.

<a name="part2"></a>

## Part 2: Structural modeling, instantiation

VHDL provides a mechanism how to build a larger [structural systems](https://surf-vhdl.com/vhdl-syntax-web-course-surf-vhdl/vhdl-structural-modeling-style/) from simpler or predesigned components. It is called an **instantiation**. Each instantiation statement creates an instance (copy) of a design entity.

VHDL-93 and later offers two methods of instantiation: **direct instantiation** and **component instantiation**. In direct instantiation, the entity itself is directly instantiated within the architecture of the parent entity. In component instantiation, the component needs to be defined within the parental architecture first. In both, the ports are connected using the port map.

Example shows the component instantiation statement defining a simple netlist. Here, the two instances (copies) U1 and U2 are instantiations of the 2-input XOR gate component:

![component instance](images/component_example.png)

```vhdl
...
architecture behavioral of top_level is
  -- Component declaration
  component xor2 is
    port (
      in1  : in  std_logic;
      in2  : in  std_logic;
      out1 : out std_logic
    );
  end component;

  -- Local signal
  signal sig_tmp : std_logic;

begin
  -- Component instantiations
  U1 : xor2
    port map (
      in1  => a,
      in2  => b,
      out1 => sig_tmp
    );

  U2 : xor2
    port map (
      in1  => sig_tmp,
      in2  => c,
      out1 => y
    );

end architecture;
```

<a name="part3"></a>

## Part 3: Top level VHDL code

Utilize the top-level design to instantiate a `bin2seg` component and implement the seven-segment display decoder on the Nexys A7 board. Input for the decoder is obtained from four slide switches, and the output is directed to a single 7-segment display,.

1. Create a new VHDL design source `segment_top` in your project.
2. Define I/O ports as follows.

   | **Port name** | **Direction** | **Type** | **Description** |
   | :-: | :-: | :-- | :-- |
   | `sw`  | in  | `std_logic_vector(3 downto 0)` | Input data |
   | `seg` | out | `std_logic_vector(6 downto 0)` | Seven-segment cathodes CA..CG (active-low) |
   | `dp` | out | `std_logic` | Decimal point |
   | `an` | out | `std_logic_vector(7 downto 0)` | Seven-segment anodes AN7..AN0 (active-low) |

3. Use component instantiation of `bin2seg` and define the top-level architecture.

   ![Top level, 1-digit](images/top-level_1-digit.png)

   > **Note:** In Vivado, individual templates can be found in **Flow Navigator** or in the menu **Tools > Language Templates**. Search for `component declaration` and `component instantiation`.

   ```vhdl
   architecture behavioral of segment_top is
     -- Declare component `bin2seg`
     component bin2seg is
       port (
         bin : in    std_logic_vector(3 downto 0);
         seg : out   std_logic_vector(6 downto 0)
       );
     end component;

   begin

     -- Instantiate (make a copy of) `bin2seg` component to decode
     -- binary input into seven-segment display signals.
     display : bin2seg
       port map (
         bin => sw,
         seg => seg
       );

     -- Turn off decimal point


     -- Set digit position


   end architecture behavioral;
   ```

4. Display input switch value on LEDs.

<a name="part4"></a>

## Part 4: Implementing to FPGA

*A constraint is a rule that dictates a placement or timing restriction for the implementation. Constraints are not VHDL, and the syntax of constraints files differ between FPGA vendors.*

*__Physical constraints__ limit the placement of a signal or instance within the FPGA. The most common physical constraints are pin assignments. They tell the P&R (Place & Route) tool to which physical FPGA pins the top-level entity signals shall be mapped.*

*__Timing constraints__ set boundaries for the propagation time from one logic element to another. The most common timing constraint is the clock constraint. We need to specify the clock frequency so that the P&R tool knows how much time it has to work with between clock edges.*

The Nexys A7 board provides sixteen switches and LEDs. The switches can be used to provide inputs, and the LEDs can be used as output devices.

1. See [schematic](https://github.com/tomas-fryza/vhdl-examples/blob/master/docs/nexys-a7-sch.pdf) or [reference manual](https://reference.digilentinc.com/reference/programmable-logic/nexys-a7/reference-manual) of the Nexys A7 board and find out components you are using.

2. The Nexys A7 board have hardwired connections between FPGA chip and the switches, LEDs, seven-segment displays, and others. To use these devices, it is necessary to include in your project the correct pin assignments:

   1. Create a new constraints source `nexys` (XDC file).
   2. Copy/paste default constraints from [Nexys-A7-50T-Master.xdc](https://raw.githubusercontent.com/Digilent/digilent-xdc/master/Nexys-A7-50T-Master.xdc) to `nexys.xdc` file, uncomment used pins according to the `segment_top` entity or use the following minimal constrains:

        ```xdc
        set_property PACKAGE_PIN J15 [get_ports {sw[0]}] ; # SW_0
        set_property PACKAGE_PIN L16 [get_ports {sw[1]}] ; # SW_1
        set_property PACKAGE_PIN M13 [get_ports {sw[2]}] ; # SW_2
        set_property PACKAGE_PIN R15 [get_ports {sw[3]}] ; # SW_3
        set_property IOSTANDARD LVCMOS33 [get_ports {sw[*]}]

        set_property PACKAGE_PIN T10 [get_ports {seg[6]}] ; # CA
        set_property PACKAGE_PIN R10 [get_ports {seg[5]}] ; # CB
        set_property PACKAGE_PIN K16 [get_ports {seg[4]}] ; # CC
        set_property PACKAGE_PIN K13 [get_ports {seg[3]}] ; # CD
        set_property PACKAGE_PIN P15 [get_ports {seg[2]}] ; # CE
        set_property PACKAGE_PIN T11 [get_ports {seg[1]}] ; # CF
        set_property PACKAGE_PIN L18 [get_ports {seg[0]}] ; # CG
        set_property PACKAGE_PIN H15 [get_ports {dp}]     ; # DP
        set_property IOSTANDARD LVCMOS33 [get_ports {seg[*] dp}]

        set_property PACKAGE_PIN J17 [get_ports {an[0]}] ; # AN0
        set_property PACKAGE_PIN J18 [get_ports {an[1]}] ; # AN1
        set_property PACKAGE_PIN T9  [get_ports {an[2]}] ; # AN2
        set_property PACKAGE_PIN J14 [get_ports {an[3]}] ; # AN3
        set_property PACKAGE_PIN P14 [get_ports {an[4]}] ; # AN4
        set_property PACKAGE_PIN T14 [get_ports {an[5]}] ; # AN5
        set_property PACKAGE_PIN K2  [get_ports {an[6]}] ; # AN6
        set_property PACKAGE_PIN U13 [get_ports {an[7]}] ; # AN7
        set_property IOSTANDARD LVCMOS33 [get_ports {an[*]}]
        ```

3. Implement your design to Nexys A7 board:

   1. Use **Flow > Generate Bitstream** (the process is time consuming and can take tens of seconds).
   2. Select **Open Hardware Manager**.
   3. Click on **Open Target > Auto Connect** (make sure Nexys A7 board is connected and switched on).
   4. Click on **Program device** and select generated bitstream `YOUR-PROJECT-FOLDER/segment.runs/impl_1/segment_top.bit`.

4. Test the functionality of the seven-segment display decoder by toggling the switches and observing the display.

5. Use **IMPLEMENTATION > Open Implemented Design > Schematic** to see the generated structure.

<a name="tasks"></a>

## Optional tasks

1. Extend the functionality of one-digit 7-segment decoder to drive a two-digit display. Upon pressing a button, the display will switch between the two digits.

   ![Top level, 2-digit](images/top-level_2-digit.png)

   ```vhdl
   architecture behavioral of segment_top is
     ...

     -- Local signal for 7-segment decoder
     signal sig_tmp : std_logic_vector(3 downto 0);

   begin
     -- Switch between inputs
     sig_tmp <= sw_l when ... else
                sw_r;
     ...

     -- Set display positions
     an(7 downto 2) <= b"11_1111";
     ...

   end architecture behavioral;
   ```

<a name="questions"></a>

## Questions

1. TBD

<a name="references"></a>

## References

1. Digilent Reference. [Nexys A7 Reference Manual](https://digilent.com/reference/programmable-logic/nexys-a7/reference-manual)

2. LastMinuteEngineers. [How Seven Segment Display Works & Interface it with Arduino](https://lastminuteengineers.com/seven-segment-arduino-tutorial/)

3. Tomas Fryza. [Template for 7-segment display decoder](https://www.edaplayground.com/x/Vdpu)

4. Digilent. [General .xdc file for the Nexys A7-50T](https://github.com/Digilent/digilent-xdc/blob/master/Nexys-A7-50T-Master.xdc)

5. [LCD/LED Screenshot generator](http://avtanski.net/projects/lcd/)
