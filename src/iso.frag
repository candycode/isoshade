//Raytracing of functional representations
//Copyright (c) Ugo Varetto

#version 120
varying vec4 color;
varying vec3 rayorigin;
varying vec3 raydir;
varying vec3 center;
varying vec4 origin;
float eps = 0.00001;
vec3 lightDir = normalize( vec3( 0., -1., -1. ) );
float kd = 1.0;
float ka = 0.01;
float ks = 1.;
float sh = 100.;
vec3 refcolor = vec3( 1, 1, 1 );

vec4 ComputeColor( vec3 n )
{
  vec3 N = faceforward( n, lightDir, n );
  float d = dot( N, -lightDir );
  float s = pow( max( 0.0, dot( vec3( 0, 0, 1 ), reflect( lightDir, N ) ) ), sh );
  float a = color.a * ( 1. - dot( vec3( 0., 0., 1 ), n ) );
  return vec4(  ks * s * refcolor + kd * d * color.rgb + ka * color.rgb, a );
}

float IsoFunction( in vec3 p )
{
  return dot( p, p ) + sin( 4. * p.x ) + sin( 4. * p.y ) + sin( 4. * p.z ) - 1.;
}

vec3 IsoGradient( in vec3 p )
{
   
  return vec3( 2. * p.x + 4. * cos( 4. * p.x ),
  	       2. * p.y + 4. * cos( 4. * p.y ),
  	       2. * p.z + 4. * cos( 4. * p.z ) );
}

void main(void)
{
  float tstart = length( raydir ) - 0.001;
  float tend = tstart + 6.0;
  float tstep = 0.05;
  
  
  vec3 rdir = transpose( gl_NormalMatrix ) * raydir;
    
  vec3 dir = normalize( rdir );
  int numSteps = int( ( tend - tstart ) / tstep );
  vec3 prev = origin.xyz + tstart * dir;
  float tprev = tstart;
  vec3 cur = prev;
  float tcur = tprev;
  float t = -1.0;
 
  for( int i = 1; i < numSteps; ++i )
  {
    tcur = tstart + tstep * float( i );
    cur = origin.xyz + tcur * dir;
    float f1 = IsoFunction( prev );
    float f2 = IsoFunction( cur ); 
    if( f1 * f2 < 0. )
    {
      cur = prev + ( 0. - f1 ) * ( cur - prev ) * (1./(f2 - f1 ));
      t = tcur;
      break; 
    }
    else if( abs( f2 ) < eps )
    {
         
         t = length( cur - prev );
         break;
    }
    else if( abs( f1 ) < eps )
    {
         cur = prev;
         t = 0.;
         break;
    }
    else prev = cur;
  }
  if( t < 0.0 ) discard;
 
  vec4 P = gl_ModelViewMatrix * vec4( cur, 1. );
  P.xyzw /= P.w;
  vec3 N = gl_NormalMatrix * normalize( IsoGradient( cur ) );
  gl_FragColor = ComputeColor( N );	  
  float z = dot( P, gl_ProjectionMatrixTranspose[ 2 ] );
  float w = dot( P, gl_ProjectionMatrixTranspose[ 3 ] );
  gl_FragDepth = 0.5 * ( z / w + 1.0 );
}


