//Raytracing of functional representations
//Copyright (c) Ugo Varetto

float IsoFunction( in vec3 p )
{
  return p.x * p.y * p.z * exp(-.8*dot(p,p)) - .019;
}