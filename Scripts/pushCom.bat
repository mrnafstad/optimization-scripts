@echo off
setlocal

REM Add all changes to the staging area
echo git add .
git add .

REM Commit with the message passed as an argument
echo git commit -m "%*"
git commit -m "%*"

REM Check if the current branch has an upstream branch
git rev-parse --abbrev-ref --symbolic-full-name @{u} >nul 2>&1
if %errorlevel% neq 0 (
    echo No upstream branch
    echo git push --set-upstream origin HEAD
    git push --set-upstream origin HEAD
) else (
    echo git push
    git push
)

endlocal