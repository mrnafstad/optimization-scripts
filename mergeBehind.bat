@echo off
setlocal enabledelayedexpansion

set "defaultBranch=%~1"
set "currentBranch=%~2"

if "%defaultBranch%"=="%currentBranch%" (
    echo Currently on default branch, nothing to merge.
    exit /b 0
) 

REM Check if the current branch is behind the default branch
for /f "tokens=1,2" %%a in ('git rev-list --left-right --count %currentBranch%...origin/%defaultBranch%') do (
    set behind=%%b
    set ahead=%%a
)

REM If the current branch is not behind, exit the script
if "%behind%"=="0" (
    echo Your branch is up to date with %defaultBranch%. No merge required.
    exit /b 0
)

REM Ask the user if they want to merge changes from the default branch into the current branch
set /p "userResponse=Do you want to merge changes from origin/%defaultBranch% into your branch? (y/n): "

if /i "%userResponse%"=="y" (
    echo Merging changes from origin/%defaultBranch% into the current branch...
    git merge origin/%defaultBranch%
    if errorlevel 1 (
        echo Merge failed. Please resolve conflicts manually.
        exit /b 1
    ) else (
        echo Merge completed successfully.
    )
) else (
    echo Merge operation aborted.
)

endlocal