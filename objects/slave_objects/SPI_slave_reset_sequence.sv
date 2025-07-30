`ifndef SPI_SLAVE_RESET_SEQUENCE_SV
`define SPI_SLAVE_RESET_SEQUENCE_SV

class SPI_slave_reset_sequence extends uvm_sequence #(SPI_slave_seq_item);

        `uvm_object_utils (SPI_slave_reset_sequence)
        SPI_slave_seq_item slave_seq_item;

        function new (string name = "SPI_slave_reset_sequence");
            super.new(name);
        endfunction : new

        task body;
            slave_seq_item = SPI_slave_seq_item::type_id::create("slave_seq_item");
            start_item(slave_seq_item);
                slave_seq_item.rst_n = `ON_n;
                slave_seq_item.SS_n = `ON_n;
                slave_seq_item.tx_valid = `OFF;
            finish_item(slave_seq_item);
        endtask
        
endclass : SPI_slave_reset_sequence

`endif // SPI_SLAVE_RESET_SEQUENCE_SV
