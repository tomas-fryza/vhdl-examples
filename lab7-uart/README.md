# Lab 8: UART Transmitter

* [Pre-Lab preparation](#preparation)
* [Part 1: Finite State Machine (FSM)](#part1)
* [Part 2: Basics of UART communication](#part2)
* [Part 3: UART Transmitter in VHDL](#part3)
* [Part 4: Top level VHDL code](#part4)
* [Challenges](#challenges)
* [References](#references)

### Learning objectives

* Understand the philosophy and use of finite state machines
* Use state diagrams
* Understand the difference between Mealy and Moore type of FSM in VHDL
* Understand the UART interface
* Use edge detectors

<a name="preparation"></a>

## Pre-Lab preparation

1. Calculate how many clock periods with frequency of 100&nbsp;MHz contain bit periods representing serial communication with specific baudrates.

   &nbsp;
   ![number of periods](images/baudrate.png)
   &nbsp;

<!--
https://editor.codecogs.com/
N\text{\_}PERIODS=\frac{1}{baudrate}\cdot f_{clk}=
-->

   | **Baudrate** | **Number of clk periods** | **Common usage** |
   | :-: | :-: | :-- |
   | 2400 |  | Low-speed serial devices |
   | **9600** | 10_417 | Default for many microcontrollers |
   | 57600 |  | Mid-speed serial communications |
   | **115200** |  | High-speed UART, default for many modern devices |

2. Optional: See video tutorial [Implementing the candy-lock FSM in VHDL](https://www.youtube.com/watch?v=5kC1XEWhIFQ)

<a name="part1"></a>

## Part 1: Finite State Machine (FSM)

A **Finite State Machine (FSM)** is a mathematical model used to describe and represent the behavior of systems that can be in a finite number of states at any given time. It consists of a set of states, transitions between these states, and actions associated with these transitions.

The main properties of using FSMs include:

   1. **Determinism**: FSMs are deterministic if, for each state and input, there is exactly one transition to a next state. This property simplifies analysis and implementation.

   2. **State Memory**: FSMs inherently have memory as they retain information about their current state. This allows them to model systems with sequential behavior.

   3. **Simplicity**: FSMs are relatively simple and intuitive to understand, making them useful for modeling and designing systems with discrete and sequential behavior.

   4. **Parallelism**: FSMs can represent parallelism by having multiple state machines working concurrently, each handling different aspects of the system.

The main types of FSMs include Moore Machine and Mealy Machine. In a **Moore machine**, outputs are associated with states (see [figure](https://www.allaboutcircuits.com/technical-articles/implementing-a-finite-state-machine-in-vhdl/) bellow), while in a **Mealy machine**, outputs are associated with transitions between states. This means that Moore machines produce outputs only after transitioning to a new state, while Mealy machines can produce outputs immediately upon receiving an input.

   ![Moore-type FSM](images/diagram_moore_structure.png)

One widely used method to illustrate a finite state machine is through a **state diagram**, comprising circles connected by directed arcs. Each circle denotes a machine state labeled with its name, and, in the case of a Moore machine, an [output value](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-004-computation-structures-spring-2017/c6/c6s1/) associated with the state.

   ![State diagrams](images/diagram_circle.png)

Directed arcs signify the transitions between states in a finite state machine (FSM). For a Mealy machine, these arcs are labeled with input/output pairs, while for a Moore machine, they are labeled solely with inputs.

   ![State diagrams](images/diagram_structure.png)

<a name="part2"></a>

## Part 2: Basics of UART communication

The UART (Universal Asynchronous Receiver-Transmitter) is not a communication protocol like SPI and I2C, but a physical circuit in a microcontroller, or a stand-alone integrated circuit, that translates communicated data between serial and parallel forms. It is one of the simplest and easiest method for implement and understanding.

In UART communication, two UARTs communicate directly with each other. The transmitting UART converts parallel data from a CPU into serial form, transmits it in serial to the receiving UART, which then converts the serial data back into parallel data for the receiving device. Only two wires are needed to transmit data between two UARTs. Data flows from the Tx pin of the transmitting UART to the Rx pin of the receiving UART: [link](https://www.circuitbasics.com/basics-uart-communication/), [link](https://www.analog.com/en/analog-dialogue/articles/uart-a-hardware-communication-protocol.html).

UARTs transmit data asynchronously, which means there is no external clock signal to synchronize the output of bits from the transmitting UART. Instead, timing is agreed upon in advance between both units, and special **Start** (log. 0) and 1 or 2 **Stop** (log. 1) bits are added to each data package. These bits define the beginning and end of the data packet so the receiving UART knows when to start reading the bits. In addition to the start and stop bits, the packet/frame also contains data bits and optional parity.

The amount of **data** in each packet can be set from 5 to 9 bits. If it is not otherwise stated, data is transferred least-significant bit (LSB) first.

**Parity** is a form of very simple, low-level error checking and can be Even or Odd. To produce the parity bit, add all 5-9 data bits and extend them to an even or odd number. For example, assuming parity is set to even and was added to a data byte `0110_1010`, which has an even number of 1's (4), the parity bit would be set to 0. Conversely, if the parity mode was set to odd, the parity bit would be 1.

One of the most common UART formats is called **9600 8N1**, which means 8 data bits, no parity, 1 stop bit and a symbol rate of 9600&nbsp;Bd.

![UART frame 8N1](images/uart_frame_8n1.png)

<a name="part3"></a>

## Part 3: UART Transmitter in VHDL

1. Run Vivado, create a new project and implement an FSM version of UART transmitter 8N1 with clock enable and reset:

   1. Project name: `uart`
   2. Project location: your working folder, such as `Documents`
   3. Project type: **RTL Project**
   4. Create a VHDL source file: `uart_tx`
   5. Do not add any constraints now
   6. Choose a default board: `Nexys A7-50T`
   7. Click **Finish** to create the project
   8. Define I/O ports of new module:

      | **Port name** | **Direction** | **Type** | **Description** |
      | :-: | :-: | :-- | :-- |
      | `clk`      | input  | `std_logic` | Main clock |
      | `rst`      | input  | `std_logic` | High-active synchronous reset |
      | `tx_data`  | input  | `std_logic_vector(7 downto 0)` | Data to transmit |
      | `tx_start` | input  | `std_logic` | Start transmission |
      | `tx` | output | `std_logic` | UART Tx line |
      | `done` | output | `std_logic` | Transmission completed |

2. Add two generics:

   ```vhdl
   entity uart_tx is
       generic (
           CLK_FREQ : integer := 100_000_000;
           BAUDRATE : integer := 9_600
       );
       ...
   ```

3. Define four states for the FSM and an internal counters in the architecture declaration section to count a sequence of data bits and clock periods.

    ```vhdl
    architecture Behavioral of uart_tx is
        type   state_type is (IDLE, START_BIT, DATA_BITS, STOP_BIT);
        signal state : state_type;

        constant N_PERIODS : integer := (CLK_FREQ / BAUDRATE);

        signal bit_idx : integer range 0 to 7;
        signal periods : integer range 0 to N_PERIODS - 1;
        signal reg     : std_logic_vector(7 downto 0);

    begin
        ...
    ```

4. Complete the architecture body section according to the following template.

    ```vhdl
    begin
        -- UART Transmitter FSM
        p_transmitter : process (clk) is
        begin
            if rising_edge(clk) then
                if (rst = '1') then
                    -- Reset state to IDLE

                else
                    case state is

                        when IDLE =>
                            -- Keep Tx line to high

                            -- Clear done to 0

                            if (tx_start = '1') then
                                periods <= 0;
                                state   <= START_BIT;
                            end if;

                        when START_BIT =>
                            -- Start bit (LOW), Load data to transmit register

                            -- Reset number of transmitted bits

                            -- Wait for bit period according to baudrate
                            if (periods = N_PERIODS - 1) then
                                state   <= DATA_BITS;
                                periods <= 0;
                            else
                                periods <= periods + 1;
                            end if;

                        when DATA_BITS =>
                            -- Transmit LSB

                            -- Wait for bit period according to baudrate
                            if (periods = N_PERIODS - 1) then
                                -- Shift data register
                                reg     <= '0' & reg(7 downto 1);
                                periods <= 0;

                                -- Send all data bits
                                if (bit_idx = 7) then
                                    state <= STOP_BIT;
                                else
                                    bit_idx <= bit_idx + 1;
                                end if;
                            else
                                periods <= periods + 1;
                            end if;

                        when STOP_BIT =>
                            -- Set Tx stop bit (HIGH)

                            -- Set done to 1

                            -- Wait for bit period according to baudrate
                            if (periods = N_PERIODS - 1) then
                                state <= IDLE;
                            else
                                periods <= periods + 1;
                            end if;

                        when others =>
                            state <= IDLE;

                    end case;
                end if;
            end if;
        end process p_transmitter;
    end Behavioral;
    ```

5. Use **Flow > Open Elaborated design** and see the schematic after RTL analysis.

6. Generate a [simulation source](https://vhdl.lapinoo.net/testbench/) named `uart_tx_tb`, add generics to testbench, and simulate the UART frames for data bytes `0x41` and `0x43` with baudrate of 9600.

   > **Note:** To display internal signal values, follow these steps:
   > 1. Select `dut` in the **Scope** folder.
   > 2. Right-click on the `state` signal name in the **Objects** folder.
   > 3. Add this signal by selecting the **Add to Wave Window** command.
   > 4. Click on the **Relaunch Simulation** icon.
   >
   >    ![Internal signals simulation](images/vivado_signals.png)

<a name="part4"></a>

## Part 4: Top level VHDL code

1. Create a VHDL design source named `top_level`. Implement a button-triggered UART transmitter on the Nexys A7 board to send data to your computer via the serial line. The transmitted data will be specified using the 8 switches `SW[7:0]` to input ASCII codes, which you can look up on this [ASCII code chart](https://www.ascii-code.com/).

   ![top level](images/top-level_ver1.png)

   > **Note:**
   > * Your transmitter signal `tx` must be connected to onboard FTDI FT2232HQ USB-UART bridge receiver, ie. use pin number `D4` which is maped in XDC template to `UART_RXD_OUT` (see [Nexys A7 reference manual, section 6](https://digilent.com/reference/programmable-logic/nexys-a7/reference-manual?redirect=1)).
   
2. Use online template for your [constraints XDC](https://raw.githubusercontent.com/Digilent/digilent-xdc/master/Nexys-A7-50T-Master.xdc) file `nexys` and uncomment the used pins according to the `top_level` entity.

3. Run Putty or [online serial monitor](https://hhdsoftware.com/online-serial-port-monitor). Set the **Connection type** to `Serial`, specify your **Serial line** (e.g., COM3), set the **Speed** (or Baud Rate), and then click the **Open** button to initiate the communication. Clicking the Left button on the board will transmit the user data selected by the switches.

   ![putty1](images/screenshot_putty_type.png)
<!--   ![putty2](images/screenshot_putty_config.png)-->

<a name="challenges"></a>

## Challenges

1. Modify the UART transmitter according to the following top level schematic:

   ![top level](images/top-level_ver2.png)

   > **Note:**
   > * The `counter` component from the previous lab(s) is required. You can copy the `counter.vhd` file to `YOUR-PROJECT-FOLDER/uart.srcs/sources_1/new/` folder and add it to the project or use **Copy scripts to project** checkbox while adding design source file in Vivado.
   > * The source code of component `debounce` is defined [here](https://raw.githubusercontent.com/tomas-fryza/vhdl-examples/refs/heads/master/examples/_debounce/debounce.vhd).

2. In the `*.xdc` constraints file, remap the UART outputs to any Pmod port on the Nexys A7 board, and display the UART values on an oscilloscope or logic analyzer.

   ![pmods](images/pmod_table.png)

   Connect the logic analyzer to your Pmod pins, including GND. Launch the **Logic** analyzer software and start the capture. The Saleae Logic software offers a decoding feature to transform the captured signals into meaningful UART messages. Click the **+ button** in the **Analyzers** section and set up the **Async Serial** decoder.

      ![Logic analyzer -- Paris](images/analyzer_paris.png)

      > **Note:** To perform this analysis, you will need a logic analyzer such as [Saleae](https://www.saleae.com/) or [similar](https://www.amazon.com/KeeYees-Analyzer-Device-Channel-Arduino/dp/B07K6HXDH1/ref=sr_1_6?keywords=saleae+logic+analyzer&qid=1667214875&qu=eyJxc2MiOiI0LjIyIiwicXNhIjoiMy45NSIsInFzcCI6IjMuMDMifQ%3D%3D&sprefix=saleae+%2Caps%2C169&sr=8-6) device. Additionally, you should download and install the [Saleae Logic 1](https://support.saleae.com/logic-software/legacy-software/older-software-releases#logic-1-x-download-links) or [Saleae Logic 2](https://www.saleae.com/downloads/) software on your computer.
      >
      > You can find a comprehensive tutorial on utilizing logic analyzer in this [video](https://www.youtube.com/watch?v=CE4-T53Bhu0).

<a name="references"></a>

## References

1. David Williams. [Implementing a Finite State Machine in VHDL](https://www.allaboutcircuits.com/technical-articles/implementing-a-finite-state-machine-in-vhdl/)

2. MIT OpenCourseWare. [L06: Finite State Machines](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-004-computation-structures-spring-2017/c6/c6s1/)

3. VHDLwhiz. [One-process vs two-process vs three-process state machine](https://vhdlwhiz.com/n-process-state-machine/)
