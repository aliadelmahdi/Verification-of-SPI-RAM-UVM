vlib work
vlog +incdir+./interface -f "scripts/list.list" -mfcu +cover -covercells
vsim -sv_seed random -voptargs=+acc work.tb_top -cover -classdebug -uvmcontrol=all -fsmdebug
#*******************************************#
# Code Coverage
coverage save top.ucdb -onexit -du work.SPI_slave -du work.RAM_Sync_Single_port
#*******************************************#
vcd file waves/waves.vcd
vcd add -r /* 
run -all
#*******************************************#
# Functional Coverage Report
coverage report -detail -cvg -directive  \
    -output "reports/Functional Coverage Report.txt" \
    /SPI_coverage_pkg/SPI_coverage/*
#*******************************************#
quit -sim
# Save Coverage Report
vcover report top.ucdb -details -annotate -all -output "reports/Coverage Report - Code, Assertions, and Directives.txt"