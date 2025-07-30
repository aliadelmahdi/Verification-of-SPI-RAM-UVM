`ifndef SPI_CONFIG_SV
`define SPI_CONFIG_SV

class SPI_config extends uvm_object;

    `uvm_object_utils (SPI_config)
    virtual SPI_if spi_if;
    uvm_active_passive_enum is_active;

    // Default Constructor
    function new(string name = "SPI_config");
        super.new(name);
    endfunction : new
    
endclass : SPI_config

`endif // SPI_CONFIG_SV