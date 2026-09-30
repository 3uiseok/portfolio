@echo off
rem Development tool locations (C:\_install\dev). Called by build.cmd / run.cmd.
rem JDK 21 is not extracted under C:\_install\dev\java, so the installed one is used.
set "JAVA_HOME=C:\Program Files\Java\jdk-21"
set "MAVEN_HOME=C:\_install\dev\apache-maven\apache-maven-3.9.14"
set "CATALINA_HOME=C:\_install\dev\apache-tomcat\apache-tomcat-11.0.23"
set "PATH=%JAVA_HOME%\bin;%MAVEN_HOME%\bin;%PATH%"
