`ifndef SPI_SLAVE_PKG_SV
`define SPI_SLAVE_PKG_SV

package SPI_slave_pkg;

    import uvm_pkg::*;
    import SPI_config_pkg::*;
    import SPI_slave_seq_item_pkg::*;
    import SPI_slave_main_sequence_pkg::*;

    `include "SPI_slave_driver.sv"
    `include "SPI_slave_monitor.sv"
    `include "SPI_slave_sequencer.sv"
    `include "SPI_slave_agent.sv"

endpackage : SPI_slave_pkg

`endif // SPI_SLAVE_PKG_SV