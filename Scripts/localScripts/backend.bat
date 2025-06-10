@echo off

REM Path to common batch file
set "commonScript=runProject.bat"

REM Call the common batch file with identical codePath and projectPath
call "%commonScript%" "/mnt/c/home/mrnafstad/attensi-backend" "" w d %*

