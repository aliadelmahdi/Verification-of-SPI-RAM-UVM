`ifndef SPI_SLAVE_DRIVER_SV
`define SPI_SLAVE_DRIVER_SV

class SPI_slave_driver extends uvm_driver #(SPI_slave_seq_item);
    `uvm_component_utils(SPI_slave_driver)
    virtual SPI_if.slave_driver spi_if;
    SPI_slave_seq_item stimulus_seq_item;

    // Default Constructor
    function new(string name = "SPI_slave_driver", uvm_component parent);
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
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            stimulus_seq_item = SPI_slave_seq_item::type_id::create("slave_stimulus_seq_item");
            seq_item_port.get_next_item(stimulus_seq_item);
            spi_if.rst_n = stimulus_seq_item.rst_n;
            spi_if.SS_n = stimulus_seq_item.SS_n;
            spi_if.MOSI = stimulus_seq_item.MOSI;
            spi_if.dout = stimulus_seq_item.dout;
            spi_if.tx_valid = stimulus_seq_item.tx_valid;
            @(negedge spi_if.clk)
            seq_item_port.item_done();
            `uvm_info("run_phase",stimulus_seq_item.sprint(),UVM_HIGH)
        end
    endtask : run_phase
    
endclass : SPI_slave_driver

`endif // SPI_SLAVE_DRIVER_SV