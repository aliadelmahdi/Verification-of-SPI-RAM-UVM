package SPI_slave_main_sequence_pkg;

    import uvm_pkg::*,
           SPI_slave_seq_item_pkg::*;
    `include "uvm_macros.svh"
    `include "spi_defines.svh" // For macros

    

    class SPI_slave_main_sequence extends uvm_sequence #(SPI_slave_seq_item);

        `uvm_object_utils(SPI_slave_main_sequence)
        SPI_slave_seq_item seq_item;

        function new(string name = "SPI_slave_main_sequence");
            super.new(name);            
        endfunction

        // Configure the sequence item
        function void configure_seq_item();
            seq_item = SPI_slave_seq_item::type_id::create("seq_item");
            `disable_constraints
        endfunction

        virtual task body;
        endtask

    endclass : SPI_slave_main_sequence

    class SPI_slave_base_sequence extends SPI_slave_main_sequence;

        `uvm_object_utils(SPI_slave_base_sequence)

        function new(string name = "SPI_slave_base_sequence");
            super.new(name);
        endfunction

        task body;
            `uvm_info("run_phase", "SPI constraint mode 'Normal' started", UVM_LOW);
            repeat (`TEST_ITER_MEDIUM) begin
                configure_seq_item();
                `enable_constraint (rst_n_dist_c)
                start_item(seq_item);
                assert(seq_item.randomize()) else $error("Slave Randomization Failed for mode: Normal");
                finish_item(seq_item);
                
            end
        endtask

    endclass : SPI_slave_base_sequence

    class SPI_slave_write_addr_sequence extends SPI_slave_main_sequence;

        `uvm_object_utils(SPI_slave_write_addr_sequence)

        function new(string name = "SPI_slave_write_addr_sequence");
            super.new(name);
        endfunction

        task body;
            `uvm_info("run_phase", "SPI constraint mode 'Write Address' started", UVM_LOW);
            repeat (`TEST_ITER_SMALL) begin
                // Cycle 1
                configure_seq_item();
                `enable_constraint (rst_n_inactive)
                start_item(seq_item);
                assert(seq_item.randomize()) else $error("Slave Randomization Failed for mode: Write Address");
                seq_item.SS_n = 0;
                seq_item.MOSI = 0;
                finish_item(seq_item);

                // Cycle 2
                configure_seq_item();
                `enable_constraint (rst_n_inactive)
                start_item(seq_item);
                assert(seq_item.randomize()) else $error("Slave Randomization Failed for mode: Write Address");
                seq_item.MOSI = 0;
                finish_item(seq_item);

                repeat(8) begin
                // Cycle 3 => 10
                configure_seq_item();
                `enable_constraint (rst_n_inactive)
                // `enable_constraint (mosi_c)
                start_item(seq_item);
                assert(seq_item.randomize()) else $error("Slave Randomization Failed for mode: Write Address");
                seq_item.MOSI = 1;
                finish_item(seq_item);    
                end

                // Cycle 11
                configure_seq_item();
                `enable_constraint (rst_n_inactive)
                start_item(seq_item);
                seq_item.SS_n = 1;
                finish_item(seq_item);
            end
        endtask

    endclass : SPI_slave_write_addr_sequence

endpackage : SPI_slave_main_sequence_pkg