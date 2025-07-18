`include "spi_defines.svh" // For macros
import shared_pkg::*; // For enums and parameters
`timescale `TIME_UNIT / `TIME_PRECISION

module spi_sys_golden_model #(
    parameter MEM_DEPTH = 256,
    parameter ADDR_SIZE = 8
)(
   SPI_if spi_if
);

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

    // Memory to store data
    logic [7:0] mem [MEM_DEPTH-1:0];
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
                        WR_DATA: mem[addr_internal_ref] <= {shift_reg[7:0], MOSI};
                        RD_ADDR: addr_internal_ref <= {shift_reg[7:0], MOSI};
                        RD_DATA: begin
                            read_data <= mem[addr_internal_ref];
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


// Pure System Verilog RAM Golden Model
module ram_golden_model (SPI_if spi_if);
    //******* Assign interface to internal signals *******\\
    // inputs
    logic rst_n,clk,rx_valid;
    logic [MEM_WIDTH+1:0]rx_data;
    // outputs
    logic tx_valid;
    logic [MEM_WIDTH-1:0]dout;

    // Assign inputs
    assign rst_n = spi_if.rst_n;
    assign clk = spi_if.clk;
    assign rx_valid = spi_if.rx_valid;
    assign rx_data = spi_if.rx_data;

    // Assign outputs
    assign spi_if.tx_valid_ref = tx_valid;
    assign spi_if.dout_ref = dout;
   //****************************************************\\

    logic [MEM_WIDTH-1:0] memory [MEM_DEPTH-1:0];
    control_e control_bits;
    assign control_bits = control_e'(rx_data[MEM_WIDTH+1:MEM_WIDTH]);
    logic [MEM_WIDTH-1:0] d_in;

    assign d_in = rx_data[MEM_WIDTH-1:0];

    logic [ADDR_SIZE-1:0] wr_addr;
    logic [ADDR_SIZE-1:0] rd_addr;

    always @(posedge clk) begin
        if(!rst_n)begin
            tx_valid<=0;
            dout<=0;
            wr_addr<=0;
            rd_addr<=0;
        end else begin
            tx_valid<=0;
            case (control_bits)
                WR_ADDR: begin
                    wr_addr <= (rx_valid)? d_in : wr_addr;
                end
                WR_DATA:begin
                    memory[wr_addr] <= (rx_valid)? d_in : memory[wr_addr];
                end
                RD_ADDR:begin
                    rd_addr <= (rx_valid)? d_in : rd_addr;
                end
                RD_DATA:begin
                    if(rx_valid) begin
                        dout <= memory[rd_addr];
                        tx_valid<=1;
                    end
                    else
                    tx_valid<=0;
                end
            endcase
        end
    end
endmodule
