#define SET_2
//#define ANIMATE 
uniform int osg_FrameNumber;
#if defined( ANIMATE )
#if defined( SET_1 )
float s = 1000. * ( sin( 3.141 * float( osg_FrameNumber ) / 100.0  ) );
#elif defined( SET_2 )
float s = 10. * ( sin( 3.141 * float( osg_FrameNumber ) / 100.0  ) ); 
#endif
#else
float s = 0.0;
#endif

#if defined( SET_1 )
// set 1
float GetMinIsoValue() { return -1000.0; }
float GetMaxIsoValue() { return 1000.;    }
float GetMaxDistance() { return 10.0;   }
float GetDStep()       { return 0.02;  }
float GetAlphaScale()  { return 0.005;  }
bool  FilterGradient( vec3 G ) { return dot( G, G ) < 1600. ? false : true; }
bool  FilterValue( float v ) { return v >= GetMinIsoValue() && v <= GetMaxIsoValue(); } 
#elif defined( SET_2) 
//set 2
float GetMinIsoValue() { return 0.0; }
float GetMaxIsoValue() { return 10.0;    }
float GetMaxDistance() { return 8.0;   }
float GetDStep()       { return 0.02;  }
float GetAlphaScale()  { return 0.01;  }
bool  FilterValue( float v ) { return v >= GetMinIsoValue() && v <= GetMaxIsoValue(); } 
bool  FilterGradient( vec3 G ) { return dot( G, G ) > 160000. ? false : true; }
#endif

float IsoFunction( in vec3 v )
{
  const float t = (1. + sqrt(5.)) / 2.;
  float t2 = t * t;
  float x2 = v.x * v.x;
  float y2 = v.y * v.y;
  float z2 = v.z * v.z;
  float x4 = x2 * x2;
  float y4 = y2 * y2;
  float z4 = z2 * z2;
  float p = 0.5* ( sqrt( 5. ) + 1. ); 
  float a = 1.0;
  float p2 = p * p;
  float p4 = p2 * p2;
  float x2y2z2a = (x2 + y2 + z2 - a);
  float x2y2z2pa = (x2 + y2 + z2 - (2.-p) * a);
  
  return 8. * (x2 - p4 * y2) * (y2 - p4 * z2) * (z2 - p4 * x2) * 
              (x4 + y4 + z4 - 2. * x2 * y2 - 2. * x2 * z2 - 2. * y2 * z2 )
         + a * (3. + 5. * p) * x2y2z2a * x2y2z2a *  x2y2z2pa * x2y2z2pa - s; 	
 
}