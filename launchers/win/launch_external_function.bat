echo off
SET PROGRAM_PATH=C:\cmakebuilds\isoshade\Release
SET SHADERS_PATH=C:\projects\isoshade\src

%PROGRAM_PATH%\isoshade.exe -vert %SHADERS_PATH%\iso.vert -frag %SHADERS_PATH%\traceandshade.frag -fun %1 -bk ".5 .7 1"
