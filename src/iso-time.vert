//Raytracing of functional representations
//Copyright (c) Ugo Varetto

varying vec4 color;
varying vec3 raydir;
varying vec3 rayorigin;
varying vec4 origin; 
void main()
{

  color = vec4( 1.0, 0.9, 0.8, 1. );//gl_Color;
      	  
  bool perspective = gl_ProjectionMatrix[ 3 ][ 3 ] < 0.001 && gl_ProjectionMatrix[ 2 ][ 3 ] != 0.0;
  
  vec4 p = gl_ModelViewMatrix * gl_Vertex;
  gl_ClipVertex = p;
        
  if( perspective )
  {
    raydir = vec3( p ) / p.w;
    rayorigin = vec3( 0, 0, 0 );
  }  
  else
  {
    raydir = vec3( 0, 0, -1 );
    rayorigin = vec3( p.x / p.w, p.y / p.w, 0 );
  }  
  origin = gl_ModelViewMatrixInverse * vec4( rayorigin, 1. );
  origin.xyz /= origin.w;
  gl_Position = gl_ProjectionMatrix * p;
} 
