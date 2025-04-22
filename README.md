# Design and Verification

This repository contains UVM-based verification environments for multiple IP blocks and MIPS Processor.
- **HTAX (High Throughput) Interface**
- **SPI (Serial Peripheral Interface)**
- **YAPP ROUTER (Yet Another Packet)**

The verification environment is built using UVM (Universal Verification Methodology) for verifying HTAX, SPI and Router Design interfaces.
For Yapp, only the YAPP interface was added, but the design contains Router Design, HBUS, CLOCK, andCHANNELS components.

- **5-Stage Pipelined MIPS Processor**

It includes key components like the ALU, Control Unit, Register File, Data Path, Forwarding Unit and Hazard Detection Unit to manage operations, instruction flow, and resolve hazards using data forwarding.  
A Testbench is also provided to validate the functionality of R-type, J-type, and I-type instructions.

# Proximity Aware MESI

This sub-project implements a proximity-aware extension of the MESI cache coherence protocol. It includes:

- A 4-core cache coherence system
- MESI + proximity-based data forwarding logic
- Benchmark evaluation scripts and simulation testbenches

 Directory includes RTL, testbenches, and result logs.

# ALU Cocotb ML Verification

This project integrates machine learning with functional verification using Cocotb:

- Uses DPI-C to call the model during simulation
- A machine learning model (Random Forest) is trained on RTL simulation outputs.
- The trained model predicts whether the ALU output for a given input transaction
