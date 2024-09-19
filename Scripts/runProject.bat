@echo off
setlocal

REM Function Parameters
set "projectPath=%~1"
set "codePath=%~2"
set "var1=%~3"
set "var2=%~4"
set "var3=%~5"

REM If codePath is not provided, use projectPath as codePath
if "%codePath%"=="" (
    set "codePath=%projectPath%"
)

REM Default values
set "checkoutMain="
set "env="
set "runYarnFlag="

REM Determine what var1, var2, and var3 are
for %%V in ("%var1%" "%var2%" "%var3%") do (
    if "%%~V"=="m" (
        set "checkoutMain=m"
    ) else if "%%~V"=="o" (
        set "runYarnFlag=o"
    ) else (
        set "env=%%~V"
    )
)

REM Set variables
set "wtProfile=cmd"  REM Update this to match your profile
set "wtPath=%USERPROFILE%\AppData\Local\Microsoft\WindowsApps\wt.exe"

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
