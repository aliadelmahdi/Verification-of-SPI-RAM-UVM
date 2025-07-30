`ifndef SPI_ENV_PKG_SV
`define SPI_ENV_PKG_SV

package SPI_env_pkg;

    import uvm_pkg::*;
    import SPI_ram_pkg::*;
    import SPI_slave_pkg::*;
    import SPI_config_pkg::*;
    import SPI_slave_main_sequence_pkg::*;
    import SPI_ram_sequences_pkg::*;
    import SPI_slave_seq_item_pkg::*;
    import SPI_ram_seq_item_pkg::*;
    import shared_pkg::*;

    `include "SPI_scoreboard.sv"
    `include "SPI_coverage_collector.sv"
    `include "SPI_env.sv"

endpackage

`endif // SPI_ENV_PKG_SV