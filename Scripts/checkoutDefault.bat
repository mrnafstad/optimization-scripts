@echo off
setlocal

set "defaultBranch=%~1"

echo Checking out %defaultBranch%...
git checkout %defaultBranch%
if errorlevel 1 (
    echo Failed to check out branch %defaultBranch%. It might not exist.
    exit /b 1
)