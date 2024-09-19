@echo off
setlocal enabledelayedexpansion

REM Check if the current branch is behind its remote counterpart
set "pullRequired=false"
for /f "tokens=*" %%i in ('git status -uno') do (
    echo %%i | findstr /C:"Your branch is behind"
    if not errorlevel 1 (
        set "pullRequired=true"
    )
)

REM If pull is required, pull the latest changes
if "%pullRequired%"=="true" (
    echo Your branch is behind the remote branch.
    echo Pulling the latest changes from origin...
    git pull origin %currentBranch%
    if errorlevel 1 (
        echo Pull failed. Please resolve conflicts manually.
        exit /b 1
    ) else (
        echo Latest changes pulled.
    )

) else (
    echo Your branch is up to date with the remote branch.
)

endlocal