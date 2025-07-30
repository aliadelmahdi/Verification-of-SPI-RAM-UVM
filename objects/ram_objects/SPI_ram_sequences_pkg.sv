`ifndef SPI_RAM_SEQUENCES_PKG_SV
`define SPI_RAM_SEQUENCES_PKG_SV

package SPI_ram_sequences_pkg;

    import uvm_pkg::*;
    import SPI_ram_seq_item_pkg::*;
    import shared_pkg::*;

    `include "SPI_ram_main_sequence.sv"
    `include "SPI_ram_reset_sequence.sv"

endpackage

`endif
