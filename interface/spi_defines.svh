`ifndef SPI_DEFINES_SVH
`define SPI_DEFINES_SVH

    // Basic logic levels
    `define LOW 0
    `define HIGH 1

    // ON/OFF control
    `define ON 1
    `define OFF  0

    // ON/OFF control for active low signals
    `define ON_n 0
    `define OFF_n  1

    // Simulation control
    `define DISABLE_FINISH 0  // Keep Questa simulation running
    `define ENABLE_FINISH 1   // Close Questa simulation when done

    // Clock period definition
    `define CLK_PERIOD 10  // Clock period in time units

    // Test iterations
    `define TEST_ITER_SMALL   100    // Small number of iterations
    `define TEST_ITER_MEDIUM  1_000   // Medium-sized test
    `define TEST_ITER_LARGE   5_000  // Large-scale test
    `define TEST_ITER_STRESS  10_000 // Stress test

    // Timescale control
    `define TIME_UNIT 1ps
    `define TIME_PRECISION 1ps

    `define display_separator \
            $display("====================================================================================");

    // Constraint Mode ON/OFF
    `define enable_constraint(constraint) \
            seq_item.constraint.constraint_mode(`ON);
    `define disable_constraints  \
            seq_item.constraint_mode(`OFF);
    `define enable_constraints  \
            seq_item.constraint_mode(`ON);
    `define disable_constraint(constraint) \
            seq_item.constraint.constraint_mode(`OFF);
`endif
