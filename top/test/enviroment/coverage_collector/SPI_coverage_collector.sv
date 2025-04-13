package SPI_coverage_pkg;
    import  uvm_pkg::*,
            SPI_ram_driver_pkg::*,
            SPI_slave_driver_pkg::*,
            SPI_scoreboard_pkg::*,
            SPI_slave_main_sequence_pkg::*,
            SPI_ram_main_sequence_pkg::*,
            SPI_slave_reset_sequence_pkg::*,
            SPI_slave_seq_item_pkg::*,
            SPI_ram_seq_item_pkg::*,
            SPI_ram_sequencer_pkg::*,
            SPI_slave_sequencer_pkg::*,
            SPI_ram_monitor_pkg::*,
            SPI_slave_monitor_pkg::*,
            SPI_config_pkg::*,
            SPI_ram_agent_pkg::*,
            SPI_slave_agent_pkg::*,
            shared_pkg::*;
    `include "uvm_macros.svh"
    `include "spi_defines.svh" // For macros


    class SPI_coverage extends uvm_component;
        `uvm_component_utils(SPI_coverage)

        // Analysis Export for receiving transactions from monitors
        uvm_analysis_export #(SPI_slave_seq_item) slave_cov_export;
        uvm_tlm_analysis_fifo #(SPI_slave_seq_item) slave_cov_spi;
        SPI_slave_seq_item slave_seq_item_cov;
        uvm_analysis_export #(SPI_ram_seq_item) ram_cov_export;
        uvm_tlm_analysis_fifo #(SPI_ram_seq_item) ram_cov_spi;
        SPI_ram_seq_item ram_seq_item_cov;
        // module RAM_Sync_Single_port(din,rx_valid,clk,rst_n,            tx_valid,dout);

        // Covergroup definitions
        covergroup spi_cov_grp;
            rst_n_cp: coverpoint slave_seq_item_cov.rst_n{
                bins active = {`LOW};
                bins inactive = {`HIGH};
                bins inactive_to_active = (`HIGH=>`LOW);
                bins active_to_inactive = (`LOW=>`HIGH);
            }
            tx_valid_cp: coverpoint ram_seq_item_cov.tx_valid {
                bins valid = {VALID};
                bins not_vaild = {NOT_VALID};
                bins valid_to_not_vaild = (VALID => NOT_VALID);
                bins not_valid_to_vaild = (NOT_VALID => VALID);
            }

            dout_cp: coverpoint ram_seq_item_cov.dout {
                bins zero    = {ZERO};
                bins alt_10  = {ALT_10};
                bins alt_01  = {ALT_01};
                bins maximum = {MAXIMUM};
                bins others = {[1:MAXIMUM-1]} with (!(item == ALT_01 || item == ALT_10));
            }
            
            tx_valid_dout_cr: cross tx_valid_cp,dout_cp{
                bins valid_dout_zero = binsof(dout_cp.zero) && binsof(tx_valid_cp.valid);
                bins valid_dout_alt_10 = binsof(dout_cp.alt_10) && binsof(tx_valid_cp.valid);
                bins valid_dout_alt_01 = binsof(dout_cp.alt_01) && binsof(tx_valid_cp.valid);
                bins valid_dout_maximum = binsof(dout_cp.maximum) && binsof(tx_valid_cp.valid);
                bins valid_dout_others = binsof(dout_cp.others) && binsof(tx_valid_cp.valid);

                bins valid_dout_zero_trans = binsof(dout_cp.zero) && binsof(tx_valid_cp.not_valid_to_vaild);
                bins valid_dout_alt_10_trans = binsof(dout_cp.alt_10) && binsof(tx_valid_cp.not_valid_to_vaild);
                bins valid_dout_alt_01_trans = binsof(dout_cp.alt_01) && binsof(tx_valid_cp.not_valid_to_vaild);
                bins valid_dout_maximum_trans = binsof(dout_cp.maximum) && binsof(tx_valid_cp.not_valid_to_vaild);
                bins valid_dout_others_trans = binsof(dout_cp.others) && binsof(tx_valid_cp.not_valid_to_vaild);
                option.cross_auto_bin_max = 0;
            }

        endgroup

        // Constructor
        function new (string name = "SPI_coverage", uvm_component parent);
            super.new(name, parent);
            spi_cov_grp = new();
        endfunction

        // Build Phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            slave_cov_export = new("slave_cov_export", this);
            slave_cov_spi = new("slave_cov_spi", this);
            ram_cov_export = new("ram_cov_export", this);
            ram_cov_spi = new("ram_cov_spi", this);
        endfunction

        // Connect Phase
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            slave_cov_export.connect(slave_cov_spi.analysis_export);
            ram_cov_export.connect(ram_cov_spi.analysis_export);
        endfunction

        // Run Phase
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                // Get the next transaction from the analysis FIFO.
                slave_cov_spi.get(slave_seq_item_cov);
                ram_cov_spi.get(ram_seq_item_cov);
                spi_cov_grp.sample();
            end
        endtask

    endclass : SPI_coverage

endpackage : SPI_coverage_pkg