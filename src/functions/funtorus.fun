uniform int osg_FrameNumber;
float IsoFunction( in vec3 p )
{
  float x2 = p.x * p.x;
  float y2 = p.y * p.y;
  float z2 = p.z * p.z;
  float x4 = x2 * x2;
  float yz2 = y2 + z2;
  float c = 22. * sin( 3.141 * osg_FrameNumber/ 200. ); 
  float fp = 4. * ( x4 + yz2 * yz2 ) +
             c * x2 * ( y2 + z2 ) -20. * ( x2 + y2 + z2 ) + c; 
  return fp;         
}