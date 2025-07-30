`ifndef SPI_RAM_SEQ_ITEM_SV
`define SPI_RAM_SEQ_ITEM_SV
class SPI_ram_seq_item extends uvm_sequence_item;
    // Input signals
    bit rst_n;
    rand valid_e rx_valid;
    rand bit [MEM_WIDTH+1:0] rx_data;
    rand rx_data_s rx_data_s;
    
    // Output signals
    logic [MEM_WIDTH-1:0]dout;
    valid_e tx_valid;

    // Golden model signals
    logic [MEM_WIDTH-1:0]dout_ref;
    valid_e tx_valid_ref;

    `uvm_object_utils_begin(SPI_ram_seq_item)
        `uvm_field_int(rst_n, UVM_DEFAULT)
        `uvm_field_enum(valid_e,rx_valid, UVM_DEFAULT)
        `uvm_field_int(rx_data, UVM_DEFAULT)
        `uvm_field_int(dout, UVM_DEFAULT)
        `uvm_field_int(dout_ref, UVM_DEFAULT)
        `uvm_field_enum(valid_e,tx_valid, UVM_DEFAULT)
        `uvm_field_enum(valid_e,tx_valid_ref, UVM_DEFAULT)
    `uvm_object_utils_end
    function new(string name = "SPI_ram_seq_item");
        super.new(name);
    endfunction : new
    
    // constraint rst_n_dist_c{
    //     rst_n dist{
    //         `HIGH:= 97,
    //         `LOW:= 3
    //     };
    // }
    constraint rx_valid_c{
        rx_valid dist {
            VALID:= 85,
            NOT_VALID:= 15
        };
    }

    constraint rx_data_c {
        rx_data_s.control dist {
                                    WR_ADDR := 25,
                                    WR_DATA := 25,
                                    RD_ADDR := 25,
                                    RD_DATA := 25
                                };
    
    
        rx_data_s.payload dist { 
                                    ZERO := 5,
                                    ALT_10_RX_DATA := 10,
                                    ALT_01_RX_DATA := 10, 
                                    MAXIMUM_RX_DATA := 15,
                                    [1: MAXIMUM_RX_DATA-1] :/ 60
                                };

        
        rx_data == {rx_data_s.control, rx_data_s.payload};
    }


endclass : SPI_ram_seq_item

`endif // SPI_RAM_SEQ_ITEM_SV