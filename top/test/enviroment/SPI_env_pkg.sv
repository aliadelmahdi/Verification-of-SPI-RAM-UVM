`ifndef SPI_ENV_PKG_SV
`define SPI_ENV_PKG_SV

package SPI_env_pkg;

    import uvm_pkg::*;
    import shared_pkg::*;
    `include "SPI_config.sv"
    `include "SPI_slave_pkg.sv"
    `include "SPI_ram_pkg.sv"

    `include "SPI_scoreboard.sv"
    `include "SPI_coverage_collector.sv"
    `include "SPI_env.sv"

endpackage

`endif // SPI_ENV_PKG_SV