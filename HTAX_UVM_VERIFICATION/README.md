
# HTAX Protocol Repository

This repository contains the implementation of the HTAX protocol, with design files, testbenches (TB), and simulation files written in the UVM (Universal Verification Methodology) environment. The project focuses on a complete HTAX protocol from scratch, including the combinatorial and outport arbiters, and integrates them into a top-level design for verification and simulation.

## Directory Structure

The repository is organized as follows:

```
work/
├── design/
│   ├── htax_combinatoric_arbiter.v
│   ├── htax_outport_arbiter.v
│   ├── htax_outport_data_mux.v
│   └── htax_top.v
├── sim/
│   ├── compile_elab.f
│   ├── cov_work/
│   ├── imc.log
│   ├── lab_report.pdf
│   ├── ProjectVerificationPlanFall2024.vplanx
│   ├── run.f
│   ├── run_vm.vsif
│   ├── vmgr_merge_logs
│   ├── waves.tcl
│   ├── xrun.history
│   ├── xrun.log
│   ├── cov_conf.ccf
│   ├── file_list.f
│   ├── lab_report.md
│   ├── mdv.log
│   ├── regression/
│   ├── run_vm.f
│   ├── vmanager.log
│   ├── waves.shm
│   ├── xcelium.d
│   └── xrun.key
├── tb/
│   ├── htax_defines.sv
│   ├── htax_pkg.sv
│   ├── htax_rx_interface.sv
│   ├── htax_scoreboard_c.sv
│   ├── htax_top.sv
│   ├── htax_tx_interface.sv
│   ├── htax_virtual_sequencer_c.sv
│   ├── htax_env.sv
│   ├── htax_rx_agent_c.sv
│   ├── htax_rx_monitor_c.sv
│   ├── htax_seqs.sv
│   ├── htax_tx_agent_c.sv
│   ├── htax_tx_monitor_c.sv
│   ├── htax_vseqs.sv
│   ├── htax_packet_c.sv
│   ├── htax_rx_driver_c.sv
│   ├── htax_rx_mon_packet_c.sv
│   ├── htax_sequencer_c.sv
│   ├── htax_tx_driver_c.sv
│   ├── htax_tx_mon_packet_c.sv
│   └── req.txt
└── test/
    ├── base_test.sv
    ├── htax_tests.sv
    ├── multiport_sequential_random_test.sv
    ├── simple_random_test.sv
    └── test_lib.svh
```

### Directory Breakdown

#### `work/`

This is the root directory containing all of the project files.

- **`design/`**: Contains the Verilog design files for the HTAX protocol components.
  - **`htax_combinatoric_arbiter.v`**: The combinatorial arbiter module for the HTAX protocol.
  - **`htax_outport_arbiter.v`**: Arbiter for managing access to the output ports.
  - **`htax_outport_data_mux.v`**: Data multiplexer for the output ports in the HTAX protocol.
  - **`htax_top.v`**: Top-level module integrating all HTAX components.

- **`sim/`**: Contains simulation files used for compiling, elaborating, and running the verification suite.
  - **`compile_elab.f`**: Compilation and elaboration file for the simulation.
  - **`cov_work/`**: Directory for storing coverage results.
  - **`imc.log`**, **`xrun.history`**, **`xrun.log`**: Log files generated during simulation runs.
  - **`waves.tcl`**: Tcl script for generating waveform outputs during simulation.
  - **`ProjectVerificationPlanFall2024.vplanx`**: Verification plan document for the project.
  - **`regression/`**: Contains regression test results and reports.
  - **`run_vm.vsif`**: Simulation environment configuration file.

- **`tb/`**: Contains all the testbench files written in SystemVerilog using UVM.
  - **`htax_defines.sv`**: Defines various constants and parameters used throughout the testbench.
  - **`htax_pkg.sv`**: SystemVerilog package that includes shared utilities and definitions.
  - **`htax_rx_interface.sv`**: Interface for the receiver side of the HTAX protocol.
  - **`htax_tx_interface.sv`**: Interface for the transmitter side of the HTAX protocol.
  - **`htax_scoreboard_c.sv`**: Scoreboard for comparing expected and actual results during simulation.
  - **`htax_sequencer_c.sv`**: UVM sequencer for controlling the sequence of transactions in the testbench.
  - **`htax_env.sv`**: Testbench environment, which includes all agents, monitors, and sequencers.
  - **`htax_rx_agent_c.sv`**, **`htax_tx_agent_c.sv`**: Agents for the receiver and transmitter sides.
  - **`htax_virtual_sequencer_c.sv`**: Virtual sequencer for coordinating different sequencers.
  - **`htax_tests.sv`**: Main test suite that includes different test cases for the HTAX protocol.

- **`test/`**: Contains the top-level test files and additional utilities for running tests.
  - **`base_test.sv`**: Base test class containing common functionality for all tests.
  - **`htax_tests.sv`**: Specific test cases for verifying the HTAX protocol.
  - **`multiport_sequential_random_test.sv`**: Test for verifying random access across multiple ports.
  - **`simple_random_test.sv`**: A simple random test case.
  - **`test_lib.svh`**: Shared test libraries used by various test cases.

#### `setupX.bash` and `setupX.csh`

These are setup scripts for configuring the environment and running the simulation. The `.bash` script is for Bash users, and the `.csh` script is for C shell (csh) users.

- **`setupX.bash`**: Setup script for configuring the environment and running the simulation using Bash.
- **`setupX.csh`**: Setup script for configuring the environment and running the simulation using C shell.

---

## How to Use

### Setup Environment

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/htax_protocol.git
   cd htax_protocol
   ```

2. Run the appropriate setup script based on your shell:
   - For **Bash**:
     ```bash
     source setupX.bash
     ```
   - For **C shell (csh)**:
     ```csh
     source setupX.csh
     ```

### Running the Simulation

1. Navigate to the `sim` directory:
   ```bash
   cd work/sim
   ```

2. Run the simulation using the provided script:
   ```bash
   ./run.f
   ```

   This will compile, elaborate, and run the testbenches.

### Viewing Results

- After the simulation completes, the results can be found in the `sim` directory. You can view coverage reports, logs, and waveform outputs generated during the simulation.
- Waveforms can be viewed using:
  ```bash
  vcs -R -sv +vpi +gui
  ```

---

## Contribution

If you would like to contribute to this project, please fork the repository, create a new branch, and submit a pull request with your changes. Ensure all tests pass before submitting.

---

## License

This repository is licensed under the [MIT License](LICENSE).

---

Feel free to adjust this template based on any additional specifics of your environment or the repository. Let me know if you need further details!
