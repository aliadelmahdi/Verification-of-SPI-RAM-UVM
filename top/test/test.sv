
package SPI_test_pkg;
    import  uvm_pkg::*,
            SPI_env_pkg::*,
            SPI_config_pkg::*,
            SPI_ram_driver_pkg::*,
            SPI_slave_driver_pkg::*,
            SPI_slave_main_sequence_pkg::*,
            SPI_ram_main_sequence_pkg::*,
            SPI_slave_reset_sequence_pkg::*,
            SPI_ram_reset_sequence_pkg::*,
            SPI_slave_seq_item_pkg::*,
            SPI_ram_seq_item_pkg::*;
    `include "uvm_macros.svh"
    class SPI_test extends uvm_test;
        `uvm_component_utils(SPI_test)
        SPI_env spi_env; // Enviroment handle to the SPI
        // Configuration objects for slave and ram configurations
        SPI_config spi_slave_cnfg; // Slave configuration
        SPI_config spi_ram_cnfg; // Ram configuration
        virtual SPI_if spi_if; // Virtual interface handle
        SPI_slave_write_data_sequence spi_slave_write_data_seq; // Slave Write data sequence
        SPI_slave_mix_sequence SPI_slave_mix_seq; // Slave Mix sequence
        SPI_ram_main_sequence spi_ram_main_seq; // Ram main test sequence
        SPI_slave_reset_sequence spi_slave_reset_seq; // Slave reset test sequence
        SPI_ram_reset_sequence spi_ram_reset_seq; // Ram reset test sequence
        SPI_slave_read_data_sequence spi_slave_read_data_seq; // Slave Read data sequence
        // Default constructor
        function new(string name = "SPI_test", uvm_component parent);
            super.new(name,parent);
        endfunction : new

        // Build Phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase); // Call parent class's build_phase
            factory.print();
            // Create instances from the UVM factory
            spi_env = SPI_env::type_id::create("env",this);
            spi_slave_cnfg = SPI_config::type_id::create("SPI_slave_config",this);
            spi_ram_cnfg = SPI_config::type_id::create("SPI_ram_config",this);
            spi_ram_main_seq = SPI_ram_main_sequence::type_id::create("ram_main_seq",this);
            spi_slave_reset_seq = SPI_slave_reset_sequence::type_id::create("reset_seq",this);
            spi_ram_reset_seq = SPI_ram_reset_sequence::type_id::create("reset_seq",this);
            spi_slave_write_data_seq = SPI_slave_write_data_sequence::type_id::create("slave_write_data_seq",this);
            spi_slave_read_data_seq = SPI_slave_read_data_sequence::type_id::create("slave_read_data_seq",this);
            SPI_slave_mix_seq =  SPI_slave_mix_sequence::type_id::create("slave_mix_seq",this);
            // Retrieve the virtual interface for SPI slave from the UVM configuration database
            if(!uvm_config_db #(virtual SPI_if)::get(this,"","spi_if",spi_slave_cnfg.spi_if))  
                `uvm_fatal("build_phase" , " test - Unable to get the slave virtual interface of the SPI form the configuration database");
            // Retrieve the virtual interface for SPI ram from the UVM configuration database
            if(!uvm_config_db #(virtual SPI_if)::get(this,"","spi_if",spi_ram_cnfg.spi_if))  
                `uvm_fatal("build_phase" , " test - Unable to get the ram virtual interface of the SPI form the configuration database");
        
            // Set the slave as an active agent (drives transactions)
            spi_slave_cnfg.is_active =UVM_ACTIVE;
            // Set the ram as a passive agent (only monitors transactions)
            spi_ram_cnfg.is_active =UVM_PASSIVE;
            // spi_ram_cnfg.is_active =UVM_ACTIVE;

            // Store the SPI slave and ram configuration objects in the UVM configuration database
            uvm_config_db # (SPI_config)::set(this , "*" , "CFG",spi_slave_cnfg);
            uvm_config_db # (SPI_config)::set(this , "*" , "CFG",spi_ram_cnfg);
        endfunction : build_phase

        // Run Phase
        task run_phase(uvm_phase phase);
            super.run_phase(phase); // Call parent class's run phase
            phase.raise_objection(this); // Raise an objection to prevent the test from ending
            //**************************** Reset sequences ****************************\\
            `uvm_info("run_phase","stimulus Generation started",UVM_LOW)
            spi_slave_reset_seq.start(spi_env.spi_slave_agent.spi_slave_seqr);
            if(spi_ram_cnfg.is_active==UVM_ACTIVE)
                spi_ram_reset_seq.start(spi_env.spi_ram_agent.spi_ram_seqr);
            `uvm_info("run_phase","Reset Deasserted",UVM_LOW)

            //**************************** Main Sequences ****************************\\

            `uvm_info("run_phase", "Stimulus Generation Started",UVM_LOW)
            if(spi_ram_cnfg.is_active==UVM_ACTIVE)
                spi_ram_main_seq.start(spi_env.spi_ram_agent.spi_ram_seqr);
            spi_slave_write_data_seq.start(spi_env.spi_slave_agent.spi_slave_seqr);

            spi_slave_read_data_seq.start(spi_env.spi_slave_agent.spi_slave_seqr);

            SPI_slave_mix_seq.start(spi_env.spi_slave_agent.spi_slave_seqr);
            `uvm_info("run_phase", "Stimulus Generation Ended",UVM_LOW) 

            phase.drop_objection(this); // Drop the objection to allow the test to complete
        endtask : run_phase

    endclass : SPI_test
    
endpackage : SPI_test_pkg