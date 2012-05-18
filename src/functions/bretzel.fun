float IsoFunction( in vec3 p )
{
  float x2 = p.x * p.x;
  float y2 = p.y * p.y;
  float z2 = p.z * p.z;
  return ( x2 * ( 1. - x2 ) - y2 ) * 2. + z2 - 0.01; 
}