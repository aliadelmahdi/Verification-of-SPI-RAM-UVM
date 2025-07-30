`ifndef SPI_ASSERTIONS_SV
`define SPI_ASSERTIONS_SV

import shared_pkg::*; // For enums and parameters
`timescale `TIME_UNIT / `TIME_PRECISION

`include "SPI_ram_sva.sv"
`include "SPI_slave_sva.sv"

`endif // SPI_ASSERTIONS_SV