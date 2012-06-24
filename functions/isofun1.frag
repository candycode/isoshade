//Raytracing of functional representations
//Copyright (c) Ugo Varetto

float IsoFunction( in vec3 p )
{
  return dot( p, p ) + sin( 4. * p.x ) + sin( 4. * p.y ) + sin( 4. * p.z ) - 1.;
}

vec3 IsoGradient( in vec3 p )
{
   
  return vec3( 2. * p.x + 4. * cos( 4. * p.x ),
  	       2. * p.y + 4. * cos( 4. * p.y ),
  	       2. * p.z + 4. * cos( 4. * p.z ) );
}