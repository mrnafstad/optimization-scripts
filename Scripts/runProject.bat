@echo off
setlocal

echo %*
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
set "openInWsl="

REM Parse the arguments
shift
shift

REM Determine what var1, var2, and var3 are
for %%V in (%*) do (
    if "%%~V"=="m" (
        set "checkoutMain=m"
    ) else if "%%~V"=="o" (
        set "runYarnFlag=o"
    ) else if "%%V"=="w" (
        set "openInWsl=w"
    ) else (
        set "env=%%~V"
    )
)

REM Set variables
set "wtProfile=cmd"  
REM Update this to match your profile
set "wtPath=%USERPROFILE%\AppData\Local\Microsoft\WindowsApps\wt.exe"

REM Prepare the command to run git_merge
set "gitMergeCommand=gitMerge.bat %checkoutMain%"
set "yarnCommand=runYarn.bat %env%"


if "%openInWsl%"=="w" (
    set "combinedCommands=%gitMergeCommand%"
    if not "%runYarnFlag%"=="o" (
        set "combinedCommands=%combinedCommands% && %yarnCommand%"
    )   
    echo Running %combinedCommands%
    Rem split and open in WSL
    %wtPath% split-pane -p wsl bash -c "cd %projectPath% && cmd.exe /c %combinedCommands% && code ."
)  else (
    set "combinedCommands=call "%gitMergeCommand%""
    if not "%runYarnFlag%"=="o" (
        set "combinedCommands=%combinedCommands% && call "%yarnCommand%""
    )   
    echo Running %gitMergeCommand% and %yarnCommand%
    REM Use wt to split the current tab
    %wtPath% split-pane -p "%wtProfile%" -d "%projectPath%" cmd /k "%combinedCommands%"
    REM Open VS Code in the project folder
    code %codePath%

    echo Running '%yarnCommand%' in '%projectPath%'
)
endlocal
