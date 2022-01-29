@echo off

rem ***************************************************************************
rem ** Licensed Materials - Property of IBM
rem **
rem ** 5724O4800
rem **
rem ** (C) Copyright IBM Corp. 2006, 2007. All Rights Reserved
rem **
rem ** US Government Users Restricted Rights - Use, duplication
rem ** or disclosure restricted by GSA ADP Schedule Contract
rem ** with IBM Corp.
rem ***************************************************************************

rem ***************************************************************************
rem ** Execute redistributable 'isql.exe' in a closed environment
rem **
rem ** Find the console's active (OEM) code page and pass it to isql
rem ** use the -J isql argument to set it.
rem **
rem ** There are a handful of code pages not supported by Sybase. For those we
rem ** use the corresponding ANSI code page.
rem ** 
rem ** http://www.microsoft.com/globaldev/nlsweb/		
rem ** 
rem ** lists the code pages that are supported by Microsoft.
rem **
rem ** The %NCHOME%\charsets directory lists all the code pages 
rem ** that are supported by Sybase.
rem ** 
rem ***************************************************************************

rem ** Build array of code page numbers that are not supported by Sybase.

set ANSI_720=1256
set ANSI_737=1253
set ANSI_775=1257
set ANSI_862=1255

rem ** Retrieve current code page setting
rem ** Parse the output of 'chcp' to retrieve the code page number.
rem ** (An assumption is made that 'chcp' always outputs a message
rem ** in the format: "message text : number")

for /f "delims=: tokens=2" %%i in ('chcp') do (set CP=%%i) 
set OEM_CP=%CP:~1%

rem ** Check whether the current OEM code page is supported by Sybase.
rem ** If not, then use the hard coded equivalent ANSI code page instead.

set /a ANSI_CP=ANSI_%OEM_CP%
if %ANSI_CP% EQU 0 (set CP=%OEM_CP%) else (set CP=%ANSI_CP%)

rem ** In case we want the ANSI code page, use 'chcp' to set the current
rem ** code page.
rem ** Launch the Sybase utility 'isql.exe', defining the current code page
rem ** setting with the -J commandline argument.
rem ** Reset the current console code page, in case we've changed it.

chcp %CP% > NUL
"%SYBASE%\bin\redist\isql" -Jcp%CP% %*
chcp %OEM_CP% > NUL

goto :EOF
