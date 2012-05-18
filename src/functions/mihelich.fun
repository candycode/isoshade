float IsoFunction( in vec3 p )
{
  const float c2 = 1.;
  const float a2 = 4.;
  float x2 = p.x * p.x;
  float y2 = p.y * p.y;
  float z2 = p.z * p.z;
  return (1. - 2. * p.x + z2 - c2) * 2. - 4. * a2 * (x2 + y2);
}