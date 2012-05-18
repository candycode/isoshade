uniform sampler1D colormap;
float GetAlphaScale();
float alphaScale = 10. * GetAlphaScale();
vec3 lightDir = normalize( vec3( 0., 0., -1. ) );
const float kd = 1.;
const float ka = 0.1;
const float ks = 0.8;
const float sh = 10.;
const vec3 refcolor = vec3( 1., 1., 1. );
vec4 ComputeColor( vec3 P, vec3 grad, float isoValue, vec4 prevColor )
{
  vec4 c = texture1D( colormap, isoValue ).rgba;
  float a = alphaScale * c.a;
  vec3 N = normalize( faceforward( -grad, lightDir, grad ) );
  float d = dot( N , lightDir );
  float s = pow( max( 0.1, dot( vec3( 0, 0, 1 ), reflect( lightDir, N ) ) ), sh );
  vec4 newColor =  vec4( ( 1.0 - a ) * prevColor.rgb +  a * c.rgb, prevColor.a + a );
  return vec4(  ks * s * refcolor + kd * d * newColor.rgb + ka * newColor.rgb, newColor.a );
}