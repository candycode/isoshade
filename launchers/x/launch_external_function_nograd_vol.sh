#!/bin/sh
#file containing function to render passed on command line
SHADERS_PATH=$HOME/projects/isoshade/src
COLORMAP=$SHADERS_PATH/colormaps/red_blue.txt
MATERIAL=$SHADERS_PATH/material_shaders/colormap.material.frag
# SET MATERIAL=$SHADERS_PATH/material_shaders/phong_colormap.material.frag
# SET MATERIAL=$SHADERS_PATH/material_shaders/gradient.material.frag
# SET MATERIAL=$SHADERS_PATH/material_shaders/gradient_colormap.material.frag
./isoshade -vert $SHADERS_PATH/iso.vert -frag $SHADERS_PATH/traceandshade_vol_nograd.frag -manip -fun $1 -bk ".5 .7 1" -boxSize "5 5 5"  -colormap $COLORMAP -material $MATERIAL $2 
