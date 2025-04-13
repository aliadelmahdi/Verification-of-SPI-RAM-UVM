package SPI_ram_sequencer_pkg;

    import uvm_pkg::*,
           SPI_ram_seq_item_pkg::*;
    `include "uvm_macros.svh"

    class SPI_ram_sequencer extends uvm_sequencer #(SPI_ram_seq_item);

        `uvm_component_utils(SPI_ram_sequencer);
        
        // Default Constructor
        function new(string name = "SPI_ram_sequence", uvm_component parent);
            super.new(name,parent);
        endfunction
        
        // Build Phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
        endfunction

        // Connect Phase
        function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
		endfunction

        // Run Phase
        task run_phase (uvm_phase phase);
            super.run_phase(phase);
        endtask

    endclass : SPI_ram_sequencer

endpackage : SPI_ram_sequencer_pkg