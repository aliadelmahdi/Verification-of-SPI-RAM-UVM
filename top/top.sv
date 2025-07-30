import uvm_pkg::*;
import SPI_env_pkg::*;
import SPI_test_pkg::*;
import shared_pkg::*; // For enums and parameters
`timescale `TIME_UNIT / `TIME_PRECISION

module tb_top;
    bit clk;
    // Clock Generation
    initial begin
        clk = `LOW;
        forever #(`CLK_PERIOD/2) clk = ~ clk;
    end

    SPI_env env_instance; // Instantiate the SPI enviroment
    SPI_test_base test; // Instantiate the SPI test
     
    // Instantiate the interface
    SPI_if spi_if (clk);
	logic [MEM_WIDTH-1:0] tx_data; // tx_data
    logic tx_valid;

    assign spi_if.tx_valid = tx_valid;
    assign spi_if.dout = tx_data;

      SPI_slave #(
        .IDLE(spi_if.IDLE),
        .CHK_CMD(spi_if.CHK_CMD),
        .WRITE(spi_if.WRITE),
        .READ_ADD(spi_if.READ_ADD),
        .READ_DATA(spi_if.READ_DATA)
        ) slave (
        .MOSI(spi_if.MOSI),
        .SS_n(spi_if.SS_n),
        .clk(spi_if.clk),
        .arst_n(spi_if.rst_n),
        .MISO(spi_if.MISO),
        .rx_data(spi_if.rx_data),
        .rx_valid(spi_if.rx_valid),
        .tx_data(tx_data),
        .tx_valid(tx_valid)
    );
    // RAM_Sync_Single_port instantiation
    RAM_Sync_Single_port #(
        .MEM_DEPTH(spi_if.MEM_DEPTH),
        .ADD_SIZE(spi_if.ADDR_SIZE)
    ) RAM (
        .din(spi_if.rx_data),
        .rx_valid(spi_if.rx_valid),
        .clk(spi_if.clk),
        .arst_n(spi_if.rst_n),
        .dout(tx_data),
        .tx_valid(tx_valid)
    );
  
    ram_golden_model RAM_GLD (spi_if.ram_gld);
    // spi_sys_golden_model #(
    //     .MEM_DEPTH(spi_if.MEM_DEPTH),
    //     .ADDR_SIZE(spi_if.ADDR_SIZE)
    // ) SYS_GLD (spi_if.sys_gld);
    // assign spi_if.current_addr_data_ref = SYS_GLD.mem[SYS_GLD.addr_internal_ref];

    dpi_golden_model SYS_GLD (spi_if.sys_gld);


    bind SPI_slave SPI_slave_sva SPI_slave_inst  (
        .MOSI(MOSI),
        .SS_n(SS_n),
        .clk(clk),
        .rst_n(arst_n),
        .MISO(MISO),
        .rx_data(rx_data),
        .rx_valid(rx_valid),
        .tx_data(tx_data),
        .tx_valid(tx_valid),
        .cs(slave.CS),
        .rx_counter(rx_counter)
    );
    assign spi_if.current_addr_data = RAM.mem[RAM.addr_internal];

    bind RAM_Sync_Single_port SPI_ram_sva RAM_sva_inst (
        .din(din),
        .rx_valid(rx_valid),
        .clk(clk),
        .rst_n(arst_n),
        .dout(dout),
        .tx_valid(tx_valid),
        .addr_internal(RAM.addr_internal),
        .current_addr_data(spi_if.current_addr_data)
    );
    
    initial begin
        uvm_top.set_report_verbosity_level(UVM_MEDIUM); // Set verbosity level
        uvm_top.finish_on_completion = `DISABLE_FINISH; // Prevent UVM from calling $finish
        uvm_config_db#(virtual SPI_if)::set(null, "*", "spi_if", spi_if); // Set SPI interface globally
        run_test("SPI_test_base"); // Start the UVM test
        `uvm_info("SEED", $sformatf("Current seed: %0d", $get_initial_random_seed()), UVM_LOW)
        $stop; // Stop simulation after test execution
    end
endmodule : tb_top