#!/bin/sh
SHADERS_PATH=$HOME/projects/isoshade/src
./isoshade -vert $SHADERS_PATH/iso.vert -frag $SHADERS_PATH/iso.frag -bk ".5 1 1"
