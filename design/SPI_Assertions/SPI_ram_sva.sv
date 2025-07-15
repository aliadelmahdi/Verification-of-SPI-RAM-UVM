/*  
    This assertion file follows the **Verification Plan** numbering  
    Each section corresponds to a specific verification requirement

    The numbers (e.g., 1, 2.2) match the corresponding test items  
    from the **Verification Plan** for traceability and clarity
*/
`include "spi_defines.svh" // For macros
import shared_pkg::*; // For enums and parameters
`timescale `TIME_UNIT / `TIME_PRECISION

module SPI_ram_sva(
    input clk,rst_n,rx_valid,
    input[MEM_WIDTH+1:0]din,
    input logic [MEM_WIDTH-1:0]dout,
    input logic tx_valid,
    input logic [ADDR_SIZE-1:0] addr_internal,
    input logic [MEM_WIDTH-1:0] current_addr_data
    );
    logic [1:0] control_bits;
    assign control_bits = din[9:8];
    
    property check_reset;
            (!rst_n)|=> ( dout==0
                        && !tx_valid);
    endproperty

    assert_check_reset: assert property (@(posedge clk) check_reset)
        else begin
        $error("Failed to assert reset");
        $display("dout = %h, tx_valid = %b", dout, tx_valid);
        end

    property check_wr_addr_ram;
        @(posedge clk) disable iff(!rst_n)
                (rx_valid && control_bits== WR_ADDR) |=> (addr_internal == $past(din[7:0]));
    endproperty

    assert_wr_addr_ram: assert property (check_wr_addr_ram)
        else begin
                $error("The RAM failed to store din[7:0] in the internal write address bus when the control bits are WR_ADDR");
                $display("din[7:0] = %h, addr_internal = %h", din[7:0], addr_internal); 
            end

    property check_wr_data_ram;
        @(posedge clk) disable iff(!rst_n)
                (rx_valid && control_bits==WR_DATA) |=> (current_addr_data === $past(din[7:0]));
    endproperty

    assert_wr_data_ram: assert property (check_wr_data_ram)
        else begin
            $error("The RAM failed to store din[7:0] with write address previously held");
            $display("current_addr_data = %h, din[7:0] = %h", current_addr_data, $past(din[7:0])); 
        end

    property check_rd_addr_ram;
        @(posedge clk) disable iff(!rst_n)
                (rx_valid && control_bits==RD_ADDR) |=> (addr_internal == $past(din[7:0]));
    endproperty

    assert_rd_addr_ram: assert property (check_rd_addr_ram)
            else $error("The RAM failed to store din[7:0] in the internal read address bus");

    property check_rd_data_ram;
        @(posedge clk) disable iff(!rst_n)
                ( rx_valid && control_bits==RD_DATA) |=> (dout[7:0] === current_addr_data
                                        && tx_valid);
    endproperty

    assert_rd_data_ram: assert property (check_rd_data_ram)
        else begin
            $error("Failed to read from the memory with rd address previously held");
            $display("dout[7:0]) = %h, mem[addr_internal] = %h tx_valid = %b", control_bits, current_addr_data,tx_valid);
             end

    property check_tx_valid;
        @(posedge clk) disable iff(!rst_n)
                ( rx_valid && !(control_bits==RD_DATA)) |=> (!tx_valid);
    endproperty

    assert_tx_valid: assert property (check_tx_valid)
        else $error("Failed to ensure that the RAM deasserts tx valid");

endmodule