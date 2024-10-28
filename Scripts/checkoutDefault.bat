@echo off
setlocal

set "defaultBranch=%~1"

echo Checking out %defaultBranch%...
git checkout %defaultBranch%
git pull
if errorlevel 1 (
    echo Failed to check out branch %defaultBranch%. It might not exist.
    exit /b 1
)