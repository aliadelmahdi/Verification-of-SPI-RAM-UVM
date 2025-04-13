package SPI_slave_agent_pkg;
    import  uvm_pkg::*,
            SPI_slave_seq_item_pkg::*,
            SPI_slave_driver_pkg::*,
            SPI_slave_main_sequence_pkg::*,
            SPI_slave_reset_sequence_pkg::*,
            SPI_slave_sequencer_pkg::*,
            SPI_slave_monitor_pkg::*,
            SPI_config_pkg::*;
    `include "uvm_macros.svh"
 
    class SPI_slave_agent extends uvm_agent;

        `uvm_component_utils(SPI_slave_agent)
        SPI_slave_sequencer spi_slave_seqr;
        SPI_slave_driver spi_slave_drv;
        SPI_slave_monitor spi_slave_mon;
        SPI_config spi_slave_cnfg;
        uvm_analysis_port #(SPI_slave_seq_item) spi_slave_agent_ap;

        // Default Constructor
        function new(string name = "SPI_slave_agent", uvm_component parent);
            super.new(name,parent);
        endfunction

        // Build Phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            if(!uvm_config_db #(SPI_config)::get(this,"","CFG",spi_slave_cnfg)) 
                `uvm_fatal ("build_phase","Unable to get the slave configuration object from the database")
            
            spi_slave_drv = SPI_slave_driver::type_id::create("spi_slave_drv",this);
            spi_slave_seqr = SPI_slave_sequencer::type_id::create("spi_slave_seqr",this);
            spi_slave_mon = SPI_slave_monitor::type_id::create("spi_slave_mon",this);
            spi_slave_agent_ap = new("spi_slave_agent_ap",this);
        endfunction

        // Connect Phase
        function void connect_phase(uvm_phase phase);
            spi_slave_drv.spi_if = spi_slave_cnfg.spi_if;
            spi_slave_mon.spi_if = spi_slave_cnfg.spi_if;
            spi_slave_drv.seq_item_port.connect(spi_slave_seqr.seq_item_export);
            spi_slave_mon.slave_monitor_ap.connect(spi_slave_agent_ap);
        endfunction

        // Run Phase
        task run_phase (uvm_phase phase);
            super.run_phase(phase);
        endtask
    endclass : SPI_slave_agent

endpackage : SPI_slave_agent_pkg