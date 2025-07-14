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
      
      
    // parameter IDLE=3'b000;
    // parameter CHK_CMD=3'b001;
    // parameter READ_ADD=3'b010;
    // parameter READ_DATA=3'b011;
    // parameter WRITE=3'b100;

    parameter MEM_DEPTH=256;
    parameter ADDR_SIZE=8;
    parameter MEM_WIDTH=8;

    parameter ZERO=0;
    parameter ALT_10 = {MEM_WIDTH/2 {1'b1, 1'b0}}; // Pattern 101010...
    parameter ALT_01 = {MEM_WIDTH/2 {1'b0, 1'b1}}; // Pattern 010101...
    parameter MAXIMUM= 2**(MEM_WIDTH+1) - 1;

    typedef struct packed {
      control_e control;
      bit [MEM_WIDTH-1:0] payload;
    } rx_data_s;


    
endpackage : shared_pkg
    