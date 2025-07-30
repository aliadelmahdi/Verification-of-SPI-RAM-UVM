`ifndef SPI_SLAVE_SEQUENCES
`define SPI_SLAVE_SEQUENCES

    `include "SPI_slave_reset_sequence.sv"
    `include "SPI_slave_main_sequence.sv"
    `include "SPI_slave_read_data_sequence.sv"
    `include "SPI_slave_write_data_sequence.sv"
    `include "SPI_slave_mix_sequence.sv"

`endif // SPI_SLAVE_SEQUENCES
