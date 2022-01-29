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
REM nco_id script - runs command line nco_id program
REM

setlocal


REM Find the JRE
for /D  %%i in ("%NCHOME%"\platform\win32\jre_*) do set NCO_JRE=%%i\jre
set JAVA_CMD=%NCO_JRE%\bin\java.exe
if not exist "%JAVA_CMD%" (
	echo Cannot find your Java environment
	goto EOF
)

REM Set up the class path and other class related settings
set CLASSPATH=%NCHOME%\omnibus\java\jars\VersionFinder.jar;%CLASSPATH%
set START_CLASS=com.ibm.tivoli.omnibus.version_finder.VersionFinder


REM Run nco_id
"%JAVA_CMD%" "%START_CLASS%" %*

:EOF
endlocal
