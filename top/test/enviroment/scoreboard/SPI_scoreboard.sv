package SPI_scoreboard_pkg;
    import  uvm_pkg::*,
            SPI_slave_seq_item_pkg::*,
            SPI_ram_seq_item_pkg::*,
            shared_pkg::*; // For enums and parameters
    
    `include "spi_defines.svh" // For macros

    `include "uvm_macros.svh"
    class SPI_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(SPI_scoreboard)
        
        uvm_analysis_export #(SPI_slave_seq_item) slave_sb_export;
        uvm_tlm_analysis_fifo #(SPI_slave_seq_item) spi_slave_sb;
        SPI_slave_seq_item slave_seq_item_sb;

        uvm_analysis_export #(SPI_ram_seq_item) ram_sb_export;
        uvm_tlm_analysis_fifo #(SPI_ram_seq_item) spi_ram_sb;
        SPI_ram_seq_item ram_seq_item_sb;

        int error_count = 0, correct_count = 0;
        
        // Default Constructor
        function new(string name = "SPI_scoreboard",uvm_component parent);
            super.new(name,parent);
        endfunction

        // Build Phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            slave_sb_export = new("slave_sb_export",this);
            spi_slave_sb=new("spi_slave_sb",this);
            ram_sb_export = new("ram_sb_export",this);
            spi_ram_sb=new("spi_ram_sb",this);
        endfunction

        // Connect Phase
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            slave_sb_export.connect(spi_slave_sb.analysis_export);
            ram_sb_export.connect(spi_ram_sb.analysis_export);
        endfunction

        // Run Phase
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                spi_slave_sb.get(slave_seq_item_sb);
                spi_ram_sb.get(ram_seq_item_sb);
                // check_ram_results(ram_seq_item_sb);
                check_slave_results(slave_seq_item_sb);
            end
        endtask

        // Report Phase
        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase",$sformatf("At time %0t: Simulation Ends and Error count= %0d, Correct count= %0d",$time,error_count,correct_count),UVM_MEDIUM);
        endfunction

        function void check_slave_results(SPI_slave_seq_item seq_item_ch);
            if (0) begin
                error_count++;
                `uvm_error("run_phase","Comparison Error between the golden model and the DUT")
                `uvm_info("SLAVE", $sformatf("Slave Transaction:\n%s", seq_item_ch.sprint()), UVM_MEDIUM)
            end
            else
                correct_count++;
        endfunction

        function void check_ram_results(SPI_ram_seq_item seq_item_ch_ram);
            if (seq_item_ch_ram.tx_valid != seq_item_ch_ram.tx_valid_ref
            || seq_item_ch_ram.dout != seq_item_ch_ram.dout_ref
            ) begin
                error_count++;
                `uvm_error("run_phase","Comparison Error between the golden model and the DUT")
                `uvm_info("run_phase", $sformatf("Ram Transaction:\n%s", seq_item_ch_ram.sprint()), UVM_MEDIUM)
                
                if (seq_item_ch_ram.tx_valid != seq_item_ch_ram.tx_valid_ref)
                    `uvm_info("run_phase", $sformatf("Mismatch: tx valid (DUT = %0b, REF = %0b)", seq_item_ch_ram.tx_valid, seq_item_ch_ram.tx_valid_ref), UVM_MEDIUM)
        
                if (seq_item_ch_ram.dout != seq_item_ch_ram.dout_ref)
                    `uvm_info("run_phase", $sformatf("Mismatch: dout (DUT = %0d, REF = %0d)", seq_item_ch_ram.dout, seq_item_ch_ram.dout_ref), UVM_MEDIUM)
                
                `display_separator
            end
            else
                correct_count++;
        endfunction

    endclass : SPI_scoreboard

endpackage : SPI_scoreboard_pkg