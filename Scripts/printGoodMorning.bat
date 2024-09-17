@echo off

REM Save the current code page
for /f "tokens=2 delims=:" %%A in ('chcp ^| find ":"') do set "origCodePage=%%A"

chcp 65001>nul

REM Path to the text file with messages
set messageFile=C:\Users\halnaf\Documents\Scripts\goodMornings.txt

REM Count the number of lines in the message file
for /f %%A in ('find /c /v "" ^< %messageFile%') do set numMessages=%%A

REM Generate a random number between 1 and the number of messages
set /a randNum=%random% %% %numMessages% + 1

REM Read the random line from the text file and display the message
for /f "tokens=*" %%A in ('more +%randNum% %messageFile%') do (
    echo %%A
    goto showMessage
)

:showMessage

REM Reset the code page to the original setting
chcp %origCodePage% >nul