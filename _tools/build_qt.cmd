@echo off

pushd .
cd %cd%

set Version=%~f1

set SourcePath=%Version%-src
set WorkPath=%Version%-work
set InstallPath=%Version%-build


popd


::
:: Configure
::

pushd .
cd %cd%

call "%~dp0helper_configure_qt.cmd" "%SourcePath%" "%WorkPath%" "%InstallPath%" "%~f2" "%~3" "%~4"

popd


::
:: Configure plugins
::


::
:: Build
::

pushd "%WorkPath%"

if /i "%SkipBuild%"=="true" goto :eof

if /i "%BeInteractive%"=="true" (
	echo.
	echo Press any key to start building
	pause > nul
)

nmake

pause
if /i "%BeInteractive%"=="true" (
	echo.
	echo Press any key to install
	pause -> nul
)

nmake install

popd


::
:: Finalize
::

if /i "%BeInteractive%"=="true" (
	echo.
	echo Press any key to install requisites
	pause -> nul
)

pushd "%InstallPath%"

REM Copy ICU files
if not "%ICUPath%"=="" (
	copy /Y "%ICUPath%\bin\icuin*.dll" ".\bin\"
	copy /Y "%ICUPath%\bin\icuuc*.dll" ".\bin\"
	copy /Y "%ICUPath%\bin\icudt*.dll" ".\bin\"
)

popd