float IsoFunction( in vec3 p )
{
  float x2 = p.x * p.x;
  float y2 = p.y * p.y;
  float z2 = p.z * p.z;
  float x4 = x2 * x2;
  float x6 = x4 * x2;
  float x8 = x6 * x2;
  float y4 = y2 * y2;
  return 0.04 - x4 + 2. * x6 - x8 + 2. * x2 * y2 - 2. * x4 * y2 - y4 - z2;
}