`ifndef GOLDEN_MODELS_SV
`define GOLDEN_MODELS_SV

`timescale `TIME_UNIT / `TIME_PRECISION
import shared_pkg::*; // For enums and parameters

`include "spi_defines.svh" // For macros
`include "spi_sys_golden_model.sv"
`include "ram_golden_model.sv"
`include "dpi_golden_model.sv"

`endif // GOLDEN_MODELS_SV