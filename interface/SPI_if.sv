`include "spi_defines.svh" // For macros
import shared_pkg::*; // For enums and parameters

interface SPI_if(input bit clk);

	localparam MEM_DEPTH = shared_pkg::MEM_DEPTH;
	localparam ADDR_SIZE = shared_pkg::ADDR_SIZE;
	localparam MEM_WIDTH = shared_pkg::MEM_WIDTH;

	localparam IDLE = shared_pkg::IDLE;
	localparam CHK_CMD = shared_pkg::CHK_CMD;
	localparam WRITE = shared_pkg::WRITE;
	localparam READ_ADD = shared_pkg::READ_ADD;
	localparam READ_DATA = shared_pkg::READ_DATA;

  	logic rst_n,SS_n,MOSI;
	logic MISO;
	logic [MEM_WIDTH-1:0] dout; // tx_data
	logic tx_valid,rx_valid;
	logic [MEM_WIDTH+1:0] rx_data; // din

	logic [MEM_WIDTH-1:0] dout_ref; // tx_data_ref
	logic tx_valid_ref;

	logic [MEM_WIDTH-1:0] current_addr_data;
	// modports
    modport ram_gld (
        input clk, rst_n, rx_valid, rx_data,
        output tx_valid_ref, dout_ref
    );
	
	modport slave_monitor (input rst_n, SS_n, MOSI, tx_valid, rx_valid, MISO, rx_data, dout, clk);
	modport ram_monitor (input rst_n, rx_valid, rx_data, dout, tx_valid, tx_valid_ref, dout_ref, clk);
	modport ram_driver (
		input clk,
		output rst_n, rx_valid, rx_data
	);
	modport slave_driver (
    input clk,
    output rst_n, SS_n, MOSI, dout, tx_valid
	);

endinterface : SPI_if