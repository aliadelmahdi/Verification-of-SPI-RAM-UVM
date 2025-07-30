`ifndef SPI_ENV_SV
`define SPI_ENV_SV

class SPI_env extends uvm_env;
    `uvm_component_utils(SPI_env)

    SPI_ram_agent spi_ram_agent;
    SPI_slave_agent spi_slave_agent;

    SPI_scoreboard spi_sb;
    SPI_coverage spi_cov;
    
    // Default Constructor
    function new (string name = "SPI_env", uvm_component parent);
        super.new(name,parent);
    endfunction : new

    // Build Phase
    function void build_phase(uvm_phase phase );
    super.build_phase (phase);
        spi_ram_agent = SPI_ram_agent::type_id::create("spi_ram_agent",this);
        spi_slave_agent = SPI_slave_agent::type_id::create("spi_slave_agent",this);
        spi_sb= SPI_scoreboard::type_id::create("spi_sb",this);
        spi_cov= SPI_coverage::type_id::create("spi_cov",this);
    endfunction : build_phase

    // Connect Phase
    function void connect_phase (uvm_phase phase );
        spi_ram_agent.spi_ram_agent_ap.connect(spi_sb.ram_sb_export);
        spi_ram_agent.spi_ram_agent_ap.connect(spi_cov.ram_cov_export);
        spi_slave_agent.spi_slave_agent_ap.connect(spi_sb.slave_sb_export);
        spi_slave_agent.spi_slave_agent_ap.connect(spi_cov.slave_cov_export);
    endfunction : connect_phase

    // Run Phase
    task run_phase (uvm_phase phase);
        super.run_phase(phase);
    endtask : run_phase
    
endclass : SPI_env

`endif // SPI_ENV_SV