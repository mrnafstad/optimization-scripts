@echo off
REM Path to common batch file
set "commonScript=runProject.bat"

REM Call the common batch file with identical codePath and projectPath
call "%commonScript%" "C:\Users\halnaf\Documents\workspace\web-core" "" %*

call handleLocalEnv.bat %*