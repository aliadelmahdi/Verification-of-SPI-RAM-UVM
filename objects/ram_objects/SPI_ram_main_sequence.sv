`ifndef SPI_RAM_MAIN_SEQUENCE_SV
`define SPI_RAM_MAIN_SEQUENCE_SV

class SPI_ram_main_sequence extends uvm_sequence #(SPI_ram_seq_item);

    `uvm_object_utils(SPI_ram_main_sequence)
    SPI_ram_seq_item ram_seq_item;

    function new(string name = "SPI_ram_main_sequence");
        super.new(name);            
    endfunction

    task body;
        repeat(`TEST_ITER_MEDIUM) begin
            ram_seq_item = SPI_ram_seq_item::type_id::create("ram_seq_item");
            start_item(ram_seq_item);
            assert(ram_seq_item.randomize()) else $error("Randomization Failed");
            finish_item(ram_seq_item);
        end
    endtask

endclass

`endif // SPI_RAM_MAIN_SEQUENCE_SV