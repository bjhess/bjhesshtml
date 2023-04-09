Set fso = CreateObject("Scripting.FileSystemObject")
Dim pictureFolder
pictureFolder = InputBox("Please enter the folder path for your pictures:", _
					"Enter folder path", _
					"W:\DCIM\102CANON")
Set f = fso.GetFolder(pictureFolder)
Dim folderFound
For Each file In f.Files
	Dim flDate, folderName, pictureFolderName, flTime, extensionIndex, extension
	
	'Set up date string for the current picture
	flDate = GetFileDate(file.DateCreated)
	
	'Set up time string for the current picture
	flTime = GetFileTime(file.DateCreated)

	folderName = flDate
	pictureFolderName = "M:\photos\family\full_quality\"

	Set pictureOutputFolder = fso.GetFolder(pictureFolderName)
	folderFound = false
	'could use recursion to get all the files
	For Each folder in pictureOutputFolder.SubFolders
		Dim existingFolderName
		existingFolderName = folder.Name
		'MsgBox existingFolderName & " " & folderName
		If existingFolderName = folderName Then
			folderFound = true
		End If
	Next

	If folderFound = false Then
		fso.CreateFolder pictureFolderName & folderName
	End If
	
	extensionIndex = InStrRev(file.Name, ".")
	extension = Mid(file.Name, extensionIndex)
	file.Copy LCase(pictureFolderName & folderName & "\" & folderName & "(" & flTime & ")" & extension)
Next
MsgBox "Copy of " & pictureFolder & " completed!", _
		vbOK, _
		"Copy completed"

Function GetFileDate(fileDate)
	fileYear = Year(fileDate)
	fileMonth = Month(fileDate)
	If CInt(fileMonth) < 10 Then
		fileMonth = "0" & fileMonth
	End If
	fileDay = Day(fileDate)
	If CInt(fileDay) < 10 Then
		fileDay = "0" & fileDay
	End If

	GetFileDate = fileYear & "-" & fileMonth & "-" & fileDay
End Function

Function GetFileTime(fileDate)
	fileTime = Replace(FormatDateTime(fileDate, vbShortTime),":",".")
	fileSeconds = Second(fileDate)
	If CInt(fileSeconds) < 10 Then
		fileSeconds = "0" & fileSeconds
	End If
	GetFileTime = fileTime & "." & fileSeconds
End Function
