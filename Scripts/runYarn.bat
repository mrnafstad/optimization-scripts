@echo off
setlocal

echo Yarn automation begins...
REM Function Parameters
set "env=%~1"

REM Determine the yarn command based on the environment variable
set "yarnCommand=yarn dev"
if not "%env%"=="" (
    set "yarnCommand=%yarnCommand%:%env%"
)

REM Install dependencies and run the development server sequentially
yarn install && (
    
    REM Run the development server
    %yarnCommand%
) || (
    exit /b 0
)

endlocal

