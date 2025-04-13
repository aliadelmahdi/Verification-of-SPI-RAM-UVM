package SPI_env_pkg; 
    import  uvm_pkg::*,
            SPI_ram_driver_pkg::*,
            SPI_slave_driver_pkg::*,
            SPI_scoreboard_pkg::*,
            SPI_slave_main_sequence_pkg::*,
            SPI_ram_main_sequence_pkg::*,
            SPI_slave_reset_sequence_pkg::*,
            SPI_slave_seq_item_pkg::*,
            SPI_ram_seq_item_pkg::*,
            SPI_ram_sequencer_pkg::*,
            SPI_slave_sequencer_pkg::*,
            SPI_ram_monitor_pkg::*,
            SPI_slave_monitor_pkg::*,
            SPI_config_pkg::*,
            SPI_ram_agent_pkg::*,
            SPI_slave_agent_pkg::*,
            SPI_coverage_pkg::*;
    `include "uvm_macros.svh"
    class SPI_env extends uvm_env;
        `uvm_component_utils(SPI_env)

        SPI_ram_agent spi_ram_agent;
        SPI_slave_agent spi_slave_agent;

        SPI_scoreboard spi_sb;
        SPI_coverage spi_cov;
        
        // Default Constructor
        function new (string name = "SPI_env", uvm_component parent);
            super.new(name,parent);
        endfunction

        // Build Phase
        function void build_phase(uvm_phase phase );
        super.build_phase (phase);
            spi_ram_agent = SPI_ram_agent::type_id::create("spi_ram_agent",this);
            spi_slave_agent = SPI_slave_agent::type_id::create("spi_slave_agent",this);
            spi_sb= SPI_scoreboard::type_id::create("spi_sb",this);
            spi_cov= SPI_coverage::type_id::create("spi_cov",this);
        endfunction

        // Connect Phase
        function void connect_phase (uvm_phase phase );
            spi_ram_agent.spi_ram_agent_ap.connect(spi_sb.ram_sb_export);
            spi_ram_agent.spi_ram_agent_ap.connect(spi_cov.ram_cov_export);
            spi_slave_agent.spi_slave_agent_ap.connect(spi_sb.slave_sb_export);
            spi_slave_agent.spi_slave_agent_ap.connect(spi_cov.slave_cov_export);
        endfunction

        // Run Phase
        task run_phase (uvm_phase phase);
            super.run_phase(phase);
        endtask
    endclass : SPI_env
endpackage : SPI_env_pkg