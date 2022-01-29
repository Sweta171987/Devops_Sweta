@echo off
REM Licensed Materials - Property of IBM
REM
REM 5724O4800
REM
REM (C) Copyright IBM Corp. 2007. All Rights Reserved
REM
REM US Government Users Restricted Rights - Use, duplication
REM or disclosure restricted by GSA ADP Schedule Contract
REM with IBM Corp.
REM
REM
REM $Id: IC_end.bat 1.0 2007/05/04 00:12:30 zhennyan Development $
REM
REM This script must be used to launch IEHS.vbs.
REM

cscript "%OMNIHOME%\bin\IEHS.vbs" //Nologo -command shutdown -noexec -infocenter
