#define SET_1
#define ANIMATE 
uniform int osg_FrameNumber;
#if defined( ANIMATE )
float s = ( sin( 3.141 * float( osg_FrameNumber ) / 100.0  ) );
#else
float s = 0.0;
#endif

#if defined( SET_1 )
// set 1
const float MIN_ISO_VALUE = -10.0;
const float MAX_ISO_VALUE = 10.0;
float GetMinIsoValue() { return MIN_ISO_VALUE; }
float GetMaxIsoValue() { return MAX_ISO_VALUE;    }
float GetMaxDistance() { return 10.0;   }
float GetDStep()       { return 0.02;  }
float GetAlphaScale()  { return 0.005;  }
float GetGradThreshold() { return 1.0;   }
bool  FilterValue( float v ) { return v >= MIN_ISO_VALUE && v <= MAX_ISO_VALUE; } 
bool  FilterGradient( vec3 G ) { return dot( G, G ) < 1600. ? false : true; }
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

float IsoFunction( in vec3 p )
{
  const float t = (1. + sqrt(5.)) / 2.;
  float t2 = t * t;
  float x2 = p.x * p.x;
  float y2 = p.y * p.y;
  float z2 = p.z * p.z;
  return 4. * ( t2 * x2 - y2 ) * ( t2 * y2  - z2) * ( t2 * z2 - x2 ) -
              (1. + 2.* t)* (x2 + y2 + z2 - 1.)*2. - 10. * s;

}