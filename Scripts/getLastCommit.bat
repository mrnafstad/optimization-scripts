@echo off
setlocal
set OUTPUT_FILE=%~dp0git_last_commit_info.txt

:: Check if the info file exists
if not exist "%OUTPUT_FILE%" (
    echo No commit information saved yet.
    exit /b
)

:: Display the information in a compact and pretty way
echo ===============================
echo   Last Commit Information
echo ===============================
type %OUTPUT_FILE%
echo ===============================

endlocal
