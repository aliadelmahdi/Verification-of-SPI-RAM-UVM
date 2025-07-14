set +x
cd "$(dirname "$0")/.."
vsim -c -do "scripts/run.tcl"
