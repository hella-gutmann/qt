@echo off

::
:: Setup optional parameters
::

set ICUPath=D:\icu-56.1-vs2013
set OpenSSLPath=C:\OpenSSL-Win32
set MYSQLPath=


::
:: Setup build environment
::

REM No build, setup environment and refresh configuration
set SkipClean=true
set SkipConfigure=false
set SkipBuild=true

call _tools\build_qt.cmd "5.5.1" "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat" "x86" "win32-msvc2013"
