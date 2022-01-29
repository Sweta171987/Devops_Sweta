@echo off
REM
REM Licensed Materials - Property of IBM
REM
REM 5724O4800
REM
REM (C) Copyright IBM Corp. 2013. All Rights Reserved
REM
REM US Government Users Restricted Rights - Use, duplication
REM or disclosure restricted by GSA ADP Schedule Contract
REM with IBM Corp.
REM
REM nco_isadc script - IBM support assistant data collector
REM
REM 5.50.20
REM

setlocal

REM Find the JRE
for /D  %%i in ("%NCHOME%"\platform\win32\jre_*) do set JAVA_HOME=%%i\jre
if not exist "%JAVA_HOME%\bin\java.exe" (
	echo Cannot find your Java environment
	goto EOF
)


REM Run the ISA DC
set USEHOME=-useHome
"%NCHOME%\omnibus\platform\win32\isadc\isadc.bat" %USEHOME% %*

:EOF
endlocal
