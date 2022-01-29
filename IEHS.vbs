' 
' Licensed Materials - Property of IBM
'
' 5724O4800
'
' (C) Copyright IBM Corp. 2007. All Rights Reserved
'
' US Government Users Restricted Rights - Use, duplication
' or disclosure restricted by GSA ADP Schedule Contract
' with IBM Corp.
'
' Script used by help_end.bat, IC_start.bat and IC_end.bat on Window

'
'=======================Functions below are from nco_include.vbs===============
' Script containing common functions
'

JAVA_REG_HOME="HKLM\SOFTWARE\JavaSoft\Java Runtime Environment\"


'
'NOTE this is locked to the version of java defined as the dependency
'when setting up NCCI package for nco_config/Administrator
'

NCO_JAVAHOME="platform\win32\jre_1.5.4\jre"


MSG_OMNI_USER_HOME_MISSING="ERROR: OMNI_USER_HOME is not defined."
MSG_OMNI_USER_DIR_MISSING="ERROR: OMNI_USER_DIR is not defined."
MSG_OMNI_JMS_HOST_MISSING ="ERROR: OMNI_JMS_HOST is not defined."
MSG_OMNI_AGENT_ROOT_MISSING="ERROR: OMNI_AGENT_ROOT is not defined."
MSG_OMNI_REPOSITORY_ROOT_MISSING="ERROR: OMNI_REPOSITORY_ROOT is not defined."
MSG_OMNI_REPOSITORY_WEB_ROOT_MISSING="ERROR: OMNI_REPOSITORY_WEB_ROOT is not defined."

MSG_NO_JRE_FOUND="The Environment variable NCO_JRE is not defined, nor was the location of the JRE found in the registry." &vbCrLf&vbCrLf & "Please make sure that a JRE ( > 1.5.4 ) is installed and that the environment variable NCO_JRE is set to the jre install bin directory"  

MSG_JAVA_EXE_NOT_FOUND="The executable java.exe could not be found. Please check that the environment variable NCO_JRE is set to a valid (>1.5.4) JRE installation." &vbCrLf & "If you are unsure of the value for NCO_JRE, delete this environment variable and re-run this script."


'
'			Return the version of java - eg. "1.5"
'

Function GetJavaVersion
	On Error Resume Next
	Set WshShell = WScript.CreateObject("WScript.Shell")
	JavaVersion = WshShell.RegRead(JAVA_REG_HOME & "CurrentVersion")
	GetJavaVersion = JavaVersion
End Function


'
'	Returns the path for the java executable
'
Function GetJavaPath(JavaVersion)
	On Error Resume Next
	Set WshShell = WScript.CreateObject("WScript.Shell")
	
	If IsEmpty(JavaVersion) Then

		Exit Function

	End If


	JavaHome = WshShell.RegRead(JAVA_REG_HOME & JavaVersion & "\JavaHome")
	GetJavaPath = JavaHome

End Function





Function ReadAllFromAny(oExec)

	If Not oExec.StdOut.AtEndOfStream Then
		ReadAllFromAny = oExec.StdOut.ReadAll
		Exit Function
	End If

	If Not oExec.StdErr.AtEndOfStream Then
		ReadAllFromAny = oExec.StdErr.ReadAll
		Exit Function
	End If

	ReadAllFromAny = -1

End Function


'
' Function GetOmniUserDir
'
Function GetOmniUserDir
	Set WshShell = WScript.CreateObject("WScript.Shell")
	GetOmniUserDir = WshShell.Environment("PROCESS")("OMNI_USER_DIR")
End Function

'
' Function GetOmniUserHome
'
Function GetOmniUserHome
	Set WshShell = WScript.CreateObject("WScript.Shell")
	GetOmniUserHome = WshShell.Environment("PROCESS")("OMNI_USER_HOME")
End Function


'
' Function GetOmniJmsHost
'
Function GetOmniJmsHost
	Set WshShell = WScript.CreateObject("WScript.Shell")
	GetOmniJmsHost = WshShell.Environment("PROCESS")("OMNI_JMS_HOST")
End Function


'
' Function GetOmniAgentRoot
'
Function GetOmniAgentRoot 
	Set WshShell = WScript.CreateObject("WScript.Shell")
	GetOmniAgentRoot = WshShell.Environment("PROCESS")("OMNI_AGENT_ROOT")
End Function


'
' Function GetOmnihome
'
Function GetOmnihome
	Set WshShell = WScript.CreateObject("WScript.Shell")
	GetOmniAgentRoot = WshShell.Environment("PROCESS")("OMNIHOME")
