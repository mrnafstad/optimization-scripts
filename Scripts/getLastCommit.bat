@echo off
setlocal

:: Check if the info file exists
if not exist C:\git_last_commit_info.txt (
    echo No commit information saved yet.
    exit /b
)

:: Display the information in a compact and pretty way
echo ===============================
echo   Last Commit Information
echo ===============================
type C:\git_last_commit_info.txt
echo ===============================

endlocal
