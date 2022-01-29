@echo off
REM
REM Licensed Materials - Property of IBM
REM
REM 5724O4800
REM
REM (C) Copyright IBM Corp. 2012. All Rights Reserved
REM
REM US Government Users Restricted Rights - Use, duplication
REM or disclosure restricted by GSA ADP Schedule Contract
REM with IBM Corp.
REM
REM nco_mibmanager script - Starts the MibManager program
REM

setlocal


REM
REM Set PATH to include the JRE
REM
for /D  %%i in ("%NCHOME%"\platform\win32\jre_*) do set NCO_JRE=%%i\jre
if not exist "%NCO_JRE%\bin\java.exe" (
	echo Cannot find your Java environment
	goto EOF
)

REM
REM Find the MibManager program
REM
if exist "%NCHOME%\omnibus\platform\win32\mibmanager64\MibManager.exe" (
	set MMPATH=%NCHOME%\omnibus\platform\win32\mibmanager64
) else if exist "%NCHOME%\omnibus\platform\win32\mibmanager\MibManager.exe" (
	set MMPATH=%NCHOME%\omnibus\platform\win32\mibmanager
) else (
	echo "Not installed for win32"
	goto EOF
)

PATH=%MMPATH%\plugins\org.eclipse.equinox.launcher.win32.win32.x86_1.1.100.v20110502:%PATH%

REM Run MibManager
"%MMPATH%\MibManager" -vm "%NCO_JRE%\bin" %*

:EOF
endlocal
