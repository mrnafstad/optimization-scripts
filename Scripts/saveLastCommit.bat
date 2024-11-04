@echo off
setlocal enabledelayedexpansion

:: Define the output file path in the same directory as the script
set OUTPUT_FILE=%~dp0git_last_commit_info.txt

:: Step 1: Get the repository name (the current folder name)
for %%i in (.) do set REPO_NAME=%%~nxi

:: Step 2: Get the last commit hash
git log -1 --pretty=format:"%%H" > temp_commit_hash.txt
set /p LAST_COMMIT=<temp_commit_hash.txt

:: Step 3: Get the commit message
git log -1 --pretty=format:"%%s" > temp_commit_msg.txt
set /p COMMIT_MESSAGE=<temp_commit_msg.txt

:: Step 4: Get the commit date
git log -1 --pretty=format:"%%ci" > temp_commit_date.txt
set /p COMMIT_DATE=<temp_commit_date.txt

:: Step 5: Get the list of diffed files and format with indentation
echo Changed Files: > temp_diff_files_formatted.txt
for /f "tokens=1,2*" %%i in ('git diff-tree --no-commit-id --name-status -r %LAST_COMMIT%') do (
    set "FILE_STATUS=%%i"
    set "FILE_NAME=%%j"
    
    :: Output the file name with its status description, indented
    echo     !FILE_NAME! (!FILE_STATUS!) >> temp_diff_files_formatted.txt

:: Step 6: Save the information in a formatted way to the output file
(
    echo Repository: %REPO_NAME%
    echo Commit Hash: %LAST_COMMIT%
    echo Commit Message: %COMMIT_MESSAGE%
    echo Commit Date: %COMMIT_DATE%
    type temp_diff_files_formatted.txt
) > "%OUTPUT_FILE%"

:: Clean up temporary files
del temp_commit_hash.txt temp_commit_msg.txt temp_commit_date.txt temp_diff_files_formatted.txt

endlocal
