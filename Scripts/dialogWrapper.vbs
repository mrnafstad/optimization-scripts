Dim objShell, objFSO, objFile, strTitle, strOutput, htmlPath, yesAction, params, fullUrl
Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")

' === Step 1: Get Title from printGoodMorning.bat ===
Dim objExec
objShell.Exec("cmd /c C:\Users\halnaf\Documents\optimization-scripts\Scripts\startApps.bat")
objShell.Run "cmd /c timeout /t 1 /nobreak", 0, True
Set objExec = objShell.Exec("cmd /c C:\Users\halnaf\Documents\optimization-scripts\Scripts\printGoodMorning.bat")



' Read first line as the title
If Not objExec.StdOut.AtEndOfStream Then
    strTitle = objExec.StdOut.ReadLine()
Else
    strTitle = "Latest Commit Details" ' Default title
End If

' === Step 2: Read Content from message.txt ===
Dim messageFile
messageFile = "C:\Users\halnaf\Documents\optimization-scripts\Scripts\git_last_commit_info.txt"

If objFSO.FileExists(messageFile) Then
    Set objFile = objFSO.OpenTextFile(messageFile, 1) ' Open in read mode
    strOutput = objFile.ReadAll ' Read full content
    objFile.Close
Else
    strOutput = "<p>No commit details available.</p>" ' Default message if file is missing
End If

' === Step 3: Define Action for "Yes" Button ===
yesAction = "file:///C:/Users/halnaf/Documents/optimization-scripts/Scripts/startApps.vbs"

' === Step 4: Prepare HTML File Path & Encode Parameters ===
htmlPath = "file:///C:/Users/halnaf/Documents/optimization-scripts/Scripts/customDialog.html"
params = "?title=" & EncodeParam(strTitle) & "&content=" & EncodeParam(strOutput) & "&yesAction=" & EncodeParam(yesAction)

' === Step 5: Debug - Show URL in Message Box ===
fullUrl = htmlPath & params
' MsgBox "Opening URL: " & fullUrl, vbInformation, "Debug Info"

' === Step 6: Open in Default Browser ===
objShell.Run "chrome """ & fullUrl & """", 1, False

' Cleanup
Set objFile = Nothing
Set objFSO = Nothing
Set objShell = Nothing

' === Function: Encode URL Parameters (Fixes Spaces, Special Characters & Newlines) ===
Function EncodeParam(param)
    param = Replace(param, "%", "%25")  ' Encode %
    param = Replace(param, "'", "%27")  ' Encode '
    param = Replace(param, "’", "%27")  ' Encode ’
    param = Replace(param, "-", "%2D")  ' Encode -
    param = Replace(param, " ", "%20")  ' Encode spaces
    param = Replace(param, "&", "%26")  ' Encode &
    param = Replace(param, "=", "%3D")  ' Encode =
    param = Replace(param, """", "%22") ' Encode "
    param = Replace(param, "'", "%27")  ' Encode '
    param = Replace(param, "<", "%3C")  ' Encode <
    param = Replace(param, ">", "%3E")  ' Encode >
    param = Replace(param, vbCrLf, "%0A") ' Encode newlines
    EncodeParam = param
End Function
