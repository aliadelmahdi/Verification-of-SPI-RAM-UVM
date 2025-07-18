/*  
    This assertion file follows the **Verification Plan** numbering  
    Each section corresponds to a specific verification requirement

    The numbers (e.g., 1, 2.2) match the corresponding test items  
    from the **Verification Plan** for traceability and clarity
*/
`include "spi_defines.svh" // For macros
import shared_pkg::*; // For enums and parameters
`timescale `TIME_UNIT / `TIME_PRECISION

module SPI_slave_sva(cs,MOSI,SS_n,clk,rst_n,tx_data,tx_valid,MISO,rx_data,rx_valid,rx_counter);
    
    input MOSI,clk,rst_n,SS_n,tx_valid;
    input [MEM_WIDTH-1:0] tx_data;

	input logic MISO,rx_valid;
	input logic [MEM_WIDTH+1:0] rx_data;
    input logic [2:0] cs;
    input logic [3:0] rx_counter;
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
        else $error("Failed to move to WRITE state when slave is selected and MOSI is deasserted at CHK_CMD state");

    // 3.2.2: Transition from CHK_CMD to READ_DATA
    property check_chk_cmd_to_read_data;
        @(posedge clk) disable iff(!rst_n)
                (cs==CHK_CMD && SS_n==SLAVE_NOT_SELECTED) |=> (cs == READ_DATA);
    endproperty

    assert_chk_cmd_to_read_data: assert property (check_chk_cmd_to_read_data)
        else $error("Failed to move to READ_DATA state when slave is not selected at CHK_CMD state");

    // 3.2.3: Transition from CHK_CMD to READ_ADD
    property check_chk_cmd_to_read_add;
        @(posedge clk) disable iff(!rst_n)
                (cs==CHK_CMD && SS_n==SLAVE_NOT_SELECTED) |=> (cs == READ_ADD);
    endproperty

    assert_chk_cmd_to_read_add: assert property (check_chk_cmd_to_read_add)
        else $error("Failed to move to READ_ADD state when slave is not selected at CHK_CMD state");

    // 3.3: Transition from READ_ADD to IDLE
    property check_read_add_to_idle;
        @(posedge clk) disable iff(!rst_n)
                (cs==READ_ADD && SS_n==SLAVE_NOT_SELECTED) |=> (cs == IDLE);
    endproperty

    assert_read_add_to_idle: assert property (check_read_add_to_idle)
        else $error("Failed to move to IDLE state when slave isn't selected at READ_ADD state");

    // 3.3.1: Transition from READ_ADD to READ_ADD
    property check_read_add_to_read_add;
        @(posedge clk) disable iff(!rst_n)
                (cs==READ_ADD && SS_n==SLAVE_SELECTED) |=> (cs == READ_ADD);
    endproperty

    assert_read_add_to_read_add: assert property (check_read_add_to_read_add)
        else $error("Failed to stay at READ_ADD state when slave is selected at READ_ADD state");

     // 3.4: Transition from READ_DATA to IDLE
    property check_read_data_to_idle;
        @(posedge clk) disable iff(!rst_n)
                (cs==READ_DATA && SS_n==SLAVE_NOT_SELECTED) |=> (cs == IDLE);
    endproperty

    assert_read_data_to_idle: assert property (check_read_data_to_idle)
        else $error("Failed to move to IDLE state from READ_DATA state when the slave is not selected");
       
      // 3.4.1: Transition from READ_DATA to READ_DATA
    property check_read_data_to_read_data;
        @(posedge clk) disable iff(!rst_n)
                (cs==READ_DATA && SS_n==SLAVE_SELECTED) |=> (cs == READ_DATA);
    endproperty

    assert_read_data_to_read_data: assert property (check_read_data_to_read_data)
        else $error("Failed to stay at READ_DATA state when slave is selected at READ_DATA state");

    // 3.5: Transition from WRITE to IDLE
    property check_write_to_idle;
        @(posedge clk) disable iff(!rst_n)
                (cs==WRITE && SS_n==SLAVE_NOT_SELECTED) |=> (cs == IDLE);
    endproperty

    assert_write_to_idle: assert property (check_write_to_idle)
        else $error("Failed to move to IDLE state from WRITE state when the slave is not selected");

    // 3.5.1: Transition from WRITE to WRITE
    property check_write_to_write;
        @(posedge clk) disable iff(!rst_n)
                (cs==WRITE && SS_n==SLAVE_SELECTED) |=> (cs == WRITE);
    endproperty

    assert_write_to_write: assert property (check_write_to_write)
        else $error("Failed to stay at WRITE state when slave isn't selected at WRITE state");

    //** 4: Signals at the FSM states **\\

        //asserted => slave not selected

        // 4.1: Signals at IDLE state
        property check_idle;
            @(posedge clk) disable iff(!rst_n)
                    (cs==IDLE) |=> (rx_data == 0 &&
                                    !rx_valid
                                    );
        endproperty

        assert_idle: assert property (check_idle)
            else $error("Mismatch in signals at IDLE state");

        // 4.2: Signals at CHK_CMD state
        property check_chk_cmd;
            @(posedge clk) disable iff(!rst_n)
                    (cs==CHK_CMD) |=> (!MISO &&
                                       !rx_valid &&
                                       rx_data == 0
                                      );
        endproperty

        assert_chk_cmd: assert property (check_chk_cmd)
            else $error("Mismatch in signals at CHK_CMD state");

        //** 5: SPI Slave **\\

        //aserted => slave not selected

        // 5.1: Serial to Parallel

        logic [MEM_WIDTH+1:0] mosi_shift, mosi_shift_latched;

        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                mosi_shift <= '0;
                mosi_shift_latched <= '0;
            end else if (cs inside {WRITE, READ_ADD, READ_DATA}) begin
                if (rx_counter < MEM_WIDTH+2)
                    mosi_shift <= {mosi_shift[MEM_WIDTH:0], MOSI}; // Shift left
                if (rx_valid && rx_counter == MEM_WIDTH+2)
                    mosi_shift_latched <= mosi_shift;
            end
        end

        property check_serial_to_parallel;
            @(posedge clk) disable iff (!rst_n)
            (rx_valid && (cs inside {WRITE, READ_ADD, READ_DATA}) && rx_counter == MEM_WIDTH+2) |=> (rx_data == mosi_shift_latched);
        endproperty

        assert_serial_to_parallel: assert property (check_serial_to_parallel)
            else begin
                $error("rx_data does not match accumulated MOSI bits after %0d cycles.",MEM_WIDTH+2);
                $display("DEBUG -> rx_data = %b, mosi_shift = %b, cs = %b, rx_counter = %0d", rx_data, mosi_shift, cs, rx_counter);
            end

        // 5.2: Data is ready
        property check_rx_valid;
            @(posedge clk) disable iff(!rst_n)
                    (rx_counter==10 && cs inside {READ_ADD,READ_DATA,WRITE}) |=> (rx_valid);
        endproperty

        assert_rx_valid: assert property (check_rx_valid)
            else begin
                $error("The slave did not assert the rx_vaild when the data was ready");
                $display("DEBUG -> rx_data = %b,cs = %b, rx_counter = %0d", rx_data, cs, rx_counter);
            end   

        // 5.3: Parallel to Serial
        property check_miso;
            @(posedge clk) disable iff(!rst_n)
                $rose(tx_valid) |=> (   MISO === tx_data[MEM_WIDTH-1]
                                    ##1 MISO === tx_data[MEM_WIDTH-2]
                                    ##1 MISO === tx_data[MEM_WIDTH-3]
                                    ##1 MISO === tx_data[MEM_WIDTH-4]
                                    ##1 MISO === tx_data[MEM_WIDTH-5]
                                    ##1 MISO === tx_data[MEM_WIDTH-6]
                                    ##1 MISO === tx_data[MEM_WIDTH-7]
                                    ##1 MISO === tx_data[MEM_WIDTH-8] );
        endproperty

        assert_miso: assert property (check_miso)
            else begin
                $error("The slave failed to convert the 10 bits parallel data coming from the tx_data to serial");
                $display("DEBUG -> tx_data = %b,cs = %b, tx_valid = %0d, MISO = %0b", tx_data,cs,tx_valid,MISO);
            end   
endmodule