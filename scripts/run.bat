@echo off
cd /d "%~dp0\.."
echo Current directory is: %CD%
vsim -c -do "scripts/run.tcl"
cmd /k