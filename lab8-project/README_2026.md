# VHDL projects 2026

The projects are designed for groups of **2–4 students** with a total time allocation of **10 hours** (5 lab sessions of 2 hours each).

## 1. Project rules

- **Group Work:**  
  Work on your assigned topic within your computer exercise group. No switching groups is allowed. *(Exception: Friday 9:00 group moved to Thursday 8:00.)*

- **Attendance & Weekly Checks:**  
  Attendance is mandatory. Weekly graded progress checks will take place.

- **Grading & Git Repositories:**  
  Points will be awarded or deducted weekly based on your project repository updates (GitHub, GitLab, Bitbucket, etc.), including:
  - Public repository creation
  - Top-level schematic
  - Defined inputs/outputs, constraints
  - Description and simulation of new components
  - Complete Vivado project
  - VHDL coding style
  - README, poster, demo video, and responses to questions

  > Goal: Avoid last-minute uploads of high-quality code that students don’t understand.

- **Use of Components:**  
  Use the standard lab components: `bin2seg`, `counter`, `clk_en`, `debouncer`, `display_driver`, etc.

- **Short Demo Video:**  
  Demonstrate that your project works correctly and explain key design aspects in 1–3 minutes (short and focused) video.

- **Project Defense / Poster Session:**  
  Public poster sessions during the last week of the semester (dates announced separately). Poster must be at least A3 size.

- **Team Points:**  
  By default, all team members receive the same points. Teams may propose a different distribution if a member did little or no work.

- **Points & Passing:**
  - Maximum points: **10**
  - Minimum points required to pass: **5**

### Proposed schedule (5x 2 hours)

- **Lab 1: Architecture.** Block diagram design, role assignment, Git initialization, `.xdc` file preparation.

- **Lab 2: Unit Design.** Development of individual modules, testbench simulation, Git updates.

- **Lab 3: Integration.** Merging modules into the Top-level entity, synthesis, and initial HW testing, Git updates.

- **Lab 4: Tuning.** Debugging, code optimization, and Git documentation.

- **Lab 5: Defense.** Completion, video demonstration of the functional device, poster presentation, and code review.

### Documentation requirements (README.md)

Each project repository must include:
*   **Problem Description:** Brief overview of the project content in Czech, Slovak, or English.
*   **Block Diagram:** Graphical representation of module hierarchy and signal flows.
*   **Git Flow:** Commit history demonstrating the activity of team members.
*   **Simulations:** Screenshots from the Vivado simulator (Waveforms) proving new module functionality.
*   **Resource Report:** A table of resource utilization (LUTs, FFs) after synthesis.
*   **Vivado Project:** A complete Vivado 2025.2 project.
*   **Other Outputs:** A3 poster, link to short video, list of used references and tools.

---

## 2. Project summary table (2025/26)

| Project | Students | VHDL | Time | Peripherals (Nexys A7) | Required Module(s) |
| :--- | :---: | :---: | :---: | :--- | :--- |
| **1. PWM Breathing LED** | 2 | 2 | 2 | 16x LED, 1x Switch | Counter |
| **2. Waveform Gen (Basic)** | 2–4 | 3 | 4 | 16x LED, Buttons | Counter, Debouncer |
| **3. Digital Stopwatch (Lap)** | 2–3 | 3 | 3 | 8x 7-seg, Buttons | Counter, Debouncer |
| **4. Multi-mode Counter** | 2–3 | 4 | 3 | 8x 7-seg, Switches | Counter |
| **5. RGB Mood Lamp** | 2 | 2 | 2 | RGB LED, Buttons | Debouncer |
| **6. Digital Safe** | 2–3 | 3 | 4 | Switches, 7-seg, Buttons | Debouncer |
| **7. LED Ping-Pong** | 3–4 | 4 | 5 | 16x LED, Buttons | Debouncer |
| **8. Config. Waveform Gen** | 3–4 | 5 | 5 | 7-seg (Menu), Buttons | Counter, Debouncer |
| **9. 7-segment Snake** | 3–4 | 4 | 5 | 8x 7-seg, Buttons | Debouncer, Counter |
| **10. Alarm Clock** | 2–3 | 3 | 4 | 7-seg, Buttons, Buzzer | Debouncer |
| **11. UART Tx/Rx with FIFO** | 3–4 | 4 | 5 | USB-UART Bridge | Counter |
| **12. Multi-channel PWM/Servo** | 2–3 | 3 | 3 | Servos (Pmod), LED | Counter |
| **13. Ultrasound HS-SR04** | 2–3 | 3 | 4 | HS-SR04 (Pmod), 7-seg | Counter, Debouncer |
| **14. Audio Visualizer (PDM)** | 2–3 | 3 | 4 | MEMS Mic, 16x LED | Counter |
| **15. ADC & Signal Filtering** | 3–4 | 4 | 5 | XADC, 7-seg/LED | Counter |
| **16. Custom I2C/SPI Design** | 3–4 | 5 | 5 | Pmod sensors | - |
| **17. I2C Thermostat Driver** | 3–4 | 4 | 4 | ADT7420 (I2C), 7-seg | I2C, Debouncer |
| **18. Neopixel LED Display** | 2–3 | 4 | 4 | Neopixel LED strip, Buttons | PWM, Shift Register, Debouncer |
| **19. VGA Graphics Demo** | 3–4 | 5 | 5 | VGA port, Buttons | Counter, Sync Generator, FSM, Debouncer |
| **20. Ethernet Packet Sender** | 3–4 | 5 | 5 | Ethernet PHY, LEDs | SPI/MAC, FIFO, FSM |

