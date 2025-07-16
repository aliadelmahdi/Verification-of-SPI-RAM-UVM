package shared_pkg;

    // Include macros inside the package
    `include "spi_defines.svh"
    
    typedef enum logic [2:0] {
        IDLE      = 3'b000,
        CHK_CMD   = 3'b001,
        WRITE     = 3'b010,
        READ_ADD  = 3'b011,
        READ_DATA = 3'b100,
        INVALID   = 3'b111
      } state_e;
        
    typedef enum logic [1:0] {
      WR_ADDR = 2'b00,
      WR_DATA = 2'b01,
      RD_ADDR = 2'b10,
      RD_DATA = 2'b11
    } control_e;

    typedef enum bit {
      SLAVE_SELECTED,
      SLAVE_NOT_SELECTED
    } SS_n_e;

    typedef enum logic {
      NOT_VALID,
      VALID
    } valid_e;

    parameter MEM_DEPTH=256;
    parameter ADDR_SIZE=8;
    parameter MEM_WIDTH=8;

    parameter ZERO=0;
    // For dout signal
    parameter ALT_10_DOUT       = {MEM_WIDTH/2 {1'b1, 1'b0}};
    parameter ALT_01_DOUT       = {MEM_WIDTH/2 {1'b0, 1'b1}};
    parameter MAXIMUM_DOUT = 2**MEM_WIDTH - 1;  // 255 for MEM_WIDTH = 8
    // For rx_data signal (MEM_WIDTH + 2 bits wide)
    parameter ALT_10_RX_DATA    = {(MEM_WIDTH + 2)/2 {1'b1, 1'b0}};
    parameter ALT_01_RX_DATA    = {(MEM_WIDTH + 2)/2 {1'b0, 1'b1}};
    parameter MAXIMUM_RX_DATA = 2**(MEM_WIDTH + 2) - 1;  // 1023 for MEM_WIDTH = 8

    typedef struct packed {
      control_e control;
      bit [MEM_WIDTH-1:0] payload;
    } rx_data_s;


    
endpackage : shared_pkg
    