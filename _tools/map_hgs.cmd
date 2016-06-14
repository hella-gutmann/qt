REM (C) 2016 Hella Gutmann Solutions (Christian Rudmann)

@echo off

REM Initialize variables
set HGS_DRIVE_LETTER=D
set HGS_DRIVE_DESCRIPTION=Hgs


:ELEVATE_BATCH
NET FILE 1>NUL 2>NUL
if "%errorlevel%"=="0" ( cd %~dp0 && goto :START 
) else ( powershell "saps -filepath %0 -verb runas" >nul 2>&1)
exit /b


:START

cls

echo Please enter the path to which the virtual drive should map:
set /p DestPath=

if "%DestPath%"=="" goto :START
if not exist "%DestPath%" goto :START

call :NORMALISE_PATH %DestPath%
goto :CHECK_INPUT

goto :eof


:CHECK_INPUT

echo The virtual drive %HGS_DRIVE_LETTER%: will map to path:
echo %DestPath%
echo.
echo Press any key to create the virtual drive
pause>nul

goto :START_CREATE_DRIVE

goto :eof


:START_CREATE_DRIVE

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\DOS Devices" /v "%HGS_DRIVE_LETTER%:" /t REG_SZ /d "\??\%DestPath%" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\DriveIcons\%HGS_DRIVE_LETTER%\DefaultIcon" /ve /d "%%SystemRoot%%\System32\shell32.dll,43" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\DriveIcons\%HGS_DRIVE_LETTER%\DefaultLabel" /ve /d "%HGS_DRIVE_DESCRIPTION%" /f

goto :eof


:NORMALISE_PATH

set DestPath=%~f1
if %DestPath:~-1%==\ set DestPath=%DestPath:~0,-1%

goto :eof


