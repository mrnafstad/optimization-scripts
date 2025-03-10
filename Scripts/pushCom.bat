@echo off
setlocal

REM Add all changes to the staging area
echo git add .
git add .

REM Check if Commitizen (cz) is available
where cz >nul 2>&1
if %errorlevel% equ 0 (
    REM Use Commitizen for commit if available
    echo Commitizen is available. Using Commitizen to create the commit.
    git cz 
) else (
    REM Commit with the message passed as an argument
    echo Commitizen is not available. Falling back to manual commit.
    set /p commitMessage="> "
            
    REM If the user didn't provide a commit message, set a default one
    if "!commitMessage!"=="" (
        set "commitMessage=Quick commit"
    )
    echo Commit message:  !commitMessage!
    echo git commit -m "!commitMessage!"
    git commit -m "!commitMessage!"
)

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
echo sda
call saveLastCommit.bat
endlocal