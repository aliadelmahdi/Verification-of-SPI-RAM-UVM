# Compile the C++ DPI-C file (Golden Model) into a shared library
# exec g++ -shared -fPIC -o "design/SPI_design/Golden Models/dpi_memory.dll" "design/SPI_design/Golden Models/dpi_memory.cpp"
vlib work
vlog +incdir+./interface -f "scripts/list.list" -mfcu +cover -covercells
# Enable the transcript (even in the compile version of questa sim)
# transcript on
# transcript file scripts/uvm_transcript.log
# Start Simulation with C++ golden model
# vsim -voptargs=+acc -sv_lib "design/SPI_design/Golden Models/dpi_memory" work.tb_top -cover -classdebug -uvmcontrol=all -fsmdebug 

vsim -voptargs=+acc work.tb_top -cover -classdebug -uvmcontrol=all -fsmdebug 
log -r /*
# # Add signals to the wave window
add wave /tb_top/RAM/*
add wave /tb_top/slave/*
# Code Coverage
coverage save top.ucdb -onexit -du work.RAM_Sync_Single_port -du work.SPI_slave

vcd file waves/waves.vcd
vcd add -r /* 
run -all
# Disable the transcript
# transcript off
vcd flush
# Functional Coverage Report
coverage report -detail -cvg -directive  \
    -output "reports/Functional Coverage Report.txt" \
    /SPI_coverage_pkg/SPI_coverage/*
# quit -sim
# Save Coverage Report
vcover report top.ucdb -details -annotate -all -output "reports/Coverage Report - Code, Assertions, and Directives.txt"