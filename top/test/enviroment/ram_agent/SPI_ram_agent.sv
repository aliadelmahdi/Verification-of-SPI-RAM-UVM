package SPI_ram_agent_pkg;
    import uvm_pkg::*,
        SPI_ram_seq_item_pkg::*,
        SPI_ram_driver_pkg::*,
        SPI_ram_main_sequence_pkg::*,
        SPI_ram_sequencer_pkg::*,
        SPI_ram_monitor_pkg::*,
        SPI_config_pkg::*;
    `include "uvm_macros.svh"
 
    class SPI_ram_agent extends uvm_agent;

        `uvm_component_utils(SPI_ram_agent)
        SPI_ram_sequencer spi_ram_seqr;
        SPI_ram_driver spi_ram_drv;
        SPI_ram_monitor spi_ram_mon;
        SPI_config spi_ram_cnfg;
        uvm_analysis_port #(SPI_ram_seq_item) spi_ram_agent_ap;
        uvm_active_passive_enum is_active;

        // Default Constructor
        function new(string name = "SPI_ram_agent", uvm_component parent);
            super.new(name,parent);
        endfunction

        // Build Phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            if(!uvm_config_db #(SPI_config)::get(this,"","CFG",spi_ram_cnfg)) 
                `uvm_fatal ("build_phase","Unable to get the ram configuration object from the database")
            is_active = spi_ram_cnfg.is_active;
            if(is_active==UVM_ACTIVE)begin
                spi_ram_drv = SPI_ram_driver::type_id::create("spi_ram_drv",this);
                spi_ram_seqr = SPI_ram_sequencer::type_id::create("spi_ram_seqr",this);
            end
            spi_ram_mon = SPI_ram_monitor::type_id::create("spi_ram_mon",this);
            spi_ram_agent_ap = new("spi_ram_agent_ap",this);
        endfunction

        // Connect Phase
        function void connect_phase(uvm_phase phase);
            if(is_active==UVM_ACTIVE)begin
              spi_ram_drv.seq_item_port.connect(spi_ram_seqr.seq_item_export);
              spi_ram_drv.spi_if = spi_ram_cnfg.spi_if;
            end
            spi_ram_mon.ram_monitor_ap.connect(spi_ram_agent_ap);
            spi_ram_mon.spi_if = spi_ram_cnfg.spi_if;
        endfunction

        // Run Phase
        task run_phase (uvm_phase phase);
            super.run_phase(phase);
        endtask
        
    endclass : SPI_ram_agent

endpackage : SPI_ram_agent_pkg