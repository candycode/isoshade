#!/bin/sh
#file containing function to render passed on command line
SHADERS_PATH=$HOME/projects/isoshade/src
./isoshade -vert $SHADERS_PATH/iso.vert -frag $SHADERS_PATH/traceandshade_nograd.frag -fun $1 -bk ".5 .7 1" -boxSize "5 5 5" 
