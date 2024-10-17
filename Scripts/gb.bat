@echo off

REM Check if the branch already exists
git rev-parse --verify %~1 >nul 2>&1
if errorlevel 0 (
    echo Branch %~1 exists. Checking it out...
    git checkout %~1
) else (
    echo Branch %~1 does not exist. Creating a new branch...

    REM Call gitMerge.bat with 'm' before creating the new branch
    echo Checking out and updating main branch to start the new branch fresh...
    call gitMerge.bat m

    git checkout -b %~1
)