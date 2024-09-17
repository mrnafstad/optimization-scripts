@echo off

call "%~dp0Scripts\printGoodMorning.bat"
echo.

REM Start Microsoft Outlook
start "" "%ProgramFiles%\Microsoft Office\root\Office16\OUTLOOK.EXE"

REM Start Slack
start "" "%LOCALAPPDATA%\slack\slack.exe"

REM Start Google Chrome
start "" "%ProgramFiles%\Google\Chrome\Application\chrome.exe"
