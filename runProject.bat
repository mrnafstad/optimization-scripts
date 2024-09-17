@echo off
setlocal

REM Function Parameters
set "projectPath=%~1"
set "codePath=%~2"
set "env=%~3"
set "checkoutMain=%~4"

REM If codePath is not provided, use projectPath as codePath
if "%codePath%"=="" (
    set "codePath=%projectPath%"
)

REM Set variables
set "wtProfile=cmd"  REM Update this to match your profile
set "wtPath=%USERPROFILE%\AppData\Local\Microsoft\WindowsApps\wt.exe"

REM Prepare the command to run both git_merge and yarnCommand
set "combinedCommands=call gitMerge.bat \"%checkoutMain%"\ & call runYarn.bat "%env%""

REM Use wt to split the current tab
%wtPath% split-pane -p "%wtProfile%" -d "%projectPath%" cmd /k "%combinedCommands%"

REM Open VS Code in the project folder
code %codePath%

echo Running '%yarnCommand%' in '%projectPath%'

endlocal
