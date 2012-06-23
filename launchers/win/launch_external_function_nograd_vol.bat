echo off
REM file containing function to render on command line
SET PROGRAM_PATH=C:\cmakebuilds\isoshade\Release
SET SHADERS_PATH=C:\projects\isoshade\src
SET COLORMAP=%SHADERS_PATH%\colormaps\red_blue.txt
SET MATERIAL=%SHADERS_PATH%\material_shaders\colormap.material.frag
REM SET MATERIAL=%SHADERS_PATH%\material_shaders\phong_colormap.material.frag
REM SET MATERIAL=%SHADERS_PATH%\material_shaders\gradient.material.frag
REM SET MATERIAL=%SHADERS_PATH%\material_shaders\gradient_colormap.material.frag
%PROGRAM_PATH%\isoshade.exe -vert %SHADERS_PATH%\iso.vert -frag %SHADERS_PATH%\traceandshade_vol_nograd.frag -manip -fun %1 -bk ".5 .7 1" -boxSize "5 5 5"  -colormap %COLORMAP% -material %MATERIAL% %2 
