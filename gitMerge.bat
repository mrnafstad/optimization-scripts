@echo off
setlocal enabledelayedexpansion

REM Fetch the latest changes from the remote repository
git fetch origin
if errorlevel 1 (
    echo Failed to fetch changes. Ensure git is installed and configured properly.
    exit /b 1
)

REM Check if a flag for checking out the default branch is provided
if "%~1"=="m" (
    set "checkOutDefault=true"
) else (
    set "checkOutDefault=false"
)


REM Determine the default branch (main or master)
set "defaultBranch=master"

REM Run git command and filter the HEAD branch line
for /f "tokens=2* delims=:" %%A in ('git remote show origin ^| findstr /c:"HEAD branch"') do (
    set "branchName=%%A"
)

REM Remove leading spaces from the extracted part
set "branchName=!branchName:~1!"
set "defaultBranch=%branchName%"

REM Get the current branch name
for /f "tokens=*" %%i in ('git branch --show-current') do set "currentBranch=%%i"
echo Current branch: %currentBranch%

if "%checkOutDefault%"=="true" (
    call checkoutDefault.bat
)

call pullBehind.bat

if "%defaultBranch%"=="%currentBranch%" (
    echo Currently on %defaultBranch%, nothing to merge.
    exit /b 0
) 

call mergeBehind.bat "%defaultBranch%" "%currentBranch%"
