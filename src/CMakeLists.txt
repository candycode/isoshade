#Raytracing of functional representation
#Copyright (c) Ugo Varetto

cmake_minimum_required(VERSION 2.6)

PROJECT( isoshade )

SET( OSG_INCLUDE_DIR "/usr/local/include" CACHE PATH "OpenSceneGraph include path" )
SET( OSG_LIB_DIR "/usr/local/lib" CACHE PATH "OpenSceneGraph library path" )

INCLUDE_DIRECTORIES( ${OSG_INCLUDE_DIR} )
LINK_DIRECTORIES( ${OSG_LIB_DIR} )

SET( SRCS  isoshade.cpp )

ADD_EXECUTABLE( isoshade ${SRCS} )
TARGET_LINK_LIBRARIES( isoshade OpenThreads osg osgGA osgdb osgUtil osgViewer osgText osgManipulator )