*Difficulty Rating: 0 = lowest, 5 = highest.*

---

## 3. Detailed project descriptions

### 3.1. PWM Breathing LED
Create a module that smoothly changes LED brightness by generating a triangle waveform for the PWM duty cycle, simulating “inhale” and “exhale.”

### 3.2. Waveform Generator
Generate multiple waveform types and integrate them into a complete generator. Each student implements one waveform while coordinating output selection and timing.

### 3.3. Digital Stopwatch (Lap)
Measure time to hundredths of a second and display current and lap times on 7-segment displays, using a clock divider and registers to store laps.

### 3.4. Multi-Mode Counter
Design a counter with modes such as Decimal, Hexadecimal, and scrolling text. Implement mode switching and reset controls using switches and buttons.

### 3.5. RGB Mood Lamp
Produce smooth color transitions and allow manual adjustment of speed and brightness. Control the RGB LED with multiple PWM channels for each color.

### 3.6. Digital Safe / Combination Lock
Implement a 4-digit code entry system with visual feedback. Store entered codes in registers and compare to the preset combination to indicate success or failure.

### 3.7. LED Ping-Pong
Simulate a bouncing ball with LEDs moving left and right. Update the ball’s position based on button presses and flash LEDs when the player misses.

### 3.8. Configurable Waveform Generator
Generate waveforms with adjustable amplitude, frequency, and type. Use buttons to set parameters and display current settings on LEDs and 7-segment displays.

### 3.9. 7-segment Snake
Implement a snake game on 7-segment displays. Track snake position and length, generate food randomly, and update the score as the snake grows.

### 3.10. Alarm Clock
Build a 24-hour clock with alarm functionality. Keep time using counters and indicate current time and alarm status on 7-segment displays.

### 3.11. UART Controller with FIFO
Create a UART interface for PC communication, including transmit and receive logic with FIFO buffering to handle asynchronous data smoothly.

### 3.12. Multi-channel PWM / Servo Controller
Generate independent PWM signals to control multiple LEDs and servo motors. Scale duty cycles to adjust LED brightness and servo angles.

### 3.13. Ultrasound HS-SR04
Measure distances using an ultrasonic sensor and display results on 7-segment displays. Trigger the sensor, measure echo duration, and calculate distance.

### 3.14. Audio Visualizer (PDM)
Display audio signal intensity on LEDs in real time. Sample the audio input and convert amplitude levels into LED output.

### 3.15. ADC & Signal Filtering
Digitize analog inputs and stabilize the readings using digital filtering. Implement filters such as moving average or low-pass to smooth the data.

### 3.16. Custom I2C/SPI Design
Integrate a custom Pmod sensor by implementing a hardware driver and processing unit. Handle communication via SPI or I2C and organize sensor data in registers.

### 3.17. I2C Thermostat Driver
Read temperature via I2C and display it on 7-segment displays, updating LEDs to indicate whether heating or cooling is active.

### 3.18. Neopixel LED Display
Drive an addressable Neopixel LED strip to create visual effects. Use PWM and shift registers, and allow user interaction via buttons for pattern or brightness selection.

### 3.19. VGA Graphics Demo
Generate graphics on a VGA monitor and implement interactive elements. Create horizontal and vertical sync signals and map patterns to RGB outputs.

### 3.20. Ethernet Packet Sender
Send and receive Ethernet packets using an external PHY. Implement packet framing and buffering, and indicate activity using LEDs.

---

## 4. Help

* **Never, ever** use `rising_edge` or `falling_edge` to test edges of non-clock signals under any circumstances!

* Use hierarchical design, ie. instances, top-level, several files, etc.

* In a synchronous process, the first thing to do is the test of clock rising edge, then synchronous reset. The only exception is asynchronous operations (but avoid them).

* LATCHes indicate errors. Always verify in the **Report after synthesis**.

* Use only input `in` or output `out` ports and not ~~inout~~.

* Use `wait` statements [only in simulations](https://www.vhdl-online.de/courses/system_design/vhdl_language_and_syntax/sequential_statements/wait_statement), never use in actual design.

* Use the TclConsole command `reset_project` before committing to Git.

* Be careful with external connections. Pmod voltage levels are 0--3.3 V!

* Always simulate new components before using them. Rough guideline: 20% of time writing the design, 80% writing testbenches, simulating, verifying.
