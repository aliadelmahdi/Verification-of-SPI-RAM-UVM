`ifndef SPI_RAM_PKG_SV
`define SPI_RAM_PKG_SV

package SPI_ram_pkg;

    import uvm_pkg::*;
    import shared_pkg::*;
    import SPI_config_pkg::*;
    import SPI_ram_seq_item_pkg::*;
    import SPI_ram_sequences_pkg::*;

    `include "SPI_ram_driver.sv"
    `include "SPI_ram_monitor.sv"
    `include "SPI_ram_sequencer.sv"
    `include "SPI_ram_agent.sv"

endpackage

`endif // SPI_RAM_PKG_SV