End Function

'
' Function GetJRE
' Look for a JRE in the NCHOME\platform\win32 directory
' If none can be found 
'
Function GetJRE(NCHOME) 
	Dim WshShell, FSO, JVM, PlDir, Dir
	Set WshShell = WScript.CreateObject("WScript.Shell")
	Set FSO = WScript.CreateObject("Scripting.FileSystemObject")
	' Try NCO_JRE environment variable
	GetJRE = WshShell.Environment("PROCESS")("NCO_JRE")
	JVM = FSO.BuildPath(GetJRE, "bin\java.exe")
	If not FSO.FileExists(JVM) then
		' Could not find the JRE there, so look under NCHOME
		PlDir = FSO.BuildPath(NCHOME, "platform\win32")
		For Each Dir in FSO.GetFolder(PlDir).SubFolders
			' Look at folders starting jre_
			If Left(Dir.Name, 4) = "jre_" then
				' Only a jre if the jvm could be found
				JVM = FSO.BuildPath(Dir, "jre\bin\java.exe")
				If FSO.FileExists(JVM) then
					GetJRE = FSO.BuildPath(Dir, "jre")
				End If
			End If
		Next
	End If
End Function

'
' Function GetOmniRepositoryRoot
'
Function GetOmniRepositoryRoot 
	Set WshShell = WScript.CreateObject("WScript.Shell")
	GetOmniRepositoryRoot = WshShell.Environment("PROCESS")("OMNI_REPOSITORY_ROOT")
End Function

'
' Function GetOmniRepositoryWebRoot
'
Function GetOmniRepositoryWebRoot 
	Set WshShell = WScript.CreateObject("WScript.Shell")
	GetOmniRepositoryWebRoot = WshShell.Environment("PROCESS")("OMNI_REPOSITORY_WEB_ROOT")
End Function

'
' Function GetOmniJmsHome
'
Function GetOmniJmsHome 
	Set WshShell = WScript.CreateObject("WScript.Shell")
	GetOmniJmsHome = WshShell.Environment("PROCESS")("OMNI_JMS_HOME")
End Function

'=======================Functions above are from nco_include.vbs===============

MSG_OMNIHOME_MISSING="ERROR: OMNIHOME is not defined."
MSG_NCHOME_MISSING="ERROR: NCHOME is not defined."

NCO_PLATFORMHOME="platform\win32"

'
' Main function
'

