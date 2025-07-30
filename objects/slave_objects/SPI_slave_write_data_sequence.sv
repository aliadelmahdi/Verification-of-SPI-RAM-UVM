`ifndef SPI_SLAVE_WRITE_SEQUENCE_SV
`define SPI_SLAVE_WRITE_SEQUENCE_SV

class SPI_slave_write_data_sequence extends SPI_slave_main_sequence;

        `uvm_object_utils(SPI_slave_write_data_sequence)

        function new(string name = "SPI_slave_write_data_sequence");
            super.new(name);
        endfunction : new

        task body;
            `uvm_info("run_phase", "SPI constraint mode 'Write Address' started", UVM_LOW);
            repeat(`TEST_ITER_SMALL) begin
                write_sequence();
            end
        endtask : body

endclass : SPI_slave_write_data_sequence

`endif // SPI_SLAVE_WRITE_SEQUENCE_SV