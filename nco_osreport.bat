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
REM nco_osreport script - runs command line nco_osreport program
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
set CLASSPATH=%NCHOME%\omnibus\java\jars\OSReport.jar;%CLASSPATH%
set CLASSPATH=%NCHOME%\omnibus\java\jars\utility.jar;%CLASSPATH%
set START_CLASS=com.ibm.tivoli.omnibus.osreport.CommandLine

if exist "%NCHOME%\omnibus\java\jars\jconn3.jar" (
	set CLASSPATH=%NCHOME%\omnibus\java\jars\jconn3.jar;%CLASSPATH%
	set JDBC_PROP=-Djdbc.drivers=com.sybase.jdbc3.jdbc.SybDriver
) else (
	set CLASSPATH=%NCHOME%\omnibus\java\jars\jconn2.jar;%CLASSPATH%
	set JDBC_PROP=-Djdbc.drivers=com.sybase.jdbc2.jdbc.SybDriver
)

REM Run nco_osreport
"%JAVA_CMD%" "%JDBC_PROP%" "%START_CLASS%" %*

:EOF
endlocal
