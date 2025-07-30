`ifndef SPI_RAM_SEQUENCER_SV
`define SPI_RAM_SEQUENCER_SV

class SPI_ram_sequencer extends uvm_sequencer #(SPI_ram_seq_item);

    `uvm_component_utils(SPI_ram_sequencer);
    
    // Default Constructor
    function new(string name = "SPI_ram_sequence", uvm_component parent);
        super.new(name,parent);
    endfunction : new
    
    // Build Phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction : build_phase

    // Connect Phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction : connect_phase

    // Run Phase
    task run_phase (uvm_phase phase);
        super.run_phase(phase);
    endtask : run_phase

endclass : SPI_ram_sequencer

`endif // SPI_RAM_SEQUENCER_SV