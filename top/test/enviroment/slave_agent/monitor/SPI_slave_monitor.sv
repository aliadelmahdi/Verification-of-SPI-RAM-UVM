package SPI_slave_monitor_pkg;

    import uvm_pkg::*,
           SPI_slave_seq_item_pkg::*;
    `include "uvm_macros.svh"

    class SPI_slave_monitor extends uvm_monitor;
        `uvm_component_utils (SPI_slave_monitor)
        virtual SPI_if.monitor spi_if;
        SPI_slave_seq_item slave_response_seq_item;
        uvm_analysis_port #(SPI_slave_seq_item) slave_monitor_ap;

        // Default Constructor
        function new(string name = "SPI_slave_monitor",uvm_component parent);
            super.new(name,parent);
        endfunction : new

        // Build Phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            slave_monitor_ap = new ("slave_monitor_ap",this);
        endfunction : build_phase

        // Connect Phase
        function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
		endfunction : connect_phase

        // Run Phase
        task run_phase (uvm_phase phase);
            super.run_phase(phase);
            forever begin
                slave_response_seq_item = SPI_slave_seq_item::type_id::create("slave_response_seq_item");
                @(negedge spi_if.clk);
                slave_response_seq_item.rst_n = spi_if.rst_n;
                slave_response_seq_item.SS_n = spi_if.SS_n;
                slave_response_seq_item.MOSI = spi_if.MOSI;
                slave_response_seq_item.tx_valid = spi_if.tx_valid;
                slave_response_seq_item.rx_valid = spi_if.rx_valid;
                slave_response_seq_item.MISO = spi_if.MISO;
                slave_response_seq_item.rx_data = spi_if.rx_data;
                slave_response_seq_item.dout = spi_if.dout;
                slave_response_seq_item.MISO_ref = spi_if.MISO_ref;
                slave_monitor_ap.write(slave_response_seq_item);
                `uvm_info("run_phase", slave_response_seq_item.sprint(), UVM_HIGH)
            end

        endtask : run_phase
        
    endclass : SPI_slave_monitor

endpackage : SPI_slave_monitor_pkg