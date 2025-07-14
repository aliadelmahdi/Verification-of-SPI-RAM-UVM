package SPI_slave_main_sequence_pkg;

    import uvm_pkg::*,
           SPI_slave_seq_item_pkg::*,shared_pkg::*;
    `include "uvm_macros.svh"
    `include "spi_defines.svh" // For macros
    
    class SPI_slave_main_sequence extends uvm_sequence #(SPI_slave_seq_item);
        shared_pkg::control_e var1;
        `uvm_object_utils(SPI_slave_main_sequence)
        SPI_slave_seq_item seq_item;

        function new(string name = "SPI_slave_main_sequence");
            super.new(name);            
        endfunction : new

        // Configure the sequence item
        function void configure_seq_item();
            seq_item = SPI_slave_seq_item::type_id::create("seq_item");
            // `disable_constraints
            // `enable_constraint (rst_n_inactive)
        endfunction : configure_seq_item

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
        endtask : send_bit

        // This task sends the read header required to perform a read operation whether its a read address or a read data
        task send_read_header();
            // 2 header bits
            send_bit(.MOSI(0), .ss_n(SLAVE_SELECTED), .rst_n(`OFF_n));
            send_bit(.MOSI(1), .ss_n(SLAVE_SELECTED), .rst_n(`OFF_n));
        endtask : send_read_header

        // This task sends the write header required to perform a write operation whether its a write address or a write data
        task send_write_header();
            // 2 header bits
            send_bit(.MOSI(0), .ss_n(SLAVE_SELECTED), .rst_n(`OFF_n));
            send_bit(.MOSI(0), .ss_n(SLAVE_SELECTED), .rst_n(`OFF_n));
        endtask : send_write_header

        // This task is responsible for sending random MOSI bits to the RAM while keeping the reset and the slave select at known states
         task send_rand_mosi(input int unsigned count);
            for (int i = 0; i < count; i++) begin
                send_bit(.MOSI('x), .ss_n(SLAVE_SELECTED), .rst_n(`OFF_n));
            end
        endtask : send_rand_mosi

        // This task is responsible for deselecting the slave (Master ends communication)
        task deassert_slave();
            // Deassert SS
            send_bit(.MOSI(0), .ss_n(SLAVE_NOT_SELECTED), .rst_n(`OFF_n));
        endtask : deassert_slave

        // This task is responsible for sending a specific command to the RAM module
        task send_cmd(input control_e command);
            unique case (command)
                    WR_ADDR : begin
                        send_write_header();
                        // Commands
                        send_bit(.MOSI(0), .ss_n(SLAVE_SELECTED), .rst_n(`OFF_n));
                        send_bit(.MOSI(0), .ss_n(SLAVE_SELECTED), .rst_n(`OFF_n));
                    end
                    WR_DATA : begin
                        send_write_header();
                        // Commands
                        send_bit(.MOSI(0), .ss_n(SLAVE_SELECTED), .rst_n(`OFF_n));
                        send_bit(.MOSI(1), .ss_n(SLAVE_SELECTED), .rst_n(`OFF_n));
                    end
                    RD_ADDR : begin
                        send_read_header();
                        // Commands
                        send_bit(.MOSI(1), .ss_n(SLAVE_SELECTED), .rst_n(`OFF_n));
                        send_bit(.MOSI(0), .ss_n(SLAVE_SELECTED), .rst_n(`OFF_n));
                    end
                    RD_DATA : begin
                        send_read_header();
                        // Commands
                        send_bit(.MOSI(1), .ss_n(SLAVE_SELECTED), .rst_n(`OFF_n));
                        send_bit(.MOSI(1), .ss_n(SLAVE_SELECTED), .rst_n(`OFF_n));
                    end
            endcase 
        endtask : send_cmd    

        // The read sequence applied to the RAM module first by sending the read address then sending keeping the communication on, in order to receive the data from the RAM
        task read_sequence ();
            `uvm_info(get_type_name(), "Starting Read Address", UVM_HIGH)
            send_cmd(RD_ADDR);
            // 8 random bits
            send_rand_mosi(8);
            // Deassert SS
            deassert_slave();

            `uvm_info(get_type_name(), "Starting Read Data", UVM_HIGH)

            send_cmd(RD_DATA);

            // Dummy 8 random bits will be sent and ignored since the master is waiting for the data to be sent from slave side
            send_rand_mosi(8);
            // Send dummy bits through MOSI while simultaneously receiving the required data from MISO
            // 8 random bits
            send_rand_mosi(8);

            // Deassert SS
            deassert_slave();

        endtask : read_sequence

        // The write sequence applied to the RAM module first by sending the write address then sending the required data to be stored
        task write_sequence();
            `uvm_info(get_type_name(), "Starting Write Address", UVM_HIGH)
            send_cmd(WR_ADDR);
            // 8 random bits
            send_rand_mosi(8);
            // Deassert SS
            deassert_slave();
            `uvm_info(get_type_name(), "Starting Write Data", UVM_HIGH)
            send_cmd(WR_DATA);
            // 8 random bits
            send_rand_mosi(8);
            // Deassert SS
            deassert_slave();
        endtask : write_sequence

        virtual task body;
        endtask : body

    endclass : SPI_slave_main_sequence
  
    class SPI_slave_read_data_sequence extends SPI_slave_main_sequence;

        `uvm_object_utils(SPI_slave_read_data_sequence)

        function new(string name = "SPI_slave_read_data_sequence");
            super.new(name);
        endfunction : new

        task body;
            `uvm_info("run_phase", "SPI constraint mode 'Read Address' started", UVM_LOW);
            repeat(`TEST_ITER_SMALL) begin
                read_sequence();
            end
        endtask : body

    endclass : SPI_slave_read_data_sequence


    class SPI_slave_write_data_sequence extends SPI_slave_main_sequence;

        `uvm_object_utils(SPI_slave_write_data_sequence)

        function new(string name = "SPI_slave_write_data_sequence");
            super.new(name);
        endfunction : new

        task body;
            `uvm_info("run_phase", "SPI constraint mode 'Write Address' started", UVM_LOW);
            repeat(`TEST_ITER_MEDIUM) begin
                write_sequence();
            end
        endtask : body

    endclass : SPI_slave_write_data_sequence


    class SPI_slave_mix_sequence extends SPI_slave_main_sequence;

        `uvm_object_utils(SPI_slave_mix_sequence)

        function new(string name = "SPI_slave_mix_sequence");
            super.new(name);
        endfunction : new

        task body;
            `uvm_info("run_phase", "SPI constraint mode 'Write Address' started", UVM_LOW);
            repeat(`TEST_ITER_MEDIUM) begin
                if ($urandom_range(0, 1) == 0) begin // Write
                    write_sequence();
                end else begin // Read
                    read_sequence();
                end
            end
        endtask : body

        // TBA: randomize the rst state && add delays between each operation

    endclass : SPI_slave_mix_sequence

endpackage : SPI_slave_main_sequence_pkg