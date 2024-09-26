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

REM Determine what var1, var2, and var3 are
for %%V in (%*) do (
    if "%%~V"=="m" (
        set "checkoutMain=m"
    ) else if "%%~V"=="o" (
        set "runYarnFlag=o"
    ) else if "%%~V"=="w" (
        set "wslFlag=w"
    ) else if "%%V"=="d" (
        set "dockerFlag=d"
    ) else (
        set "env=%%~V"
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
set "combinedCommands=call gitMerge.bat \"%checkoutMain%\""

REM Conditionally add runYarn if runYarnFlag is not "o"
if not "%runYarnFlag%"=="o" (
    set "combinedCommands=%combinedCommands% & call runYarn.bat \"%env%\""
)

REM Use wt to split the current tab
%wtPath% split-pane -p "%wtProfile%" -d "%projectPath%" cmd /k "%combinedCommands%"

REM Open VS Code in the project folder
code %codePath%

echo Running '%yarnCommand%' in '%projectPath%'

endlocal
