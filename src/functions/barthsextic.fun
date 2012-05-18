float IsoFunction( in vec3 p )
{
  const float t = (1. + sqrt(5.)) / 2.;
  float t2 = t * t;
  float x2 = p.x * p.x;
  float y2 = p.y * p.y;
  float z2 = p.z * p.z;
  return 4. * ( t2 * x2 - y2 ) * ( t2 * y2  - z2) * ( t2 * z2 - x2 ) -
              (1. + 2.* t)* (x2 + y2 + z2 - 1.)*2.;

}