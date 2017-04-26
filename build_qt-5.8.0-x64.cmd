@echo off

::
:: Setup optional parameters
::

set ICUPath=D:\icu-58.2-vs2015x64
set OpenSSLPath=C:\OpenSSL-Win64
set MYSQLPath=D:\mysql-connector-c-6.1.9-win64

::
:: Build
::

set BeInteractive=false
set BeVerbose=false

call _tools\build_qt.cmd "5.8.0" "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" "x64" "win32-msvc2015"

pause