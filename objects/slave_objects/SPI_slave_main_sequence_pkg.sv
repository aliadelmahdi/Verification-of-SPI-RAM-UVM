`ifndef SPI_SLAVE_MAIN_SEQUENCE_PKG
`define SPI_SLAVE_MAIN_SEQUENCE_PKG

package SPI_slave_main_sequence_pkg;

    import uvm_pkg::*;
    import SPI_slave_seq_item_pkg::*;
    import shared_pkg::*;
    
    `include "SPI_slave_reset_sequence.sv"
    `include "SPI_slave_main_sequence.sv"
    `include "SPI_slave_read_data_sequence.sv"
    `include "SPI_slave_write_data_sequence.sv"
    `include "SPI_slave_mix_sequence.sv"


endpackage : SPI_slave_main_sequence_pkg

`endif // SPI_SLAVE_MAIN_SEQUENCE_PKG
