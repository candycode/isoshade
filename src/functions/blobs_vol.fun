uniform int osg_FrameNumber;
#define SET_2
#if defined( SET_1 )
// use with bounding box sizes of 5 1 5 and phong shading to
// see inside
float GetMinIsoValue() { return -1.;    }
float GetMaxIsoValue() { return 1.;    }
float GetMaxDistance() { return 8.0;   }
float GetDStep()       { return 0.01;  }
float GetAlphaScale()  { return 0.1; }
bool  FilterValue( float v ) { return  v >= GetMinIsoValue() && v <= GetMaxIsoValue(); } 
bool  FilterGradient( vec3 G ) { return true; dot( G, G ) > 6. ? false : true; }
#elif defined( SET_2 )
float GetMinIsoValue() { return -1.;    }
float GetMaxIsoValue() { return 1.;    }
float GetMaxDistance() { return 10.0;   }
float GetDStep()       { return 0.01;  }
float GetAlphaScale()  { return 0.01; }
bool  FilterValue( float v ) { return  v >= GetMinIsoValue() && v <= GetMaxIsoValue(); } 
bool  FilterGradient( vec3 G ) { return true; dot( G, G ) > 6. ? false : true; }
#endif
#ifdef ANIMATE
float s = 5.0*( sin( 3.141 * float( osg_FrameNumber ) / 100.0  ) ) + 1.0;
#else
const float s = 1.0;
#endif
float IsoFunction( in vec3 p )
{
  float x2 = p.x * p.x;
  float y2 = p.y * p.y;
  float z2 = p.z * p.z;
 return x2 + y2 + z2 + sin( 4. * p.x ) + sin( 4. * p.y ) + sin( 4. * p.z ) - s;
}