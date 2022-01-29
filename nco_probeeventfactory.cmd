@echo off
rem
rem Licensed Materials - Property of IBM
rem
rem 5724O4800
rem
rem (C) Copyright IBM Corp. 2012. All Rights Reserved
rem
rem US Government Users Restricted Rights - Use, duplication
rem or disclosure restricted by GSA ADP Schedule Contract
rem with IBM Corp.
rem
rem Generate an event on a probe using http interface.
rem
rem 5.50.20
rem

setlocal enabledelayedexpansion

set OMNIUSERNAME=
set OMNIPASSWORD=
set OMNISSL=0
set OMNIHOST=
set OMNIPORT=
set OMNILEVEL=info
set OMNITIMEOUT=20
set DATA={ \"eventfactory\": [ {
set COMMA=

:getopt
if /i "%~1" == "-help" (
	goto help
)
if /i "%~1" == "-ssl" (
	set OMNISSL=1
	goto next
)
if /i "%~1" == "-username" (
	if "%~2" == "" (
		goto missing
	)
	set OMNIUSERNAME=%~2
	set OMNIUSERNAME=!OMNIUSERNAME:'=!
	shift
	goto next
)
if /i "%~1" == "-password" (
	if "%~2" == "" (
		goto missing
	)
	set OMNIPASSWORD=%~2
	set OMNIPASSWORD=!OMNIPASSWORD:'=!
	shift
	goto next
)
if /i "%~1" == "-host" (
	if "%~2" == "" (
		goto missing
	)
	set OMNIHOST=%~2
	set OMNIHOST=!OMNIHOST:'=!
	shift
	goto next
)
if /i "%~1" == "-port" (
	if "%~2" == "" (
		goto missing
	)
	set OMNIPORT=%~2
	shift
	goto next
)
if /i "%~1" == "-timeout" (
	if "%~2" == "" (
		goto missing
	)
	set OMNITIMEOUT=%~2
	shift
	goto next
)
if /i "%~1" == "-messagelevel" (
	if "%~2" == "" (
		goto missing
	)
	set OMNILEVEL=%~2
	set OMNILEVEL=!OMNILEVEL:'=!
	shift
	goto next
)
if "%~1" == "" (
	goto done
)
REM %1:~0,1% does not work
set arg=%~1
if "%arg:~0,1%" == "-" (
	echo unknown option %1
	goto end
)
set NAME=%arg%
set VALUE=%~2
if not "%VALUE%" == "" (
	set VALUE=%VALUE:"=\"%
)
set DATA=%DATA% %COMMA% \"%NAME%\": \"%VALUE%\"
set COMMA=,
shift
:next
shift
if not "%~1" == "" (
	goto getopt
)

:done
set DATA=%DATA% } ] }
if "%OMNIHOST%" == "" (
	echo -host is required
	goto end
)

if %OMNISSL% GTR 0 (
	set PROTO=https
) else (
	set PROTO=http
)

if not "%OMNIPORT%" == "" (
	set PORT=:%OMNIPORT%
) else (
	set PORT=
)

set URI=%PROTO%://%OMNIHOST%%PORT%/probe/common

if not "%OMNIUSERNAME%" == "" (
	"%OMNIHOME%\bin\nco_http" -datatype application/json -data "%DATA%" -method POST -uri %URI% -messagelevel %OMNILEVEL% -username "%OMNIUSERNAME%" -password "%OMNIPASSWORD%" -timeout %OMNITIMEOUT%
) else (
	"%OMNIHOME%\bin\nco_http" -datatype application/json -data "%DATA%" -method POST -uri %URI% -messagelevel %OMNILEVEL% -timeout %OMNITIMEOUT%
)

goto end

:missing
echo %1 requires argument
goto end

:help
echo usage: nco_probeeventfactory [options] [NAME=VALUE]...
echo.
echo where options can be:
echo.
echo   -help           Print this help text
echo   -host           Hostname of probe
echo   -messagelevel   Message logging level (default: INFO)
echo   -password       Password to use for http authentication
echo   -port           Port number of probe
echo   -ssl            Use https rather than http
echo   -timeout        Timeout for http response
echo   -username       Username to use for http authentication

:end
