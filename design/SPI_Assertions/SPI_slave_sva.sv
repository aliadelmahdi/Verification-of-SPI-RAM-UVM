/*  
    This assertion file follows the **Verification Plan** numbering  
    Each section corresponds to a specific verification requirement

    The numbers (e.g., 1, 2.2) match the corresponding test items  
    from the **Verification Plan** for traceability and clarity
*/
`include "spi_defines.svh" // For macros
import shared_pkg::*; // For enums and parameters
`timescale `TIME_UNIT / `TIME_PRECISION



module SPI_slave_sva(cs,MOSI,SS_n,clk,rst_n,tx_data,tx_valid,MISO,rx_data,rx_valid);
    
    input MOSI,clk,rst_n,SS_n,tx_valid;
    input [MEM_WIDTH-1:0] tx_data;

	input logic MISO,rx_valid;
	input logic [MEM_WIDTH+1:0] rx_data;
    input logic [2:0] cs;
    
    //** 1: Reset Verification **\\

    // 1.2: Reset Current State
    property check_reset;
            (!rst_n)|=> (cs == IDLE);
                      
    endproperty
    assert_reset: assert property (@(posedge clk) check_reset)
        else $error("Failed to assert reset, the current state at reset is not IDLE");

    //** 3: FSM transitions **\\

    //aserted => slave not selected

    // 3.1: Transition from IDLE to CHK_CMD
    property check_idle_to_chk_cmd;
        @(posedge clk) disable iff(!rst_n)
                (cs==IDLE && SS_n==SLAVE_SELECTED) |=> (cs == CHK_CMD);
    endproperty

    assert_idle_to_chk_cmd: assert property (check_idle_to_chk_cmd)
        else $error("Failed to move to CHK_CMD state when slave is selected at IDLE state");

    // 3.1.1: Transition from IDLE to IDLE
    property check_idle_to_idle;
        @(posedge clk) disable iff(!rst_n)
                (cs==IDLE && SS_n==SLAVE_NOT_SELECTED) |=> (cs == IDLE);
    endproperty

    assert_idle_to_idle: assert property (check_idle_to_idle)
        else $error("Failed to stay at IDLE state when the slave isn't selected");

    // 3.2: Transition from CHK_CMD to IDLE
    property check_chk_cmd_to_idle;
        @(posedge clk) disable iff(!rst_n)
                (cs==CHK_CMD && SS_n==SLAVE_NOT_SELECTED) |=> (cs == IDLE);
    endproperty

    assert_chk_cmd_to_idle: assert property (check_chk_cmd_to_idle)
        else $error("Failed to move to IDLE state when slave isn't selected at CHK_CMD state");

    // 3.2.1: Transition from CHK_CMD to WRITE
    property check_chk_cmd_to_write;
        @(posedge clk) disable iff(!rst_n)
                (cs==CHK_CMD && SS_n==SLAVE_SELECTED && !MOSI) |=> (cs == WRITE);
    endproperty

    assert_chk_cmd_to_write: assert property (check_chk_cmd_to_write)
        else $error("Failed to move to WRITE state when slave is selected and MOSU is deasserted at CHK_CMD state");

    // // 3.2.2: Transition from CHK_CMD to READ_DATA
    // property check_chk_cmd_to_write;
    //     @(posedge clk) disable iff(!rst_n)
    //             (cs==CHK_CMD && SS_n==SLAVE_NOT_SELECTED) |=> (cs == READ_DATA);
    // endproperty

    // assert_chk_cmd_to_write: assert property (check_chk_cmd_to_write)
    //     else $error("Failed to move to READ_DATA state when slave is not selected at CHK_CMD state");

    // // 3.2.3: Transition from CHK_CMD to READ_ADD
    // property check_chk_cmd_to_write;
    //     @(posedge clk) disable iff(!rst_n)
    //             (cs==CHK_CMD && SS_n==SLAVE_NOT_SELECTED) |=> (cs == READ_ADD);
    // endproperty

    // assert_chk_cmd_to_write: assert property (check_chk_cmd_to_write)
    //     else $error("Failed to move to READ_ADD state when slave is not selected at CHK_CMD state");

    // 3.3: Transition from READ_ADD to IDLE
    property check_read_add_to_idle;
        @(posedge clk) disable iff(!rst_n)
                (cs==READ_ADD && SS_n==SLAVE_NOT_SELECTED) |=> (cs == IDLE);
    endproperty

    assert_read_add_to_idle: assert property (check_read_add_to_idle)
        else $error("Failed to move to IDLE state when slave isn't selected at READ_ADD state");

    // // 3.3.1: Transition from READ_ADD to READ_ADD
    // property check_read_add_to_read_add;
    //     @(posedge clk) disable iff(!rst_n)
    //             (cs==READ_ADD && SS_n==SLAVE_SELECTED) |=> (cs == READ_ADD);
    // endproperty

    // assert_read_add_to_read_add: assert property (check_read_add_to_read_add)
    //     else $error("Failed to stay at READ_ADD state when ");

     // 3.4: Transition from READ_DATA to IDLE
    property check_read_add_to_read_add;
        @(posedge clk) disable iff(!rst_n)
                (cs==READ_DATA && SS_n==SLAVE_NOT_SELECTED) |=> (cs == IDLE);
    endproperty

    assert_read_add_to_read_add: assert property (check_read_add_to_read_add)
        else $error("Failed to move to IDLE state from READ_DATA state when the slave is not selected");
       
    //   // 3.4.1: Transition from READ_DATA to READ_DATA
    // property check_read_add_to_read_add;
    //     @(posedge clk) disable iff(!rst_n)
    //             (cs==READ_DATA && SS_n==SLAVE_SELECTED) |=> (cs == READ_DATA);
    // endproperty

    // assert_read_add_to_read_add: assert property (check_read_add_to_read_add)
    //     else $error("Failed to stay at READ_ADD state when ");

    // 3.5: Transition from WRITE to IDLE
    property check_write_to_idle;
        @(posedge clk) disable iff(!rst_n)
                (cs==WRITE && SS_n==SLAVE_NOT_SELECTED) |=> (cs == IDLE);
    endproperty

    assert_write_to_idle: assert property (check_write_to_idle)
        else $error("Failed to move to WRITE state from IDLE state when the slave is not selected");

    //    // 3.5.1: Transition from WRITE to WRITE
    //     property check_write_to_write;
    //         @(posedge clk) disable iff(!rst_n)
    //                 (cs==WRITE && SS_n==SLAVE_NOT_SELECTED) |=> (cs == WRITE);
    //     endproperty

    //     assert_write_to_write: assert property (check_write_to_write)
    //         else $error("Failed to stay at WRITE state when ");

    //** 4: Signals at the FSM states **\\

        //aserted => slave not selected

        // // 4.1: Signals at IDLE state
        // property check_idle;
        //     @(posedge clk) disable iff(!rst_n)
        //             (cs==IDLE) |=> (MISO );
        // endproperty

        // assert_idle: assert property (check_idle)
        //     else $error("Mismatch in signals at IDLE state");

        // // 4.2: Signals at CHK_CMD state
        // property check_chk_cmd;
        //     @(posedge clk) disable iff(!rst_n)
        //             (cs==CHK_CMD) |=> (MISO );
        // endproperty

        // assert_chk_cmd: assert property (check_chk_cmd)
        //     else $error("Mismatch in signals at CHK_CMD state");

        // // 4.3: Signals at WRITE state
        // property check_write;
        //     @(posedge clk) disable iff(!rst_n)
        //             (cs==WRITE) |=> (MISO );
        // endproperty

        // assert_write: assert property (check_write)
        //     else $error("Mismatch in signals at WRITE state");

        // // 4.4: Signals at READ_DATA state
        // property check_read_data;
        //     @(posedge clk) disable iff(!rst_n)
        //             (cs==READ_DATA) |=> (MISO );
        // endproperty

        // assert_read_data: assert property (check_read_data)
        //     else $error("Mismatch in signals at READ_DATA state");

        // // 4.5: Signals at READ_ADD state
        // property check_read_add;
        //     @(posedge clk) disable iff(!rst_n)
        //             (cs==READ_ADD) |=> (MISO );
        // endproperty

        // assert_read_add: assert property (check_read_add)
        //     else $error("Mismatch in signals at READ_ADD state");

        // //** 5: SPI Slave **\\

        // //aserted => slave not selected

        // // 5.1: Serial to Parallel
        // property check_serial_to_parallel;
        //     @(posedge clk) disable iff(!rst_n)
        //             (cs==READ_ADD) |=> (MISO );
        // endproperty

        // assert_serial_to_parallel: assert property (check_serial_to_parallel)
        //     else $error("");

        // // 5.2: Data is ready
        // property check_rx_valid;
        //     @(posedge clk) disable iff(!rst_n)
        //             (cs==READ_ADD) |=> (MISO );
        // endproperty

        // assert_rx_valid: assert property (check_rx_valid)
        //     else $error("");

        // // 5.3: Parallel to Serial
        // property check_miso;
        //     @(posedge clk) disable iff(!rst_n)
        //             (cs==READ_ADD) |=> (MISO );
        // endproperty

        // assert_miso: assert property (check_miso)
        //     else $error("");
endmodule