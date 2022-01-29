'
' Script containing common functions
'

JAVA_REG_HOME="HKLM\SOFTWARE\JavaSoft\Java Runtime Environment\"


'
'NOTE this is locked to the version of java defined as the dependency
'when setting up NCCI package for nco_config/Administrator
'

NCO_JAVAHOME="platform\win32\jre_1.7.0\jre"


MSG_OMNI_USER_HOME_MISSING="ERROR: OMNI_USER_HOME is not defined."
MSG_OMNI_USER_DIR_MISSING="ERROR: OMNI_USER_DIR is not defined."
MSG_OMNI_JMS_HOST_MISSING ="ERROR: OMNI_JMS_HOST is not defined."
MSG_OMNI_AGENT_ROOT_MISSING="ERROR: OMNI_AGENT_ROOT is not defined."
MSG_OMNI_REPOSITORY_ROOT_MISSING="ERROR: OMNI_REPOSITORY_ROOT is not defined."
MSG_OMNI_REPOSITORY_WEB_ROOT_MISSING="ERROR: OMNI_REPOSITORY_WEB_ROOT is not defined."

MSG_NO_JRE_FOUND="The Environment variable NCO_JRE is not defined, nor was the location of the JRE found in the registry." &vbCrLf&vbCrLf & "Please make sure that a JRE (>= 1.6) is installed and that the environment variable NCO_JRE is set to the jre install bin directory"  

MSG_JAVA_EXE_NOT_FOUND="The executable java.exe could not be found. Please check that the environment variable NCO_JRE is set to a valid (>= 1.6) JRE installation." &vbCrLf & "If you are unsure of the value for NCO_JRE, delete this environment variable and re-run this script."


'
'			Return the version of java - eg. "1.6"
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
'
Function GetJRE(NCHOME) 
	Set WshShell = WScript.CreateObject("WScript.Shell")
	GetJRE = WshShell.Environment("PROCESS")("NCO_JRE")
'		
'	If no %NCO_JRE% set, try using JRE within NCHOME installation.
'
	If Len(GETJRE) < 1 Then
	    GETJRE = NCHOME & Chr(92) & NCO_JAVAHOME
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





