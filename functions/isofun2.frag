//Raytracing of functional representations
//Copyright (c) Ugo Varetto

float IsoFunction( in vec3 p )
{
  return p.x * p.y * p.z * exp(-.8*dot(p,p)) - .019;
}

vec3 IsoGradient( in vec3 p )
{
  float xs = p.x * p.x;
  float ys = p.y * p.y;
  float zs = p.z * p.z;
  float ex2 = exp( -p.x * p.x );
  float ey2 = exp( -p.y * p.y );
  float ez2 = exp( -p.z * p.z );

  return vec3( ex2 * ( 1.0 - 2.0 * xs ) * p.y * p.z * ey2 * ez2,
               ey2 * ( 1.0 - 2.0 * ys ) * p.x * p.z * ex2 * ez2,
               ez2 * ( 1.0 - 2.0 * zs ) * p.x * p.y * ex2 * ey2 );
}