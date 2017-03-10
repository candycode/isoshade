//Raytracing of functional representations, volume rendering version;
//Copyright (c) Ugo Varetto
#version 120
#define AUTO_COMPUTE_DISTANCE //FASTER
#define BACK_TO_FRONT
//#define COMPUTE_POINT_AND_NORMAL
//#define GRADIENT_FILTER

//#version 130
uniform sampler1D colormap;
uniform vec3 halfBoxSize;
varying vec4 color;
varying vec3 rayorigin;
varying vec3 raydir;
varying vec3 center;
varying vec4 origin;
const float eps = 0.00001;

// declaration of isofun and value getters
float IsoFunction( in vec3 p );
float GetMinIsoValue();
float GetMaxIsoValue();
float GetMaxDistance();
float GetDStep();
bool FilterGradient( vec3 G );
bool FilterValue( float v );

// defined in same module as IsoFunction
float maxIsoValue = GetMaxIsoValue();
float minIsoValue = GetMinIsoValue();
float maxDistance = GetMaxDistance();
float dMaxMin = maxIsoValue - minIsoValue;
float tstep = GetDStep();

// defined in material shader
vec4 ComputeColor( vec3 P, vec3 grad, float isoValue, vec4 prevColor );

vec3 IsoGradient( in vec3 p )
{
    float dfdz = IsoFunction( p + vec3( 0., 0., tstep ) ) - IsoFunction( p + vec3( 0., 0., -tstep ) );
    float dfdy = IsoFunction( p + vec3( 0., tstep, 0. ) ) - IsoFunction( p + vec3( 0., -tstep, 0. ) );
    float dfdx = IsoFunction( p + vec3( tstep, 0., 0. ) ) - IsoFunction( p + vec3( -tstep, 0., 0. ) );
    return 0.5 * vec3( dfdx, dfdy, dfdz ) / tstep;
}

// compute next intersection with box;
// the ray origin 'p' is the first intersection point on the box
// computed in the main() function
float ComputeMaxDistance( vec3 dir, vec3 p )
{
#ifndef AUTO_COMPUTE_DISTANCE
    return maxDistance;
#else
    const vec2 bias = vec2( 0.001 );
    vec3 ip;
    float t = 0.;
    if( abs( dir.x ) > 0.0 )
    {
      float invdir = 1. / dir.x;
      t = ( halfBoxSize.x - p.x ) * invdir;
      t = max(  t, ( -halfBoxSize.x - p.x ) * invdir );
      ip = p + dir * t;
      if( all( greaterThanEqual( ip.yz, -halfBoxSize.yz - bias ) ) &&
          all( lessThanEqual( ip.yz, halfBoxSize.yz +  bias ) ) ) return abs( t );
    }
    if( abs( dir.y ) > 0.0 )
    {
      float invdir = 1. / dir.y;
      t = ( halfBoxSize.y - p.y ) * invdir;
      t = max( t, ( -halfBoxSize.y - p.y ) * invdir );
      ip = p + dir * t;
      if( all( greaterThanEqual( ip.xz, -halfBoxSize.xz - bias ) ) &&
          all( lessThanEqual( ip.xz, halfBoxSize.xz +  bias ) ) ) return abs( t );
    }
    if( abs( dir.z ) > 0.0 )
    {
      float invdir = 1. / dir.z;
      t = ( halfBoxSize.z - p.z ) * invdir;
      t = max( t, ( -halfBoxSize.z - p.z ) * invdir );
      ip = p + dir * t;
      if( all( greaterThanEqual( ip.xy, -halfBoxSize.xy - bias ) ) &&
          all( lessThanEqual( ip.xy, halfBoxSize.xy +  bias ) ) ) return abs( t );
    }
    return 0.0;
#endif
}


void main(void)
{
  gl_FragColor = vec4( 0.1, 0.1, 0.1, 0. );
  float tstart = length( raydir );
  // intersection is done by transforming the ray in object space
  vec3 rdir = transpose( gl_NormalMatrix ) * raydir;
  vec3 dir = normalize( rdir );
  bool inside =  all( greaterThanEqual( origin.xyz, -halfBoxSize ) )
                 && all( lessThanEqual( origin.xyz, halfBoxSize ) );
  if( inside ) rdir = -rdir;
#ifdef BACK_TO_FRONT
  maxDistance = max( 0.0, ComputeMaxDistance( dir, origin.xyz + rdir + eps * dir ) );
  vec3 cur = origin.xyz + maxDistance * dir;
  if( !inside ) cur += rdir;
  vec3 dstep = -tstep * dir;
#else
  vec3 cur = origin.xyz + rdir;
  maxDistance = max( 0.0, ComputeMaxDistance( dir, origin.xyz + rdir + eps * dir ) );
  vec3 dstep = tstep * dir;
#endif
  if( maxDistance < eps ) discard;
  //gl_FragColor = vec4( vec3( maxDistance ), 1. );
  //return;
  float tend = tstart + maxDistance;
  int numSteps = int(max( 1, int( ( tend - tstart ) / tstep ) ));
  vec4 P;
  vec3 N;
  // iterate back to front and accumulate color and transparency
  for( int i = 1; i != numSteps; ++i )
  {
    cur += dstep;
    float f = IsoFunction( cur );
    if( !FilterValue( f ) ) continue;
    // shading is done in world space
#if defined( GRADIENT_FILTER ) || defined( COMPUTE_POINT_AND_NORMAL )
    N = gl_NormalMatrix * IsoGradient( cur );
#endif
#if defined( GRADIENT_FILTER )
    if( !FilterGradient( N ) ) continue;
#endif
#ifdef COMPUTE_POINT_AND_NORMAL
    P = gl_ModelViewMatrix * vec4( cur, 1. );
    P.xyzw /= P.w;
#endif
    gl_FragColor = ComputeColor( P.xyz, N, clamp( ( f - minIsoValue ) / dMaxMin, 0., 1. ), gl_FragColor );
#ifndef BACK_TO_FRONT
    if( gl_FragColor.a >= 0.9 ) break;
#endif
  }
}
