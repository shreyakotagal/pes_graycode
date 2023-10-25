# pes_graycode
## GRAY CODE COUNTER
## Introduction
Gray code counter is a digital counter that counts such that each successive bit patterns differs by only one bit. Unlike normal counters, there are no glitches in the count pattern (0 -> 1 -> 3 -> 2 -> 6 -> 7 ......... ). Since switching is less in gray code counters (i.e., exactly one-bit switches in one clock cycle), the power consumption of the gray code counter is significantly less compared to the normal counter. Gray code counters, renowned for their unique counting sequence, find extensive use in applications where precise and reliable transitions are imperative, making them an ideal choice for tasks ranging from error detection to robotic navigation.

## Applications of Gray counter 

* Rotary Encoders: Gray code counters are commonly used in rotary encoders to accurately track position changes, providing glitch-free and precise position readings.
* Digital-to-Analog Converters (DACs): Gray code counters are employed in DACs to generate smooth and glitch-free analog output voltages, ensuring high-quality signal generation.
* Robotics and Automation: Gray code counters help control systems in robotics and automation for precise positioning and controlled movements, reducing errors and improving accuracy.
* Error Detection: Gray code sequences are utilized for error detection in communication systems, making them valuable for maintaining data integrity in critical applications.
* Maze Solving Algorithms: Gray code sequences are used in maze-solving algorithms for systematic navigation through complex mazes, facilitating efficient path planning and exploration.

## History about Gray Counters

Gray code counters are named after Frank Gray, an American physicist, and engineer who is credited with inventing Gray codes. Frank Gray developed the Gray code as a binary numeral system that avoids the problems of glitches during counting. Gray codes are named in his honor, and as a result, any counters or systems that use this code for counting are referred to as Gray code counters. Frank Gray's work in this area significantly contributed to the field of digital electronics and error-resistant counting systems

## Simulation 

Tools require for simulation:
- **iverilog**
Icarus Verilog is a Verilog simulation and synthesis tool. It operates as a compiler, compiling source code written in Verilog (IEEE-1364) into some target format.
- **gtkwave**
GTKWave is a fully featured GTK+ based wave viewer for Unix, Win32, and Mac OSX which reads LXT, LXT2, VZT, FST, and GHW files as well as standard Verilog VCD/EVCD files and allows their viewing.

To download the above software, run the below commands on your ubuntu terminal 
```
sudo apt-get install git 
sudo apt-get install iverilog 
sudo apt-get install gtkwave
```

To run the simulation, 
```
iverilog pes_graycode.v pes_graycode_tb.v
./a.out
gtkwave pes_graycode.vcd
```
![image](https://github.com/shreyakotagal/pes_graycode/assets/117657204/6c78db68-c589-4398-b79e-678f22c1b67c)

![image](https://github.com/shreyakotagal/pes_graycode/assets/117657204/0624c831-7560-4952-bf03-5e39db7c1a82)

## Synthesis 

Tools required for synthesis:
- **yosys**
The software used to run gate level synthesis is Yosys. Yosys is a framework for Verilog RTL synthesis. It currently has extensive Verilog-2005 support and provides a basic set of synthesis algorithms for various application domains

To install the software,

```
sudo apt-get install build-essential clang bison flex \
   libreadline-dev gawk tcl-dev libffi-dev git \
   graphviz xdot pkg-config python3 libboost-system-dev \
   libboost-python-dev libboost-filesystem-dev zlib1g-dev
```

```
git clone https://github.com/YosysHQ/yosys.git
make
sudo make install 
make test
```
**Running synthesis**

Create a scirpt yosys_run.sh with the following lines
```
read_liberty -lib lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_verilog pes_graycode.v
synth -top pes_graycode	
dfflibmap -liberty lib/sky130_fd_sc_hd__tt_025C_1v80.lib
abc -liberty lib/sky130_fd_sc_hd__tt_025C_1v80.lib
clean
flatten
write_verilog -noattr pes_graycode_synth.v
stat
show
```
In the design file folder, run terminal and run the following command 

`` yosys -s yosys_run.sh ``

![image](https://github.com/shreyakotagal/pes_graycode/assets/117657204/04e6aabb-38cd-463f-aa0e-a7a27cb66719)

![image](https://github.com/shreyakotagal/pes_graycode/assets/117657204/4b93087e-c07b-44dd-89cb-4d27d651ee0b)

## Gate Level Simulation (GLS)

When we write the RTL code, we test it by giving it some stimulus through the testbench and check it for the desired specifications. 
Similarly, we run the netlist as the design under test (dut) with the same testbench. 
Gate level simulation is done to verify the logical correctness of the design after synthesis.

```
iverilog pes_graycode.v pes_graycode_tb.v primitives.v sky130_fd_sc_hd.v
./a.out
gtkwave pes_graycode.vcd
```

![image](https://github.com/shreyakotagal/pes_graycode/assets/117657204/53fe2d60-07e9-404b-86af-e47d155aa7a8)

![image](https://github.com/shreyakotagal/pes_graycode/assets/117657204/7b2851f8-4da9-4e18-871a-0efb819822b4)

At the first positive edge of the clock, the counter resets to 0x00. From the second clock onwards, the counter starts to count in gray code sequence.
