#!/bin/sh
SHADERS_PATH=$HOME/projects/isoshade/src

./isoshade -vert $SHADERS_PATH/iso.vert -frag $SHADERS_PATH/traceandshade.frag -fun $1 -bk ".5 .7 1"
