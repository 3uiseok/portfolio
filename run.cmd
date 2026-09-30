@echo off
rem Build and run on Tomcat 11 -> http://localhost:8080/web/
rem Uses .tomcat\ in this project as CATALINA_BASE, so the Tomcat install itself is not modified.
setlocal
cd /d "%~dp0"
call "%~dp0setenv.cmd"
rem Load .env if present (GATE_CODE etc.), same file docker compose reads
if exist "%~dp0.env" for /f "usebackq eol=# tokens=1,* delims==" %%a in ("%~dp0.env") do set "%%a=%%b"
call "%~dp0build.cmd"
if errorlevel 1 exit /b 1

set "CATALINA_BASE=%~dp0.tomcat"
if not exist "%CATALINA_BASE%\conf" xcopy /e /i /q /y "%CATALINA_HOME%\conf" "%CATALINA_BASE%\conf" >nul
if not exist "%CATALINA_BASE%\logs" mkdir "%CATALINA_BASE%\logs"
if not exist "%CATALINA_BASE%\temp" mkdir "%CATALINA_BASE%\temp"
if not exist "%CATALINA_BASE%\work" mkdir "%CATALINA_BASE%\work"
if not exist "%CATALINA_BASE%\webapps" mkdir "%CATALINA_BASE%\webapps"

if exist "%CATALINA_BASE%\webapps\web" rmdir /s /q "%CATALINA_BASE%\webapps\web"
copy /y "%~dp0target\web.war" "%CATALINA_BASE%\webapps\web.war" >nul

call "%CATALINA_HOME%\bin\catalina.bat" run
