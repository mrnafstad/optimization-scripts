@echo off
setlocal enabledelayedexpansion

:: Step 1: Get the repository name (the current folder name)
for %%i in (.) do set REPO_NAME=%%~nxi

:: Step 2: Get the last commit hash
for /f %%i in ('git log -1 --pretty=format:"%%H"') do set LAST_COMMIT=%%i

:: Step 3: Get the commit message
for /f "tokens=*" %%i in ('git log -1 --pretty=format:"%%s"') do set COMMIT_MESSAGE=%%i

:: Step 4: Get the commit date
for /f "tokens=*" %%i in ('git log -1 --pretty=format:"%%ci"') do set COMMIT_DATE=%%i

:: Step 5: Get the list of diffed files
set DIFF_FILES=
for /f "tokens=*" %%i in ('git diff-tree --no-commit-id --name-only -r %LAST_COMMIT%') do (
    set DIFF_FILES=!DIFF_FILES!%%i, 
)

:: Remove trailing comma and space from DIFF_FILES
set DIFF_FILES=%DIFF_FILES:~0,-2%

:: Step 6: Save the information in a formatted way to a static file
(
    echo Repository: %REPO_NAME%
    echo Commit Hash: %LAST_COMMIT%
    echo Commit Message: %COMMIT_MESSAGE%
    echo Commit Date: %COMMIT_DATE%
    echo Changed Files: %DIFF_FILES%
) > C:\git_last_commit_info.txt

echo Commit information saved successfully.

endlocal
