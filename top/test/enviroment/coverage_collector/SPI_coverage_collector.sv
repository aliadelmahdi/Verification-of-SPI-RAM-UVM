`ifndef SPI_COVERAGE_SV
`define SPI_COVERAGE_SV

class SPI_coverage extends uvm_component;
    `uvm_component_utils(SPI_coverage)

    // Analysis Export for receiving transactions from monitors
    uvm_analysis_export #(SPI_slave_seq_item) slave_cov_export;
    uvm_tlm_analysis_fifo #(SPI_slave_seq_item) slave_cov_spi;
    SPI_slave_seq_item slave_seq_item_cov;
    uvm_analysis_export #(SPI_ram_seq_item) ram_cov_export;
    uvm_tlm_analysis_fifo #(SPI_ram_seq_item) ram_cov_spi;
    SPI_ram_seq_item ram_seq_item_cov;

    // Covergroup definitions
    covergroup spi_cov_grp;
        rst_n_cp: coverpoint slave_seq_item_cov.rst_n{
            bins active = {`LOW};
            bins inactive = {`HIGH};
            bins inactive_to_active = (`HIGH=>`LOW);
            bins active_to_inactive = (`LOW=>`HIGH);
        }
        MISO_cp: coverpoint slave_seq_item_cov.MISO{
            bins active = {`HIGH};
            bins inactive = {`LOW};
            bins active_to_inactive = (`HIGH=>`LOW);
            bins inactive_to_active = (`LOW=>`HIGH);
        }
        MOSI_cp: coverpoint slave_seq_item_cov.MOSI{
            bins active = {`HIGH};
            bins inactive = {`LOW};
            bins active_to_inactive = (`HIGH=>`LOW);
            bins inactive_to_active = (`LOW=>`HIGH);
        }
        rx_valid_cp: coverpoint slave_seq_item_cov.rx_valid {
                        bins valid = {VALID};
                        bins not_vaild = {NOT_VALID};
                        bins valid_to_not_vaild = (VALID => NOT_VALID);
                        bins not_valid_to_vaild = (NOT_VALID => VALID);
                    }
        rx_data_cp: coverpoint slave_seq_item_cov.rx_data {
            bins zero    = {ZERO};
            bins alt_10  = {ALT_10_RX_DATA};
            bins alt_01  = {ALT_01_RX_DATA};
            bins maximum = {MAXIMUM_RX_DATA};
            bins others = {[1:MAXIMUM_RX_DATA-1]} with (
                                                !(item == ALT_01_RX_DATA || item == ALT_10_RX_DATA)
                                            );
        }
        SS_n_cp: coverpoint slave_seq_item_cov.SS_n {
            bins slave_selected        = {SLAVE_SELECTED};
            bins slave_not_selected    = {SLAVE_NOT_SELECTED};
            bins selected_to_not_selected = (SLAVE_SELECTED => SLAVE_NOT_SELECTED);
            bins not_selected_to_selected = (SLAVE_NOT_SELECTED => SLAVE_SELECTED);
        }
        tx_valid_cp: coverpoint ram_seq_item_cov.tx_valid {
            bins valid = {VALID};
            bins not_vaild = {NOT_VALID};
            bins valid_to_not_vaild = (VALID => NOT_VALID);
            bins not_valid_to_vaild = (NOT_VALID => VALID);
        }
        dout_cp: coverpoint ram_seq_item_cov.dout {
            bins zero    = {ZERO};
            bins alt_10  = {ALT_10_DOUT};
            bins alt_01  = {ALT_01_DOUT};
            bins maximum = {MAXIMUM_DOUT};
            bins others = {[1:MAXIMUM_DOUT-1]} with (
                                                !(item == ALT_01_DOUT || item == ALT_10_DOUT)
                                            );
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
        SS_n_MOSI_cr: cross SS_n_cp, MOSI_cp {
            bins selected_with_data = binsof(SS_n_cp.slave_selected) && binsof(MOSI_cp.active);
            bins not_selected_with_data = binsof(SS_n_cp.slave_not_selected) && binsof(MOSI_cp.active);
            bins selected_with_no_data = binsof(SS_n_cp.slave_selected) && binsof(MOSI_cp.inactive);
            bins not_selected_with_no_data = binsof(SS_n_cp.slave_not_selected) && binsof(MOSI_cp.inactive);
            option.cross_auto_bin_max = 0;
        }
        rx_valid_data_cr: cross rx_valid_cp, rx_data_cp {
            bins valid_zero    = binsof(rx_valid_cp.valid) && binsof(rx_data_cp.zero);
            bins valid_alt_10  = binsof(rx_valid_cp.valid) && binsof(rx_data_cp.alt_10);
            bins valid_alt_01  = binsof(rx_valid_cp.valid) && binsof(rx_data_cp.alt_01);
            bins valid_maximum = binsof(rx_valid_cp.valid) && binsof(rx_data_cp.maximum);
            bins valid_others  = binsof(rx_valid_cp.valid) && binsof(rx_data_cp.others);

            bins not_valid_zero    = binsof(rx_valid_cp.not_vaild) && binsof(rx_data_cp.zero);
            bins not_valid_alt_10  = binsof(rx_valid_cp.not_vaild) && binsof(rx_data_cp.alt_10);
            bins not_valid_alt_01  = binsof(rx_valid_cp.not_vaild) && binsof(rx_data_cp.alt_01);
            bins not_valid_maximum = binsof(rx_valid_cp.not_vaild) && binsof(rx_data_cp.maximum);
            bins not_valid_others  = binsof(rx_valid_cp.not_vaild) && binsof(rx_data_cp.others);
            option.cross_auto_bin_max = 0;
        }
    endgroup : spi_cov_grp

    // Constructor
    function new (string name = "SPI_coverage", uvm_component parent);
        super.new(name, parent);
        spi_cov_grp = new();
    endfunction : new

    // Build Phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        slave_cov_export = new("slave_cov_export", this);
        slave_cov_spi = new("slave_cov_spi", this);
        ram_cov_export = new("ram_cov_export", this);
        ram_cov_spi = new("ram_cov_spi", this);
    endfunction : build_phase

    // Connect Phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        slave_cov_export.connect(slave_cov_spi.analysis_export);
        ram_cov_export.connect(ram_cov_spi.analysis_export);
    endfunction : connect_phase

    // Run Phase
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            ram_cov_spi.get(ram_seq_item_cov);
            slave_cov_spi.get(slave_seq_item_cov);
            spi_cov_grp.sample();
        end
    endtask : run_phase

endclass : SPI_coverage

`endif // SPI_COVERAGE_SV