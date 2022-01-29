@echo off
REM
REM Licensed Materials - Property of IBM
REM
REM 5724O4800
REM
REM (C) Copyright IBM Corp. 2014. All Rights Reserved
REM
REM US Government Users Restricted Rights - Use, duplication
REM or disclosure restricted by GSA ADP Schedule Contract
REM with IBM Corp.
REM
REM nco_rules_util script - runs command line nco_rules_util program
REM

setlocal

REM Set up default user
set OMNIUSER=%USERNAME%
set OMNIPASSWD=

REM Find the JRE
for /D  %%i in ("%NCHOME%"\platform\win32\jre_*) do set NCO_JRE=%%i\jre
set JAVA_CMD=%NCO_JRE%\bin\java.exe
if not exist "%JAVA_CMD%" (
	echo Cannot find your Java environment
	goto EOF
)

REM Set up the class path and other class related settings
set CLASSPATH=%NCHOME%\omnibus\java\jars\repository.jar;%CLASSPATH%
set CLASSPATH=%NCHOME%\omnibus\java\jars\utility.jar;%CLASSPATH%
set CLASSPATH=%NCHOME%\omnibus\java\jars\icu4j-51_2.jar;%CLASSPATH%
set START_CLASS=com.ibm.netcool.omnibus.repository.CommandLine

REM Run nco_rules_util
"%JAVA_CMD%" "%START_CLASS%" %*

:EOF
endlocal
