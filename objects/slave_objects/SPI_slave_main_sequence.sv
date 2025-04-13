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
            // `disable_constraints
            // `enable_constraint (rst_n_inactive)
        endfunction

        task send_bit(logic MOSI, bit ss_n, bit rst_n);
            configure_seq_item();
            start_item(seq_item);
            if (MOSI === 'x) begin
                `enable_constraint (mosi_c)
                assert(seq_item.randomize()) else `uvm_error(get_type_name(), "rand failed");
            end else
                seq_item.MOSI  = MOSI;

            seq_item.SS_n  = ss_n;
            seq_item.rst_n = rst_n;
            finish_item(seq_item);
          endtask


        virtual task body;
        endtask

    endclass : SPI_slave_main_sequence

    // class SPI_slave_base_sequence extends SPI_slave_main_sequence;

    //     `uvm_object_utils(SPI_slave_base_sequence)

    //     function new(string name = "SPI_slave_base_sequence");
    //         super.new(name);
    //     endfunction

    //     task body;
    //         `uvm_info("run_phase", "SPI constraint mode 'Normal' started", UVM_LOW);
    //         repeat (`TEST_ITER_MEDIUM) begin
    //             configure_seq_item();
    //             start_item(seq_item);
    //             assert(seq_item.randomize()) else $error("Slave Randomization Failed for mode: Normal");
    //             finish_item(seq_item);
                
    //         end
    //     endtask

    // endclass : SPI_slave_base_sequence

  
  class SPI_slave_read_data_sequence extends SPI_slave_main_sequence;

    `uvm_object_utils(SPI_slave_read_data_sequence)

    function new(string name = "SPI_slave_read_data_sequence");
        super.new(name);
    endfunction

    task body;
        `uvm_info("run_phase", "SPI constraint mode 'Read Address' started", UVM_LOW);
        repeat(`TEST_ITER_SMALL) begin
            `uvm_info(get_type_name(), "Starting Read Address", UVM_HIGH)
            // 2 header bits
            send_bit(0,0,1);send_bit(1,0,1);
            // Commands
            send_bit(1,0,1);
            send_bit(0,0,1);
            // 8 random bits
            repeat(8) send_bit('x,0,1);
            // deassert SS
            send_bit(0,1,1);

            `uvm_info(get_type_name(), "Starting Read Data", UVM_HIGH)
            // 2 header bits
            send_bit(0,0,1);send_bit(1,0,1);
            // Commands
            send_bit(1,0,1);
            send_bit(1,0,1);
            // 8 random bits
            repeat(8) send_bit('x,0,1);
            // 9 random bits
            repeat(9) send_bit('x,0,1);
            // deassert SS
            send_bit(0,1,1);

        end
    endtask

endclass : SPI_slave_read_data_sequence

class SPI_slave_write_data_sequence extends SPI_slave_main_sequence;

    `uvm_object_utils(SPI_slave_write_data_sequence)

    function new(string name = "SPI_slave_write_data_sequence");
        super.new(name);
    endfunction

    task body;
        `uvm_info("run_phase", "SPI constraint mode 'Write Address' started", UVM_LOW);
        repeat(`TEST_ITER_MEDIUM) begin
            `uvm_info(get_type_name(), "Starting Write Address", UVM_HIGH)
            // 2 header bits
            send_bit(0,0,1);send_bit(0,0,1);
            // Commands
            send_bit(0,0,1);
            send_bit(0,0,1);
            // 8 random bits
            repeat(8) send_bit('x,0,1);
            // deassert SS
            send_bit(0,1,1);

            `uvm_info(get_type_name(), "Starting Write Data", UVM_HIGH)
            // 2 header bits
            send_bit(0,0,1);send_bit(0,0,1);
            // Commands
            send_bit(0,0,1);
            send_bit(1,0,1);
            // 8 random bits
            repeat(8) send_bit('x,0,1);
            // deassert SS
            send_bit(0,1,1);
        end
    endtask

endclass : SPI_slave_write_data_sequence

endpackage : SPI_slave_main_sequence_pkg