Function Main
	Dim oFSO
	set oFSO = CreateObject("Scripting.FileSystemObject")

	On Error GoTo 0
	Set WshShell = WScript.CreateObject("WScript.Shell")


	NCHOME = WshShell.Environment("PROCESS")("NCHOME")
	If Len(NCHOME) < 1 Then
		WScript.Echo MSG_NCHOME_MISSING
		Exit Function
	End If

	OMNIHOME = WshShell.Environment("PROCESS")("OMNIHOME")
	If Len(OMNIHOME) < 1 Then
		WScript.Echo MSG_OMNIHOME_MISSING
		Exit Function
	End If

	JRE = GetJRE(NCHOME)
	If Len(JRE) < 1 Then
		JVer = GetJavaVersion
		JRE = GetJavaPath(JVer)
	End If

	If Len(JRE) < 1 Then
		WScript.Echo MSG_NO_JRE_FOUND
		Exit Function
	End If
	'
	'Check for java.exe
	'
	Set objFileSystem = CreateObject("Scripting.FileSystemObject")
	if Not objFileSystem.FileExists(JRE & "\bin\java.exe") Then
		WScript.Echo MSG_JAVA_EXE_NOT_FOUND  &vbCrLf&vbCrLf & "Current value for NCO_JRE: " & JRE
		Exit Function
	End If

	LOCALCLASSPATH =    OMNIHOME & "\" & NCO_PLATFORMHOME & "\nco_IEHS\eclipse\plugins\org.eclipse.help.base_3.1.0\helpbase.jar"
	ECLIPSEHOME =	OMNIHOME & "\" & NCO_PLATFORMHOME & "\nco_IEHS\eclipse"
	PLUGIN_INI = ""
	PORT_OPTION = ""
	HOST_OPTION = ""
	 			   

	'Construct Argument List
	For i = 0 To WScript.Arguments.Count -1
		If Eval(WScript.Arguments(i) = "-standalone") Then
			IEHS_COMMAND = "org.eclipse.help.standalone.Help"
		ElseIf Eval(WScript.Arguments(i) = "-infocenter") Then
			IEHS_COMMAND = "org.eclipse.help.standalone.Infocenter"
		Else
			ArgList = ArgList & " " & WScript.Arguments(i)				
		End If
	Next

	'In case customer run IEHS.vbs directly, check ArgList is not empty.
	If ArgList = "" Then
		WScript.Echo "No arguments! Please do not run IEHS.vbs directly." &vbCrLf &_ 
		"Usage: "&vbCrLf &_
		"run IC_start.bat to start Infocenter server; "&vbCrLf &_
		"run IC_end.bat to shutdown Infocenter server; "&vbCrLf &_
		"run help_end.bat to shutdown Standalone server."
		Wscript.Quit(1)
	End if

	'If called from IC_start.bat
	'Read host, port number from configuration file

	If InStr( ArgList, "start") > 0 Then
		Dim oStream, oRE, sLine, PortNum, TrimedStr, oRE2, HostName		
		set oRE = new RegExp
		set ORE2 = new RegExp
		oRE.pattern = "^IEHSPort:"
		oRE2.pattern = "^IEHSHost:"
			
		CONFIGFILE = OMNIHOME & "\ini\nco_IEHS.cfg"
		
		if oFSO.FileExists(CONFIGFILE) Then
			set oStream = oFSO.OpenTextFile(CONFIGFILE, 1)
			Do Until oStream.AtEndOfStream
 				sLine = oStream.ReadLine
				TrimedStr = Trim( sLine )
				
				If oRE.Test( TrimedStr ) Then
									
					If Len( TrimedStr ) = 9 Then
						Wscript.Echo "No value for IEHSPort in " & CONFIGFILE
						Wscript.Quit(1)
					Else
						PortNum = Right( TrimedStr, (Len( TrimedStr ) - 9 ))
						'Wscript.Echo PortNum
						PORT_OPTION = "-port " & PortNum
						'Wscript.Echo PORT_OPTION						
					End If
				ElseIf oRE2.Test( TrimedStr ) Then
					'WScript.Echo TrimedStr
				
					If Len( TrimedStr ) > 9 Then
						HostName = Right( TrimedStr, (Len( TrimedStr ) - 9 ))
						'Wscript.Echo HostName
						HOST_OPTION = "-host " & HostName
						'Wscript.Echo HOST_OPTION						
					End If
				End If

			Loop
		Else
			Wscript.Echo "Can't find " & CONFIGFILE & " or it's not readable"
					Wscript.Quit(1)
		End If

		If PortNum = "" Then
			Wscript.Echo "IEHSPort: is not configurated properly in " & CONFIGFILE
			Wscript.Quit(1)
		End If
	End If

	'We need to enclose file paths in double quotes incase omnihome or the JRE location
	'contain any spaces
	'we also need to lauch it under cmd, otherwise the window will vanish if there is an error
	COMMANDLINE = """" & JRE & "\bin\java.exe" & """" & _
		      " -classpath " & """" & LOCALCLASSPATH & """" & _
		      " " & IEHS_COMMAND & _
		      " -eclipsehome " & """" & ECLIPSEHOME & """" & _
			  " " & HOST_OPTION & _
			  " " & PORT_OPTION & _
			  " " & PLUGIN_INI & _
			  ArgList

			  WScript.Echo COMMANDLINE
		
	If ScriptEngineMajorVersion > 5 or (ScriptEngineMajorVersion = 5 and ScriptEngineMinorVersion >= 6) Then
		' execute the help_start command, need to redirect the help_start output
		' back out thru VB engine
		Set oExec = WshShell.Exec(COMMANDLINE)	
			
		' watch for any exceptions that could be thrown

		ReadAllOutput = ""
		Do While Not oExec.StdErr.AtEndOfStream
			ReadAllOutput = ReadAllOutput & oExec.StdErr.ReadAll
			WScript.StdOut.Write ReadAllOutput
		Loop

	Else
		WshShell.Run "cmd /s /k " & """" & COMMANDLINE & """", 1, False
	End If	

	' On Windows if IEHS is terminated abnormally (not by running help_end.bat or IC_end.bat) 
	' the .connection file is left which would confuse Desktop and Administrator on whether IEHS server
	' is running. So we need to manually delete it in case IEHS server is already down and above command 
	' can't delete .connection file.
	'
	If InStr( ArgList, "shutdown") > 0 Then
		CONNECTIONFILE = ECLIPSEHOME & "\workspace\.metadata\.connection"
		
		if oFSO.FileExists(CONNECTIONFILE) Then
			oFSO.DeleteFile(CONNECTIONFILE)
		End if
	End if

End Function


Main

