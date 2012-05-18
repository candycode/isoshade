float IsoFunction( in vec3 p )
{
  float x3 = p.x * p.x * p.x;
  float x4 = x3 * p.x;
  float y2 = p.y * p.y;
  float z2 = p.z * p.z;
  return x4 - x3 + y2 + z2;
}