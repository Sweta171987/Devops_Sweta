'$Id: nco_baroc2sql.vbs $
'nco_baroc2sql startup script for windows
'
'
NCO_JRE_MINIMUM_VERSION="1.6"

JAVA_REG_HOME="HKLM\SOFTWARE\JavaSoft\Java Runtime Environment\"
NCO_JAVAHOME="platform\win32"
NCO_JRE_REGEX="jre_.\..\.."

MSG_OMNIHOME_MISSING="ERROR: OMNIHOME is not defined."
MSG_NCHOME_MISSING="ERROR: NCHOME is not defined."

MSG_NO_JRE_FOUND="The Environment variable NCO_JRE is not defined, nor was the location of the JRE found in the registry." _
                  & vbCrLf & vbCrLf & _
		  "Please make sure that version " & _
		  NCO_JRE_MINIMUM_VERSION & _
		  " of the JRE is installed and that the environment variable NCO_JRE is set to the jre install directory"  

'
'			Return the version of java - eg. "1.6.0"
'
Function GetJavaVersion(JavaHome)
	On Error Resume Next

	'
	' We are only interested in the n.n.n portion of the
	' version. Any minor build version is accepted, as long as the
	' major jre release is correct. 
	'
	Set re = New RegExp
	re.Pattern = "[0-9]\.[0-9]\.[0-9]"

	'
	' Find the 'java' program in the given path to the JRE.
	' Execute with the -version flag.
	'
	cmd = """" & JavaHome & "\bin\java.exe" & """" & " -version"
	Set WshShell = WScript.CreateObject("WScript.Shell")
	Set oExec = WshShell.Exec(cmd)

	'
	' Version number is expected on the first output line.
	'
	str = oExec.StdErr.ReadLine
	Set matches = re.Execute(str)

	'
	' Only expect to find 1 match
	' 
	GetJavaVersion = matches.Item(0).Value
End Function

'
'			Retrieves the path for the java executable
'			from the registry.
'
Function GetJREFromRegistry
	On Error Resume Next
	Set WshShell = WScript.CreateObject("WScript.Shell")

	JavaVersion = WshShell.RegRead(JAVA_REG_HOME & "CurrentVersion")

	If IsEmpty(JavaVersion) Then
		Exit Function
	End If

	JavaHome = WshShell.RegRead(JAVA_REG_HOME & JavaVersion & "\JavaHome")
	GetJREFromRegistry = JavaHome
End Function

'
'			Find the latest JRE installed below a given root dir.
'
Function FindJRE(parentdir, pattern)
   On Error Resume Next
   Dim result

   Set re = New RegExp
   re.Pattern = pattern

   Set fso = CreateObject("Scripting.FileSystemObject")
   Set folder = fso.GetFolder(parentdir)
   Set subdirs = folder.SubFolders

   ' Find all subdirs with names that correspond to the regexp.
   ' Keep the 1 with the highest sort order.
   ' (Assumption is made that JRE versions are incorprated into
   '  directory names and are string sort correct. This routine will
   '  probably fail when we upgrade from jre_9.* to jre_10.*)
    
   For Each dir in subdirs
      If re.Test(dir.name) Then
	If dir.name > result Then
		result = dir.name 
	End If	
      End If	
   Next

   If Len(result) > 0 Then	
	' The IBM JREs come with extra legal text, so the JRE itself
	' is in a sub directory
	If fso.FolderExists(parentdir & "\" & result & "\jre") Then
		FindJRE = parentdir & "\" & result & "\jre"
	Else
		FindJRE = parentdir & "\" & result
	End If
   End If
End Function
'
'
'
Function Main
	On Error GoTo 0
	Set WshShell = WScript.CreateObject("WScript.Shell")
	Set fso = CreateObject("Scripting.FileSystemObject")

	'Get OMNIHOME and ensure it is without a trailing backslash.
	OMNIHOME=WshShell.Environment("PROCESS")("OMNIHOME")
	If Len(OMNIHOME) < 1 Then
		WScript.Echo MSG_OMNIHOME_MISSING
		Exit Function
	End If
	Set OMNIHOME = fso.GetFolder(OMNIHOME)

	'Get NCHOME and ensure it is without a trailing backslash.
	NCHOME = WshShell.Environment("PROCESS")("NCHOME") 
	If Len(NCHOME) < 1 Then
		WScript.Echo MSG_NCHOME_MISSING
		Exit Function
	End If
	Set NCHOME = fso.GetFolder(NCHOME)

	JAVAJARS = "\java\jars"

'	First try env var NCO_JRE which could override the JRE
'	installed with NCHOME.
'
	JRE = WshShell.Environment("PROCESS")("NCO_JRE")

'		
'	If no %NCO_JRE% set, try using JRE within NCHOME installation.
'
	If Len(JRE) < 1 Then
	    JRE = FindJRE(NCHOME & "\" & NCO_JAVAHOME, NCO_JRE_REGEX)
	End If

'
'	If no JRE within Netcool installation then
'	search for JRE specified in the Windows registry.
'
	If Len(JRE) < 1 Then
		JRE = GetJREFromRegistry
	End If

	If Len(JRE) < 1 Then
		WScript.Echo MSG_NO_JRE_FOUND
		Exit Function
	End If

	'
	' Test for a valid executable in JRE
	'
	YourVer = GetJavaVersion(JRE)
	If Len(YourVer) < 1 Then
		WScript.Echo "No valid java executable at: " & JRE
		Exit Function
	End If

	'
	' Verify that the JRE is the minimum version.
	'
	If YourVer < NCO_JRE_MINIMUM_VERSION Then
		WScript.Echo "nco_baroc2sql requires JRE " & _
				NCO_JRE_MINIMUM_VERSION & " (or higher)" & vbCrLf _
				& "You are running version " & YourVer
		Exit Function
	End If

	LOCALCLASSPATH=    OMNIHOME & JAVAJARS & "\baroctool.jar;" & _
			   OMNIHOME & JAVAJARS & "\utility.jar;" 

	'Construct Argument List - Add double quotes around every argument - this
	'protects against spaces in file paths.
	For i = 0 To WScript.Arguments.Count -1
		ArgList = ArgList & " " & """" & WScript.Arguments(i) & """"
	Next

	'We need to enclose file paths in double quotes incase omnihome or the JRE location
	'contain any spaces
	'we also need to lauch it under cmd, otherwise the window will vanish if there is an error
	COMMANDLINE = """" & JRE & "\bin\java.exe" & """" & _
		      " -classpath " & """" & LOCALCLASSPATH & """" & _
		      " com.micromuse.omnibus.baroc.Baroc " & ArgList  

	If ScriptEngineMajorVersion > 5 or (ScriptEngineMajorVersion = 5 and ScriptEngineMinorVersion >= 6) Then
		' execute the baroc2sql command, need to redirect the baroc2sql output
		' back out thru VB engine
		Set oExec = WshShell.Exec(COMMANDLINE)
		
		' Display everything from stdout
		Do While Not oExec.StdOut.AtEndOfStream
			ReadAllOutput = ReadAllOutput & oExec.StdOut.ReadAll
			WScript.StdOut.Write ReadAllOutput
		Loop

		' watch for any exceptions that could be thrown 
		ReadAllOutput = ""
		Do While Not oExec.StdErr.AtEndOfStream
			ReadAllOutput = ReadAllOutput & oExec.StdErr.ReadAll
			WScript.StdOut.Write ReadAllOutput
		Loop
		
	Else
		WshShell.Run "cmd /s /k " & """" & COMMANDLINE & """", 1, False
	End If	

End Function


Main

