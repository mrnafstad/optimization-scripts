@echo off
setlocal

REM Function Parameters
set "projectPath=%~1"
set "codePath=%~2"

REM If codePath is not provided, use projectPath as codePath
if "%codePath%"=="" (
    set "codePath=%projectPath%"
)

REM Default values
set "checkoutMain="
set "env="
set "runYarnFlag="
set "wslFlag="
set "dockerFlag="


for %%V in (3 4 5 6 7) do (
    call set "param=%%%V%%"
    if "!param!"=="m" (
        set "checkoutMain=m"
    ) else if "!param!"=="o" (
        set "runYarnFlag=o"
    ) else if "!param!"=="w" (
        set "wslFlag=w"
    ) else if "!param!"=="d" (
        set "dockerFlag=d"
    ) else (
        set "env=%param%"
    )
)



REM Set variables
set "wtProfile=cmd"  REM Update this to match your profile
set "wtPath=%USERPROFILE%\AppData\Local\Microsoft\WindowsApps\wt.exe"

if "%dockerFlag%"=="d" (
    %wtPath% split-pane --horizontal "%wtProfile%" cmd /c "ensureDocker.bat"
)

if "%wslFlag%"=="w" (
    %wtPath% split-pane -p wsl bash -c "cd /home/mrnafstad/attensi-backend && code . && bash"
    exit /b
)

REM Prepare the command to run git_merge
set "combinedCommands=call gitMerge.bat %checkoutMain%"

REM Conditionally add runYarn if runYarnFlag is not "o"
if not "%runYarnFlag%"=="o" (
    set "combinedCommands=%combinedCommands% & call runYarn.bat %env%"
)

echo %wtPath% split-pane -p "%wtProfile%" -d "%projectPath%" cmd /k "%combinedCommands%"
REM Use wt to split the current tab
%wtPath% split-pane -p "%wtProfile%" -d "%projectPath%" cmd /k "%combinedCommands%"

REM Open VS Code in the project folder
code %codePath%

echo Running '%yarnCommand%' in '%projectPath%'

endlocal
