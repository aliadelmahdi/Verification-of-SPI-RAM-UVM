`ifndef SPI_RAM_MONITOR_SV
`define SPI_RAM_MONITOR_SV

class SPI_ram_monitor extends uvm_monitor;

    `uvm_component_utils (SPI_ram_monitor)
    virtual SPI_if.ram_monitor spi_if;
    SPI_ram_seq_item ram_response_seq_item;
    uvm_analysis_port #(SPI_ram_seq_item) ram_monitor_ap;

    function new(string name = "SPI_ram_monitor",uvm_component parent);
        super.new(name,parent);
    endfunction : new

    // Build Phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ram_monitor_ap = new ("ram_monitor_ap",this);
    endfunction : build_phase

    // Connect Phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction : connect_phase

    // Run Phase
    task run_phase (uvm_phase phase);
        super.run_phase(phase);
        forever begin
            ram_response_seq_item = SPI_ram_seq_item::type_id::create("ram_response_seq_item");
            @(negedge spi_if.clk);
            ram_response_seq_item.rst_n = spi_if.rst_n;
            ram_response_seq_item.rx_valid = valid_e'(spi_if.rx_valid);
            ram_response_seq_item.rx_data = spi_if.rx_data;
            ram_response_seq_item.dout = spi_if.dout;
            ram_response_seq_item.tx_valid = valid_e'(spi_if.tx_valid);
            ram_response_seq_item.tx_valid_ref = valid_e'(spi_if.tx_valid_ref);
            ram_response_seq_item.dout_ref = spi_if.dout_ref;
            ram_monitor_ap.write(ram_response_seq_item);
            `uvm_info("run_phase", ram_response_seq_item.sprint(), UVM_HIGH)
        end

    endtask : run_phase
    
endclass : SPI_ram_monitor

`endif // SPI_RAM_MONITOR_SV