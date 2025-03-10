@echo off
setlocal enabledelayedexpansion

REM Define the output file path (HTML content only)
set OUTPUT_FILE=%~dp0git_last_commit_info.html

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

REM Step 5: Get the list of changed files
(
    echo Changed Files:
    git diff-tree --no-commit-id --name-status -r %LAST_COMMIT%
) > "%TEMP_DIFF_FILES%"

REM Step 6: Write HTML content (no <html>, <body>, etc.)
(
    echo ^<div class="commit-info"^>

    echo ^<div class="commit-row"^>^<h5^>Repository:^</h5^> ^<span^>!REPO_NAME!^</span^>^</div^>
    echo ^<div class="commit-row"^>^<h5^>Commit Hash:^</h5^> ^<span^>!LAST_COMMIT!^</span^>^</div^>
    echo ^<div class="commit-row"^>^<h5^>Commit Message:^</h5^> ^<span^>!COMMIT_MESSAGE!^</span^>^</div^>
    echo ^<div class="commit-row"^>^<h5^>Commit Date:^</h5^> ^<span^>!COMMIT_DATE!^</span^>^</div^>

    echo ^<div class="commit-row"^>^<h5^>Changed Files:^</h5^>^</div^>
    echo ^<div class="commit-files"^>
) > "%OUTPUT_FILE%"

REM Append file changes to the HTML output
for /f "tokens=1,2*" %%i in ('git diff-tree --no-commit-id --name-status -r %LAST_COMMIT%') do (
    set "FILE_STATUS=%%i"
    set "FILE_NAME=%%j"
    echo ^<div class="file-row"^>^<span^>!FILE_STATUS!^</span^> ^<span^>!FILE_NAME!^</span^>^</div^> >> "%OUTPUT_FILE%"
)

REM Close HTML tags
(
    echo ^</div^>
    echo ^</div^>
) >> "%OUTPUT_FILE%"

REM Step 7: Clean up temporary files
del "%TEMP_COMMIT_HASH%" "%TEMP_COMMIT_MSG%" "%TEMP_COMMIT_DATE%" "%TEMP_DIFF_FILES%"

endlocal
