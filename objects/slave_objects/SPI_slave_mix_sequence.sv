`ifndef SPI_SLAVE_MIX_SEQUENCE_SV
`define SPI_SLAVE_MIX_SEQUENCE_SV

class SPI_slave_mix_sequence extends SPI_slave_main_sequence;

        `uvm_object_utils(SPI_slave_mix_sequence)

        function new(string name = "SPI_slave_mix_sequence");
            super.new(name);
        endfunction : new

        task body;
            `uvm_info("run_phase", "SPI constraint mode 'Random mode' started", UVM_LOW);
            enable_constraints = `ON;
            repeat(`TEST_ITER_SMALL) begin
                if ($urandom_range(0, 1) == 0) begin // Write
                    write_sequence();
                end else begin // Read
                    read_sequence();
                end
            end
        endtask : body

        // TBA: randomize the rst state && add delays between each operation

endclass : SPI_slave_mix_sequence

`endif // SPI_SLAVE_MIX_SEQUENCE_SV