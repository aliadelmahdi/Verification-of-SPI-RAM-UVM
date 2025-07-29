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
interface/
│── spi_defines.svh
│── shared_pkg.sv
│── SPI_if.sv

design/SPI_design/
│── golden_model.sv
│── SPI_Ram.v
│── SPI_Slave.v

design/SPI_Assertions/
│── SPI_slave_sva.sv
│── SPI_ram_sva.sv

objects/
│── SPI_config.sv
├── slave_objects/
│   ├── SPI_slave_seq_item.sv
│   ├── SPI_slave_main_sequence.sv
│   ├── SPI_slave_reset_sequence.sv
├── ram_objects/
│   ├── SPI_ram_seq_item.sv
│   ├── SPI_ram_main_sequence.sv
│   ├── SPI_ram_reset_sequence.sv

top/test/enviroment/
│── SPI_env.sv
├── scoreboard/
│   ├── SPI_scoreboard.sv
├── coverage_collector/
│   ├── SPI_coverage_collector.sv
├── slave_agent/
│   ├── SPI_slave_agent.sv
│   ├── sequencer/SPI_slave_sequencer.sv
│   ├── driver/SPI_slave_driver.sv
│   ├── monitor/SPI_slave_monitor.sv
├── ram_agent/
│   ├── SPI_ram_agent.sv
│   ├── sequencer/SPI_ram_sequencer.sv
│   ├── driver/SPI_ram_driver.sv
│   ├── monitor/SPI_ram_monitor.sv

top/test/
│── test.sv

top/
│── top.sv
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
