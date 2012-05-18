echo off
SET PROGRAM_PATH=C:\cmakebuilds\isoshade\Release
SET SHADERS_PATH=C:\projects\isoshade\trunk\src
SET FUNCTIONS_PATH=C:\projects\isoshade\trunk\src\functions

%PROGRAM_PATH%\isoshade.exe -vert %SHADERS_PATH%\iso.vert -frag %SHADERS_PATH%\traceandshade.frag -fun %FUNCTIONS_PATH%\isofun2.frag -bk ".5 .7 1"