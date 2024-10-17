@echo off
setlocal enabledelayedexpansion

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

REM Check for uncommitted changes
git diff-index --quiet HEAD --
if errorlevel 1 (
    echo There are uncommitted changes in your working directory.

    REM Check if the current branch is the default branch
    if "%currentBranch%"=="%defaultBranch%" (
        echo You are currently on the default branch: %defaultBranch% and you should not commit changes directly to the default branch.
        echo Please choose an option:
        echo 1. Create a new branch and commit the changes there.
        echo 2. Reset the default branch to the remote HEAD, discarding local changes.
        
        set /p choice="Enter your choice (1 or 2): "

        if "%choice%"=="1" (
            set /p newBranchName="Enter new branch name: "
            echo Creating a new branch...
            call gb.bat "%newBranchName%"
            if errorlevel 1 (
                echo Failed to create a new branch. Aborting operation.
                exit /b 1
            )
        ) else if "%choice%"=="2" (
            echo Resetting the default branch to match the remote HEAD...
            git reset --hard origin/%defaultBranch%
            if errorlevel 1 (
                echo Failed to reset the branch. Aborting operation.
                exit /b 1
            )
        ) else (
            echo Invalid choice. Aborting operation.
            exit /b 1
        )
    ) else (
        echo You need to commit and push your changes before proceeding. 
        echo Review the changes and provide a commit message:
        set /p commitMessage="> "
        
        REM If the user didn't provide a commit message, set a default one
        if "%commitMessage%"=="" (
            set "commitMessage=Quick commit"
        )

        call pushcom.bat "%commitMessage%"

        if errorlevel 1 (
            echo Commit and push failed. Aborting operation.
            exit /b 1
        )
    )
) else (
    echo No uncommitted changes detected.
)
