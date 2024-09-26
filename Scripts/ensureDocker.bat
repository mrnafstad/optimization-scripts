@echo off
REM Check if Docker is running
docker info >nul 2>&1

if errorlevel 1 (
    echo Docker is not running. Starting Docker...
    start /min "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"
    REM Wait a few seconds for Docker to start
    timeout /t 10 >nul
    REM Check again if Docker is running
    docker info >nul 2>&1
    if errorlevel 1 (
        echo Docker failed to start. Please check Docker installation.
        exit /b 1
    ) else (
        echo Docker is now running.
        exit /b 0
    )
) else (
    echo Docker is already running.
    exit /b 0
)