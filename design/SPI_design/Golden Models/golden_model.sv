`include "spi_defines.svh" // For macros
import shared_pkg::*; // For enums and parameters

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
