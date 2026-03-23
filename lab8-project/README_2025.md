# VHDL project 2025

1. Digital clock with alarm and stopwatch or Digital scoreboard with timer for your preferred sport
2. Complete UART Tx/Rx controller with configurable frame structure and baudrate and FIFO buffer
3. Configurable multi-channel Pulse Width Modulation (PWM) for LED brightness control or Servo motor(s) controller (SG90)
4. Ultrasound sensor(s) controller (HS-SR04)

Advanced:
1. Usage of ADC (Analog-to-digital converter), signal filtration
2. Custom I2C controller design and demo of I2C communication
3. Custom SPI controller design and demo of SPI communication

## Instructions

*The goal of this project is for small teams of 3-4 students to explore a chosen topic, use the labs's components, develop solutions, simulate and implement them, create documentation, and present the results. Team members will organize and divide tasks among themselves.*

* The students will work on the project for five weeks, ending with a presentation and a practical demonstration (simulations alone are not enough), see the course schedule in e-learning.

* The FPGA code must be written in VHDL and must be implementable on the [Nexys A7-50T board](https://digilent.com/reference/programmable-logic/nexys-a7/reference-manual) using the development tools provided during the semester, specifically Vivado.

   ![nexys_a7](images/nexys-a7.png)

* Physical implementation on FPGA is necessary, not just computer simulation.

* Use components created during the semester. Provide detailed simulation testbenches for all your new components.

* Follow coding standards in your codes.

* Strictly follow licenses for third-party libraries/codes !

* Follow ethical rules regarding plagiarism, licensing, and policies for the use of [generative artificial intelligence](https://www.vut.cz/vut/aktuality-f19528/vut-vydalo-zasady-a-doporuceni-k-vyuzivani-generativni-umele-inteligence-d247152).

* Create a public [GitHub](https://github.com/) (or any other online software development platform) repository for your project and publish all files here.

* Provide a list of all tools used during the project, including Machine Learning (some are listed [here](https://github.com/tomas-fryza/avr-course/wiki)).

* A PowerPoint-style presentation is not required; a good A3 poster or `README.md` on GitHub is sufficient.

* During the presentation, you can play a short video (max 1 minute) with subtitles or explanatory captions.

## Help

* **Never, ever** use `rising_edge` or `falling_edge` to test edges of non-clock signals under any circumstances!

* Use hierarchical design, ie. instances, top-level, several files, etc.

* Use synchronous entities with rising edge of `clk`.

* In a synchronous process, the first thing to do is the test of clock edge, then synchronous reset. The only exception is asynchronous operations (try to avoid them).

* Use only input `in` or output `out` ports and not ~~inout~~.

* Use `wait` statements [only in simulations](https://www.vhdl-online.de/courses/system_design/vhdl_language_and_syntax/sequential_statements/wait_statement).

* Except Vivado, we encourage the use of other tools as well:
   * [EDA Playground](https://www.edaplayground.com/)
   * [TerosHDL](https://github.com/tomas-fryza/vhdl-course/wiki/How-to-install-TerosHDL-on-Windows-and-Linux)
   * [ghdl + GtkWave](https://github.com/tomas-fryza/vhdl-course/wiki/How-to-install-ghdl-on-Windows-and-Linux)
   * [ModelSim](https://www.intel.com/content/www/us/en/software-kit/750666/modelsim-intel-fpgas-standard-edition-software-version-20-1-1.html)
   * [Live Share](https://code.visualstudio.com/learn/collaboration/live-share), a Visual Studio Code plugin for a real-time collaborative development
   * [other tools](https://github.com/tomas-fryza/vhdl-course/wiki)

# Recommended README.md file structure

### Team members

* Member 1 (responsible for ...)
* Member 2 (responsible for ...)
* Member 3 (responsible for ...)
* Member 4 (responsible for ...)

### Abstract

An abstract is a short summary of your project, usually about a paragraph (6-7 sentences, 150-250 words) long. A well-written abstract serves multiple purposes: (a) an abstract lets readers get the gist or essence of your project quickly; (b) an abstract prepares readers to follow the detailed information, description, and results in your report; (c) and, later, an abstract helps readers remember key points from your project.

The main contributions of the project are:

* ...
* ...
* ...

[Photo(s) of your application with labels of individual parts.]

[Link to A3 project poster.]

[Optional: Link to your short video presentation.]

## Hardware description of demo application

Describe your implementation. Put a descriptive top-level schematic of your application.

## Software description

Put flowchats/state diagrams of your algorithm(s) and direct links to source/testbench files in `src` and `sim` folders.

### Component(s) simulations

Write descriptive text and put simulation screenshots of components you created during the project.

## References

1. Put here the references and online tools you used.
2. ...

### Topics 2023/24

### Some examples of previous projects

* [Tone generator](https://github.com/VojtaKudela/BPC-DE1-topic_4/blob/main/README.md)
* [PWM servo](https://github.com/Th0rgrlm/Topic3-PWM-Based-Servo-Motor-Controller/blob/main/README.md)
* [Ultrasonic parking spot detection](https://github.com/247828/BPC-DE1-Project/blob/main/README.md)
* [VGA](https://github.com/deved9/DE1-project)

**Topic 1: Smart Parking System with Ultrasonic Sensors**

Description: Design and implement a smart parking system using VHDL on the Nexys A7 FPGA board. The system will utilize multiple ultrasonic sensors (HS-SR04) connected to the Pmod connectors for detecting the presence and distance of vehicles within parking spaces. Develop algorithms to analyze sensor data and determine parking space availability. Visualize parking space occupancy status using LEDs, while displaying distance measurements on the 7-segment display.

![ultrasonic-resistors](images/ultrasonic_resistors.jpg)
![ultrasonic-shifters](images/ultrasonic_level-shifters.jpg)

**Topic 2: Relay-Controlled Sound Synthesizer**

Description: Develop and implement a sound synthesizer utilizing relays on the Nexys A7 FPGA board. Rather than generating audio signals directly, the system employs relays connected to Pmod connectors to produce audible sounds by managing the activation and deactivation of relay switches. Users can compose and play basic melodies by programming the relay sequences. Push buttons will serve as controls for play, stop, and song navigation, while LEDs and a 7-segment display will provide visualization of the melody and information about the songs.

![relay-foto](images/2-channel-relay_description.jpg)
![relay-schematic](images/2-channel-relay_schematic.jpg)

**Topic 3: PWM-Based Servo Motor Controller**

Description: Develop a PWM-based servo motor controller using VHDL on the Nexys A7 FPGA board. Utilize the FPGA's PWM output capability to generate signals for controlling multiple independent servo motors connected to the Pmod connectors. Implement algorithms to adjust the angle of the servo motors based on user input received from buttons or switches. LEDs will offer visual feedback on the servo position or controller status.

![servo](images/servo_power.png)

**Topic 4: PWM-Based Tone Generator**

Description: Develop a tone generator using PWM on the audio jack connector of the Nexys A7 FPGA board to produce simple musical tones or melodies. Users will be able to adjust parameters such as frequency and duration using buttons or switches. LEDs will offer visual indication of the currently generated tone.

**Topic 5: Implementation of Basic Ciphers**

Description: This project aims to demonstrate various simple ciphers, such as the Vernam Cipher, Caesar Cipher, Atbash Cipher, and potentially others, using basic logic gates and flip-flops on the Nexys A7 FPGA board. Each cipher enabling users to input plaintext messages and observe the resulting ciphertext generated by the encryption process. Buttons and switches can serve as input devices for users to input plaintext messages and control the encryption/decryption process. LEDs can provide visual feedback on the status of the encryption/decryption process, indicating *ready to receive input*, *encryption/decryption in progress*, and *complete*. The 7-segment display shows the ciphertext or plaintext output.

**Advanced Topic 1: Digital Voltmeter with Voltage Data Logging**

Description: This project involves the development of a digital voltmeter using VHDL on the Nexys A7 FPGA board to accurately measure and log voltage levels. The system will interface with analog-to-digital converters (ADC) via the Pmod connectors to sample voltage signals from external sources. The measured voltage will be displayed in real-time on the 7-segment display for user visualization. LEDs will provide visual feedback on the measurement status or indicate voltage thresholds. Additionally, the system can log the voltage data to an external memory device for future analysis.

**Advanced Topic 2: VGA Image Rendering and Manipulation**

Description: This project involves the development of generating images using VGA output on the Nexys A7 FPGA board. The system will implement algorithms for image rendering and manipulation, enabling the creation of basic shapes, patterns, and color gradients. It will adhere to VGA timing specifications for pixel generation and synchronization, ensuring compatibility with standard VGA displays.
