@echo off
rem Build target\web.war
setlocal
cd /d "%~dp0"
call "%~dp0setenv.cmd"
call mvn -B clean package %*
exit /b %ERRORLEVEL%
