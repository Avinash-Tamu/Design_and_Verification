# Design and Verification

This repository contains UVM-based verification environments for multiple IP blocks and MIPS Processor.
- **HTAX (High Throughput) Interface**
- **SPI (Serial Peripheral Interface)**
- **YAPP ROUTER (Yet Another Packet)**

The verification environment is built using UVM (Universal Verification Methodology) for verifying HTAX, SPI and Router Design interfaces.
For Yapp, only the YAPP interface was added, but the design contains Router Design, HBUS, CLOCK, andCHANNELS components.

- **5-Stage Pipelined MIPS Processor** 
It includes key components like the ALU, Control Unit, Register File, Data Path, and Hazard Detection Unit to manage operations, instruction flow, and resolve hazards. 
A Testbench is also provided to validate the functionality of R-type, J-type, and I-type instructions.


