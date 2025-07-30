`ifndef SPI_RAM_RESET_SEQUENCE_SV
`define SPI_RAM_RESET_SEQUENCE_SV

class SPI_ram_reset_sequence extends uvm_sequence #(SPI_ram_seq_item);

    `uvm_object_utils(SPI_ram_reset_sequence)
    SPI_ram_seq_item ram_seq_item;

    function new(string name = "SPI_ram_reset_sequence");
        super.new(name);
    endfunction

    task body;
        ram_seq_item = SPI_ram_seq_item::type_id::create("ram_seq_item");
        start_item(ram_seq_item);
            ram_seq_item.rst_n = `LOW;
            ram_seq_item.rx_valid = NOT_VALID;
            ram_seq_item.rx_data = `LOW;
        finish_item(ram_seq_item);
    endtask

endclass

`endif // SPI_RAM_RESET_SEQUENCE_SV
