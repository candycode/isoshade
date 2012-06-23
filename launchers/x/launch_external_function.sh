#!/bin/sh
SHADERS_PATH=$HOME/projects/isoshade/src
FUNCTIONS_PATH=$HOME/projects/isoshade/src/functions

./isoshade -vert $SHADERS_PATH/iso.vert -frag $SHADERS_PATH/traceandshade.frag -fun $FUNCTIONS_PATH/isofun2.frag -bk ".5 .7 1"
