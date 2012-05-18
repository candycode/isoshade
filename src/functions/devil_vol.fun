float GetMinIsoValue() { return 0.;    }
float GetMaxIsoValue() { return 1.;    }
float GetMaxDistance() { return 8.0;   }
float GetDStep()       { return 0.01;  }
float GetAlphaScale()  { return 0.01; }
bool  FilterValue( float v ) { return v >= GetMinIsoValue() && v <= GetMaxIsoValue(); } 
bool  FilterGradient( vec3 G ) { return dot( G, G ) > 6. ? false : true; }

float IsoFunction( in vec3 p )
{
  float x2 = p.x * p.x;
  float y2 = p.y * p.y;
  float z2 = p.z * p.z;
  float x4 = x2 * x2;
  float y4 = y2 * y2;
  float z4 = z2 * z2;
  return x4 + 2.* x2 * z2 - 0.36 * x2 - y4 + 0.25 * y2 + z4; 
}