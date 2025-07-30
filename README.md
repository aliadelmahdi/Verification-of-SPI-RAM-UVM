# SPI Wrapper Verification Project

This project implements the **functional verification** of a fully integrated SPI (Serial Peripheral Interface) system, composed of:

  * **SPI Slave**
  * **Single-Port Synchronous RAM**
  * **Golden Reference Model**
  * **UVM-Based Testbench**
  * **SystemVerilog Assertions**
  * **Functional & Code Coverage Reports**

The original RTL design was developed by [Youssif-Amed Youssif](https://github.com/Youssif-Amed/SPI-Interface-Project) — full credit for the design goes to him. This repository extends that project by thoroughly verifying its behavior using modern verification methodologies and DPI-C integration with C++.

-----

## Repository Structure

Here's an overview of the file structure for design and verification components:

```
├── design/
│   ├── SPI_Assertions/
│   │   ├── SPI_ram_sva.sv
│   │   └── SPI_slave_sva.sv
│   └── SPI_design/
│       ├── Designer RTL/
│       │   ├── SPI_ram.v
│       │   ├── SPI_slave.v
│       │   └── design.v
│       └── Golden Models/
│           ├── dpi_golden_model.sv
│           ├── golden_models.sv
│           ├── ram_golden_model.sv
│           └── spi_sys_golden_model.sv
├── interface/
│   ├── SPI_if.sv
│   ├── shared_pkg.sv
│   └── spi_defines.svh
├── top/
│   ├── test/
│   │   ├── SPI_test_base.sv
│   │   ├── SPI_test_pkg.sv
│   │   └── enviroment/
│   │       ├── SPI_env.sv
│   │       ├── SPI_env_pkg.sv
│   │       ├── coverage_collector/
│   │       │   └── SPI_coverage_collector.sv
│   │       ├── ram_agent/
│   │       │   ├── SPI_ram_agent.sv
│   │       │   ├── SPI_ram_pkg.sv
│   │       │   ├── driver/
│   │       │   │   └── SPI_ram_driver.sv
│   │       │   ├── monitor/
│   │       │   │   └── SPI_ram_monitor.sv
│   │       │   └── sequencer/
│   │       │       └── SPI_ram_sequencer.sv
│   │       ├── scoreboard/
│   │       │   └── SPI_scoreboard.sv
│   │       └── slave_agent/
│   │           ├── SPI_slave_agent.sv
│   │           ├── SPI_slave_pkg.sv
│   │           ├── driver/
│   │           │   └── SPI_slave_driver.sv
│   │           ├── monitor/
│   │           │   └── SPI_slave_monitor.sv
│   │           └── sequencer/
│   │               └── SPI_slave_sequencer.sv
│   └── top.sv
```

-----

## Getting Started

### 1\. Clone the Repository

```bash
git clone https://github.com/aliadelmahdi/Verification-of-SPI-RAM-UVM.git
cd SPI-Wrapper-Verification
```

> **Note:** Ensure you also check out the original design repo:
> [https://github.com/Youssif-Amed/SPI-Interface-Project](https://github.com/Youssif-Amed/SPI-Interface-Project)

-----

### 2\. Prerequisites

You must have **QuestaSim** installed and properly configured in your environment path. This project has been tested using **QuestaSim 2021+**.

-----

## Running the Simulation

### On **Linux**:

```bash
./run.sh
```

### On **Windows**:

```bash
run.bat
```

### To Enable GUI Mode:

Both the Linux and Windows run files execute in command-line mode by default. To enable GUI (graphical interface):

  * Edit `run.sh` or `run.bat`
  * **Remove** the `-c` option from the `vsim -do run.tcl -c` line

<!-- end list -->

```sh
# Change this:
vsim -c -do "scripts/run.tcl"

# To this:
vsim -do "scripts/run.tcl"
```

-----

## Verification Methodology

This project follows the **UVM (Universal Verification Methodology)** and includes:

  * **Agents** for both SPI slave and RAM
  * **UVM sequences** and configuration objects
  * **Scoreboard** and **coverage collectors**
  * **Golden Model** comparison using **DPI-C + C++**
  * **Assertion-Based Verification (ABV)** for protocol checks

The UVM Testbench Architecture:

<p align="center">
  <img width="565" height="644" alt="UVM Testbench Architecture" src="https://github.com/user-attachments/assets/e67ea49f-134c-42aa-9d96-1a2020712847" />
</p>

-----

## Assertions

Assertions follow a **structured and traceable format**, each mapped to the corresponding item in the **Verification Plan**.

Assertions cover:

  * **FSM transitions**
  * **Signal values in each state**
  * **Serial-to-parallel & parallel-to-serial conversions**
  * **Slave behavior during read/write**
  * **SPI protocol compliance**

-----

## Verification Plan

A complete **Verification Plan** is included. Each item in the plan is covered through directed sequences, assertions, and functional coverage.

-----

## Coverage Reports

  * **Functional Coverage** is monitored through custom coverage collectors.
  * **Code Coverage** is automatically captured by QuestaSim.

Reports are automatically generated in HTML format for easy navigation and visualization. After simulation, open the `coverage_report/index.html` in your browser to view results.

-----

## About the Author

This verification effort was developed by **Ali Adel**, who designed, built, and integrated the full testbench environment.

Key contributions include:

  * Designing the entire **UVM-based environment**
  * Creating the **assertion suite**
  * Building the **Golden Reference Model**
  * Integrating **DPI-C with C++ backend**
  * Generating coverage reports

-----

## Contact

For questions, feedback, or collaboration:

  * Email: [aliadelmahdi77@gmail.com](mailto:aliadelmahdi77@gmail.com)
  * Linkedin: [linkedin.com/aliadelmahdi](https://www.linkedin.com/in/aliadelmahdi)
-----
