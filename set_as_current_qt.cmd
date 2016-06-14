@echo off

REM Get script directory
set PWD=%~dp0.

REM Set up qt stuff
setx QTREPO "%PWD%"
setx QTDIR "%PWD%\5.5.1-build"