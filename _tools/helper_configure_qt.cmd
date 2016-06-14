@echo off

::
:: Help
::

REM Parameters

REM %1=Path to qt source files
REM %2=Shadowbuild path
REM %3=Path in which the qt build must installed
REM %4=Path to vcvarsall.bat
REM %5=VC platform
REM %6=Qt platform

REM Optional parameters

REM set ICUPath=Path to ICU library
REM set OpenSSLPath=Path to OpenSSL library
REM set MYSQLPath=Path to MYSQL c/connector


::
:: Setup parameters
::

pushd .
cd %cd%

if "%SourcePath%"=="" set SourcePath=%~f1
if "%WorkPath%"=="" set WorkPath=%~f2
if "%InstallPath%"=="" set InstallPath=%~f3
if "%VCEnvPath%"=="" set VCEnvPath=%~f4
if "%VCPlatform%"=="" set VCPlatform=%~5
if "%QTPlatform%"=="" set QTPlatform=%~6

popd


::
:: Cleanup previous working dir
::

if /i "%SkipClean%"=="true" goto DoSetupEnvironment

if /i "%BeInteractive%"=="true" (
	echo.
	echo Press any key to clean configuration
	pause > nul
)
 
if exist "%WorkPath%" ( 
	echo Removing "%WorkPath%"
	rmdir /Q /S "%WorkPath%"
)

if not exist "%WorkPath%" (
	echo Creating "%WorkPath%"
	mkdir "%WorkPath%"
)


::
:: Cleanup previous install
::

if /i "%SkipClean%"=="true" goto DoSetupEnvironment

if /i "%BeInteractive%"=="true" (
	echo.
	echo Press any key to clean build
	pause > nul
)

if exist "%InstallPath%" ( 
	echo Removing "%InstallPath%"
	rmdir /Q /S "%InstallPath%"
)

if not exist "%InstallPath%" (
	echo Creating "%InstallPath%"
	mkdir "%InstallPath%"
)


::
:: Setup environment
::

:DoSetupEnvironment

REM Setup Visual Studio environment
call "%VCEnvPath%" %VCPlatform%

REM Update the path with a few access to dlls, tools, etc.
REM Qt basics
set Path=%SourcePath%\gnuwin32\bin;%Path%
set Path=%WorkPath%\qtbase\bin;%Path%
set Path=%WorkPath%\qtbase\lib;%Path%
REM ICU library
if not "%ICUPath%"=="" set Path=%ICUPath%\bin;%Path%
if not "%ICUPath%"=="" set Path=%ICUPath%\lib;%Path%
REM OpenSSL
if not "%OpenSSLPath%"=="" set Path=%OpenSSLPath%\bin;%Path%
if not "%OpenSSLPath%"=="" set Path=%OpenSSLPath%;%Path%
REM MySQL
if not "%MYSQLPath%"=="" set Path=%MYSQLPath%\bin;%Path%
if not "%MYSQLPath%"=="" set Path=%MYSQLPath%\lib;%Path%


::
:: Setup the configuration
::

set Configuration= -opensource -confirm-license -debug-and-release
set Configuration= %Configuration% -prefix "%InstallPath%"
if not "%ICUPath%"=="" (
	set Configuration= %Configuration% -icu -I "%ICUPath%\include" -L "%ICUPath%\lib"
)
if not "%OpenSSLPath%"=="" (
	set Configuration= %Configuration% -openssl -I "%OpenSSLPath%\include" -L "%OpenSSLPath%\lib"
)
if not "%MYSQLPath%"=="" (
	set MYSQL_PATH=%MYSQLPath%
	set QT_CFLAGS_MYSQL=%MYSQLPath%\include
	set QT_LFLAGS_MYSQL=%MYSQLPath%\lib
	set Configuration= %Configuration% -plugin-sql-mysql -l libmysql
	REM set Configuration= %Configuration% -plugin-sql-mysql -I "%MYSQLPath%\include" -L "%MYSQLPath%\lib" -l libmysql
)
set Configuration= %Configuration% -nomake tests -nomake examples
set Configuration= %Configuration% -skip qtwebkit-examples


::
:: Configure
::
 
if /i "%SkipConfigure%"=="true" goto DoBuild
 
pushd "%WorkPath%"
"%SourcePath%\configure" %Configuration% -mp -platform %QTPlatform%
popd


::
:: Build
::

:DoBuild

REM Note: On Windows, the configure script exits, so the following needs to be done manually. It's here for reference.
REM nmake
REM nmake install
REM nmake clean
