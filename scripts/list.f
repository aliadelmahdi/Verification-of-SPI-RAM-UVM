# interface/
# │── spi_defines.svh
# │── shared_pkg.sv
# │── SPI_if.sv
#
# design/SPI_design/
# │── golden_model.sv
# │── SPI_Ram.v
# │── SPI_Slave.v
#
# design/SPI_Assertions/
# │── SPI_slave_sva.sva
#
# objects/
# │── SPI_config.sv
# │
# ├── slave_objects/
# │   │── SPI_slave_seq_item.sv
# │   │── SPI_slave_main_sequence.sv
# │   │── SPI_slave_reset_sequence.sv
# │
# ├── ram_objects/
# │   │── SPI_ram_seq_item.sv
# │   │── SPI_ram_main_sequence.sv
# │   │── SPI_ram_reset_sequence.sv
#
# top/test/enviroment/
# │── SPI_env.sv
# │── scoreboard/SPI_scoreboard.sv
# │── coverage_collector/SPI_coverage_collector.sv
# │
# ├── slave_agent/
# │   │── SPI_slave_agent.sv
# │   │── sequencer/SPI_slave_sequencer.sv
# │   │── driver/SPI_slave_driver.sv
# │   │── monitor/SPI_slave_monitor.sv
# │
# ├── ram_agent/
# │   │── SPI_ram_agent.sv
# │   │── sequencer/SPI_ram_sequencer.sv
# │   │── driver/SPI_ram_driver.sv
# │   │── monitor/SPI_ram_monitor.sv
#
# top/test/
# │── test.sv
#
# top/
# │── top.sv

# List of files for the SPI testbench

# Interface files
interface/spi_defines.svh
interface/shared_pkg.sv
interface/SPI_if.sv

# Design files
"design/SPI_design/Designer RTL/design.v"
"design/SPI_design/Golden Models/golden_models.sv"


# Assertions
design/SPI_Assertions/SPI_slave_sva.sv
design/SPI_Assertions/SPI_ram_sva.sv

# Testbench objects
objects/SPI_config.sv


# Sequences package
objects/slave_objects/SPI_slave_main_sequence_pkg.sv

# Ram objects
objects/ram_objects/SPI_ram_seq_item.sv
objects/ram_objects/SPI_ram_sequences_pkg.sv

# Agents
top/test/enviroment/slave_agent/SPI_slave_pkg.sv
top/test/enviroment/ram_agent/SPI_ram_pkg.sv



# Environment file
top/test/enviroment/SPI_env_pkg.sv

# Test file
top/test/SPI_test_pkg.sv

# Top-level file
top/top.sv

+incdir+./design
+incdir+./design/SPI_Assertions
+incdir+./design/SPI_design
"+incdir+./design/SPI_design/Designer RTL"
"+incdir+./design/SPI_design/Golden Models"
+incdir+./interface
+incdir+./top
+incdir+./top/test
+incdir+./top/test/enviroment
+incdir+./top/test/enviroment/coverage_collector
+incdir+./top/test/enviroment/ram_agent
+incdir+./top/test/enviroment/ram_agent/driver
+incdir+./top/test/enviroment/ram_agent/monitor
+incdir+./top/test/enviroment/ram_agent/sequencer
+incdir+./top/test/enviroment/scoreboard
+incdir+./top/test/enviroment/slave_agent
+incdir+./top/test/enviroment/slave_agent/driver
+incdir+./top/test/enviroment/slave_agent/monitor
+incdir+./top/test/enviroment/slave_agent/sequencer