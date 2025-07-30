`ifndef SPI_RAM_DRIVER_SV
`define SPI_RAM_DRIVER_SV
  
class SPI_ram_driver extends uvm_driver #(SPI_ram_seq_item);
    `uvm_component_utils(SPI_ram_driver)
    virtual SPI_if.ram_driver spi_if;
    SPI_ram_seq_item stimulus_seq_item;

    // Default Constructor
    function new(string name = "SPI_ram_driver", uvm_component parent);
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
            stimulus_seq_item = SPI_ram_seq_item::type_id::create("ram_stimulus_seq_item");
            seq_item_port.get_next_item(stimulus_seq_item);
            spi_if.rst_n = stimulus_seq_item.rst_n;
            spi_if.rx_valid = stimulus_seq_item.rx_valid;
            spi_if.rx_data = stimulus_seq_item.rx_data;
            @(negedge spi_if.clk)
            seq_item_port.item_done();
            `uvm_info("run_phase",stimulus_seq_item.sprint(),UVM_HIGH)
        end
    endtask : run_phase
    
endclass : SPI_ram_driver

`endif // SPI_RAM_DRIVER_SV