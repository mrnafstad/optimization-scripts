@echo off

echo.
call "C:\Users\halnaf\Documents\Scripts\printGoodMorning.bat"
echo.

REM Start Microsoft Outlook
start "" "C:\Program Files\Microsoft Office\root\Office16\OUTLOOK.EXE"

REM Start Slack
start "" "C:\Users\halnaf\AppData\Local\slack\slack.exe"

REM Start Google Chrome
start "" "C:\Program Files\Google\Chrome\Application\chrome.exe"

REM You can add more programs as needed in the same way
