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

## Creating custom cell

On doing the following commands:

```
git clone https://github.com/nickson-jose/vsdstdcelldesign.git
cd vsdstdcelldesign
cp ./libs/sky130A.tech sky130A.tech
magic -T sky130A.tech sky130_inv.mag &
```
The following netlist will open:

![image](https://github.com/shreyakotagal/pes_graycode/assets/117657204/138fb8bd-6b77-4f44-92e8-11695c84a4b8)

Now, to extract the spice netlist, type the following commands in the tcl console. Here, parasitic capacitances and resistances of the inverter is extracted by cthresh 0 rthresh 0.
```
extract all
ext2spice cthresh 0 rthresh 0
ext2spice
```
The extracted spice model is shown:
```
* SPICE3 file created from sky130_inv.ext - technology: sky130A

.option scale=0.01u
.include ./libs/pshort.lib
.include ./libs/nshort.lib


M1001 Y A VGND VGND nshort_model.0 ad=1435 pd=152 as=1365 ps=148 w=35 l=23
M1000 Y A VPWR VPWR pshort_model.0 ad=1443 pd=152 as=1517 ps=156 w=37 l=23
VDD VPWR 0 3.3V
VSS VGND 0 0V
Va A VGND PULSE(0V 3.3V 0 0.1ns 0.1ns 2ns 4ns)
C0 Y VPWR 0.08fF
C1 A Y 0.02fF
C2 A VPWR 0.08fF
C3 Y VGND 0.18fF
C4 VPWR VGND 0.74fF


.tran 1n 20n
.control
run
.endc
.end
```
![image](https://github.com/shreyakotagal/pes_graycode/assets/117657204/2d9dba61-2cb0-4e52-84ca-2cfea24ec01f)

![image](https://github.com/shreyakotagal/pes_graycode/assets/117657204/e256a1ea-3fc1-45c1-b853-f12425f2d773)

![image](https://github.com/shreyakotagal/pes_graycode/assets/117657204/e62feb50-cf63-4bcd-a236-689be4ba8ffc)

In Magic Layout window, first source the .mag file for the design (here inverter). Then Edit >> Text which opens up a dialogue box. Then do the steps shown in the below figure.

![image](https://github.com/shreyakotagal/pes_graycode/assets/117657204/5d3d95ee-256f-4006-8ca6-134b98dc83ac)
![image](https://github.com/shreyakotagal/pes_graycode/assets/117657204/eea6e0c2-2318-486c-af1b-681934f22a37)
![image](https://github.com/shreyakotagal/pes_graycode/assets/117657204/89da550f-2f04-412a-a183-6fd90f2ec555)
![image](https://github.com/shreyakotagal/pes_graycode/assets/117657204/766173ea-4e4c-449c-b1a2-2508a43f8c72)

To extract the lef file and save it,
```
lef write
```
![image](https://github.com/shreyakotagal/pes_graycode/assets/117657204/f85a67ae-a76a-4b85-a2b3-01d02e68e5d1)


## Physical Design 
### Preparation for Openlane
Navigate to `OpenLane/designs/pes_gray` and then create the `config.json`

```
{
    "DESIGN_NAME": "iiitb_gc",
    "VERILOG_FILES": "dir::src/iiitb_gc.v",
    "CLOCK_PORT": "clkin",
    "CLOCK_NET": "clkin",
    "GLB_RESIZER_TIMING_OPTIMIZATIONS": true,
    "CLOCK_PERIOD": 65,
    "PL_TARGET_DENSITY": 0.7,
    "FP_SIZING" : "relative",
    "pdk::sky130*": {
        "FP_CORE_UTIL": 30,
        "scl::sky130_fd_sc_hd": {
            "FP_CORE_UTIL": 20
        }
    },
    
    "LIB_SYNTH": "dir::src/sky130_fd_sc_hd__typical.lib",
    "LIB_FASTEST": "dir::src/sky130_fd_sc_hd__fast.lib",
    "LIB_SLOWEST": "dir::src/sky130_fd_sc_hd__slow.lib",
    "LIB_TYPICAL": "dir::src/sky130_fd_sc_hd__typical.lib",  
    "TEST_EXTERNAL_GLOB": "dir::/src/*"

}
```
![image](https://github.com/shreyakotagal/pes_graycode/assets/117657204/53e0514a-e481-4ab4-8c01-2db711ae8e4e)

![image](https://github.com/shreyakotagal/pes_graycode/assets/117657204/60b53b7a-ed5a-4bc4-9221-e42afcc1097a)

To start OpenLane and prepare the design, use the following commands
```
cd OpenLane
make mount
./flow.tcl -interactive
prep -design pes_gray
set lefs [glob $::env(DESIGN_DIR)/src/*.lef]
add_lefs -src $lefs
```
![image](https://github.com/shreyakotagal/pes_graycode/assets/117657204/8052b319-cf48-414f-b057-fc0ab1a4cb3f)

### Run Synthesis
Now, to run synthesis, type the following command in Openlane
```
run_synthesis
```
![image](https://github.com/shreyakotagal/pes_graycode/assets/117657204/eaeba898-b68a-419b-946c-399065ff5c15)

![image](https://github.com/shreyakotagal/pes_graycode/assets/117657204/1b4749e5-8b37-4e12-a48f-df8b2a632a2f)

### Run Floorplan
Next step is to run floorplan with the following command
```
run_floorplan
```
![image](https://github.com/shreyakotagal/pes_graycode/assets/117657204/9266bbf1-4785-4d7f-b490-c6cfa2c70a6a)

![image](https://github.com/shreyakotagal/pes_graycode/assets/117657204/8339983f-4c0d-4d04-b503-ecedae4d9a38)
![image](https://github.com/shreyakotagal/pes_graycode/assets/117657204/b98d031a-96c6-4469-aca8-0d58fdbb8398)
![image](https://github.com/shreyakotagal/pes_graycode/assets/117657204/856c5e0b-3d37-4003-899d-89f918b1ee6d)

![image](https://github.com/shreyakotagal/pes_graycode/assets/117657204/ed78af39-e645-456a-a66b-c0561cded247)

### Run Placements
The placement can be viewed by typing the following command.
```
run_placement
```
The placement can be viewed by typing the following command.
```
magic -T /home/shreya/Desktop/OpenLane/pdks/volare/sky130/versions/44a43c23c81b45b8e774ae7a84899a5a778b6b0b/sky130
```
![image](https://github.com/shreyakotagal/pes_graycode/assets/117657204/0e5b2921-12e5-4efc-abef-78b5eb307fc3)
![image](https://github.com/shreyakotagal/pes_graycode/assets/117657204/46870ac9-d387-4efc-ac66-3f67cc08758e)
![image](https://github.com/shreyakotagal/pes_graycode/assets/117657204/98db48dd-171e-4c64-8815-8e0549ff8fa4)
![image](https://github.com/shreyakotagal/pes_graycode/assets/117657204/5cc96f03-cae6-41f9-a86f-725b50ce1e75)
This can also be viewed in pes_gray.def
![image](https://github.com/shreyakotagal/pes_graycode/assets/117657204/4f6db8c3-ca61-4059-b89e-7081aba25a03)

### Clock Tree Synthesis 
The next step is to run run clock tree synthesis. The CTS run adds clock buffers in therefore buffer delays come into picture and our analysis from here on deals with real clocks. To run clock tree synthesis, type the following commands
```
run_cts
```
The netlist with clock buffers can be viewed by going to the location results\cts\pes_gray.v
Also, sta report post synthesis can be viewed by going to the location logs\synthesis\16-cts.log
![image](https://github.com/shreyakotagal/pes_graycode/assets/117657204/ae491fab-0c1c-4e0a-a6d4-43a541f6b6f9)

![image](https://github.com/shreyakotagal/pes_graycode/assets/117657204/764c1399-3ed6-4485-80e1-35b698123aba)


### Run Routing
The command to run routing is
```
run_routing
```
![image](https://github.com/shreyakotagal/pes_graycode/assets/117657204/57f4e4cc-e20e-463b-a709-f34df3f5ae46)

![image](https://github.com/shreyakotagal/pes_graycode/assets/117657204/628baee9-a267-4502-bc91-1e05673e711f)

To view the dimenstions, use the `box` command.
![image](https://github.com/shreyakotagal/pes_graycode/assets/117657204/d097e7ef-648d-4169-98c4-747e903903bc)
