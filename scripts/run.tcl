exec g++ -shared -fPIC -o "design/SPI_design/Golden Models/golden_model.dll" "design/SPI_design/Golden Models/golden_model.cpp"
vlib work
vlog  -f "scripts/list.f" -mfcu +cover -covercells
vsim -sv_seed random -voptargs=+acc -sv_lib "design/SPI_design/Golden Models/golden_model" work.tb_top -cover -classdebug -uvmcontrol=all -fsmdebug

#*******************************************#
# Code Coverage
coverage save top.ucdb -onexit -du work.SPI_slave -du work.RAM_Sync_Single_port
#*******************************************#
vcd file waves/waves.vcd
vcd add -r /* 
run -all
#*******************************************#
# Functional Coverage Report
coverage report -detail -cvg -directive \
    -output "reports/Functional Coverage Report.txt" \
    /SPI_env_pkg/SPI_coverage/spi_cov_grp

coverage report -detail -cvg -directive \
    -html -output "reports/Functional Coverage Report" \
    /SPI_env_pkg/SPI_coverage/spi_cov_grp

#*******************************************#
quit -sim
# Save Coverage Report
vcover report top.ucdb -details -annotate -all -output "reports/Coverage Report - Code, Assertions, and Directives.txt"
vcover report top.ucdb -details -annotate -html -output "reports/Coverage Report - Code, Assertions, and Directives"