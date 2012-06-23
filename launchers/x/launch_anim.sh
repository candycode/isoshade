#!/bin/sh
SHADERS_PATH=/$HOME/projects/isoshade/src
./isoshade -vert $SHADERS_PATH/iso-time.vert -frag $SHADERS_PATH/iso-time.frag -bk "1 1 1"
