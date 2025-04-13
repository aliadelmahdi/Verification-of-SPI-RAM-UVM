@echo off
cd /d "%~dp0\.."
echo Current directory is: %CD%

rem Open a new command prompt tab, minimize it, and run tclsh waves/run.tcl
start /min cmd /c "tclsh waves/run.tcl"