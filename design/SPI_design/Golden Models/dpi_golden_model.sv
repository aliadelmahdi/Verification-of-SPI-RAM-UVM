`include "spi_defines.svh" // For macros
import shared_pkg::*; // For enums and parameters
`timescale `TIME_UNIT / `TIME_PRECISION

module dpi_golden_model #(
    parameter MEM_DEPTH = 256,
    parameter ADDR_SIZE = 8
)(
   SPI_if spi_if
);
// DPI-C imports
import "DPI-C" function void dpi_spi_mem_write(input byte addr, input byte data);
import "DPI-C" function byte dpi_spi_mem_read(input byte addr);

//******* Assign interface to internal signals *******\\
    // inputs
    logic clk;
    logic rst_n;
    logic MOSI;
    logic SS_n;
    // outputs
    logic MISO_ref;

    // Assign inputs
    assign rst_n = spi_if.rst_n;
    assign clk = spi_if.clk;
    assign MOSI = spi_if.MOSI;
    assign SS_n = spi_if.SS_n;

    logic [9:0] shift_reg;
    logic [3:0] bit_counter;
    logic [ADDR_SIZE-1:0] addr_internal_ref;

    logic read_cmd_active;
    logic [7:0] read_data;
    logic [3:0] read_bit_counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 0;
            bit_counter <= 0;
            addr_internal_ref <= 0;
            read_cmd_active <= 0;
            read_data <= 0;
            read_bit_counter <= 0;
            MISO_ref <= 0;
        end
        else if (SS_n==SLAVE_SELECTED) begin
            if (!read_cmd_active) begin
                shift_reg <= {shift_reg[8:0], MOSI};
                if (bit_counter == 11) begin
                    case ({shift_reg[8:0], MOSI}[9:8])
                        WR_ADDR: addr_internal_ref <= {shift_reg[7:0], MOSI};
                        // WR_DATA: mem[addr_internal_ref] <= {shift_reg[7:0], MOSI};
                        WR_DATA: dpi_spi_mem_write(addr_internal_ref, {shift_reg[7:0], MOSI});

                        RD_ADDR: addr_internal_ref <= {shift_reg[7:0], MOSI};
                        RD_DATA: begin
                            // read_data <= mem[addr_internal_ref];
                            read_data <= dpi_spi_mem_read(addr_internal_ref);
                            read_cmd_active <= 1;
                            read_bit_counter <= 0;
                        end
                    endcase
                    bit_counter <= 0;
                end else begin
                    bit_counter <= bit_counter + 1;
                end
            end else begin
                MISO_ref <= read_data[7 - read_bit_counter];
                read_bit_counter <= read_bit_counter + 1;
                if (read_bit_counter == 7) begin
                    read_cmd_active <= 0;
                end
            end
        end else begin
            bit_counter <= 0;
            read_cmd_active <= 0;
            read_bit_counter <= 0;
            MISO_ref <= 0;
        end
    end

    logic MISO_ref_d1; // Delayed version

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            MISO_ref_d1 <= 0;
        end else begin
            MISO_ref_d1 <= MISO_ref;
            spi_if.MISO_ref <= MISO_ref_d1;
        end
    end
endmodule