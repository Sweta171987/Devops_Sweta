@echo off
REM $Id: nco_confpack.bat 1.6 2003/09/04 00:12:30 bfreitas Development $
REM
REM This script must be used to launch nco_confpack.vbs if you want to recieve output on the command line.  otherwise you may recieve no output.
REM

cscript "%OMNIHOME%\bin\nco_confpack.vbs" //Nologo %*
