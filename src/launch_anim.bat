echo off
SET PROGRAM_PATH=C:\cmakebuilds\isoshade\Release
SET SHADERS_PATH=C:\projects\isoshade\trunk\src

%PROGRAM_PATH%\isoshade.exe -vert %SHADERS_PATH%\iso-time.vert -frag %SHADERS_PATH%\iso-time.frag -bk "1 1 1"