@echo off
setlocal enabledelayedexpansion

REM Define the output file path in the same directory as the script
set OUTPUT_FILE=%~dp0git_last_commit_info.txt

REM Define paths for temporary files
set TEMP_COMMIT_HASH=%~dp0temp_commit_hash.txt
set TEMP_COMMIT_MSG=%~dp0temp_commit_msg.txt
set TEMP_COMMIT_DATE=%~dp0temp_commit_date.txt
set TEMP_DIFF_FILES=%~dp0temp_diff_files_formatted.txt

REM Step 1: Get the repository name (the current folder name)
for %%i in (.) do set REPO_NAME=%%~nxi

REM Step 2: Get the last commit hash
git log -1 --pretty=format:"%%H" > "%TEMP_COMMIT_HASH%"
set /p LAST_COMMIT=<"%TEMP_COMMIT_HASH%"

REM Step 3: Get the commit message
git log -1 --pretty=format:"%%s" > "%TEMP_COMMIT_MSG%"
set /p COMMIT_MESSAGE=<"%TEMP_COMMIT_MSG%"

REM Step 4: Get the commit date
git log -1 --pretty=format:"%%ci" > "%TEMP_COMMIT_DATE%"
set /p COMMIT_DATE=<"%TEMP_COMMIT_DATE%"

REM Step 5: Get the list of diffed files and format with indentation
echo Changed Files: > "%TEMP_DIFF_FILES%"
for /f "tokens=1,2*" %%i in ('git diff-tree --no-commit-id --name-status -r %LAST_COMMIT%') do (
    set "FILE_STATUS=%%i"
    set "FILE_NAME=%%j"
    
    REM Output the file name with its status description, indented
    echo !FILE_STATUS!    !FILE_NAME! >> "%TEMP_DIFF_FILES%"
)
echo dug
REM Step 6: Save the information in a formatted way to the output file
(
    echo Repository: !REPO_NAME!
    echo Commit Hash: !LAST_COMMIT!
    echo Commit Message: !COMMIT_MESSAGE!
    echo Commit Date: !COMMIT_DATE!
    type "!TEMP_DIFF_FILES!"
) > "%OUTPUT_FILE%"
echo dug2

REM Step 7: Clean up temporary files
if exist "%TEMP_COMMIT_HASH%" del "%TEMP_COMMIT_HASH%"
if exist "%TEMP_COMMIT_MSG%" del "%TEMP_COMMIT_MSG%"
if exist "%TEMP_COMMIT_DATE%" del "%TEMP_COMMIT_DATE%"
if exist "%TEMP_DIFF_FILES%" del "%TEMP_DIFF_FILES%"

endlocal
