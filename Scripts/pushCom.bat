setlocal

REM Add all changes to the staging area
git add .

REM Commit with the message passed as an argument
git commit -m "%*"

@echo off
REM Check if the current branch has an upstream branch
git rev-parse --abbrev-ref --symbolic-full-name @{u} >nul 2>&1
if %errorlevel% neq 0 (
    echo No upstream branch, setting upstream and pushing...
    git push --set-upstream origin HEAD
) else (
    git push
)

endlocal