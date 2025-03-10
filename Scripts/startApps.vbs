Dim objShell
Set objShell = CreateObject("WScript.Shell")

' Start Microsoft Outlook
objShell.Run """C:\Program Files\Microsoft Office\root\Office16\OUTLOOK.EXE""", 0, False

' Start Slack
objShell.Run """C:\Users\" & CreateObject("WScript.Network").UserName & "\AppData\Local\slack\slack.exe""", 0, False

' Start Google Chrome
objShell.Run """C:\Program Files\Google\Chrome\Application\chrome.exe""", 0, False

' Cleanup
Set objShell = Nothing
