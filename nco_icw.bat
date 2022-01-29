@echo off
REM
REM Licensed Materials - Property of IBM
REM
REM 5724O4800
REM
REM (C) Copyright IBM Corp. 2010. All Rights Reserved
REM
REM US Government Users Restricted Rights - Use, duplication
REM or disclosure restricted by GSA ADP Schedule Contract
REM with IBM Corp.
REM
REM nco_icw script - runs command line nco_icw program
REM

setlocal

REM Find the JRE
for /D  %%i in ("%NCHOME%"\platform\win32\jre_*) do set NCO_JRE=%%i\jre
set JAVA_CMD=%NCO_JRE%\bin\java.exe
if not exist "%JAVA_CMD%" (
	echo Cannot find your Java environment
	goto EOF
)

set SWTJAR=org.eclipse.swt.win32.win32.x86_3.7.1.v3738a.jar

REM Set up the class path and other class related settings
set CLASSPATH=%NCHOME%\omnibus\java\jars\icw.jar;%NCHOME%\omnibus\java\jars\%SWTJAR%;%CLASSPATH%
set START_CLASS=com.ibm.tivoli.omnibus.ict.ICTMain

REM Run intial configuration
"%JAVA_CMD%" "%START_CLASS%" %*

:EOF
endlocal
