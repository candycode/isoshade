uniform sampler1D colormap;
float GetAlphaScale();
float alphaScale = 3.0 * GetAlphaScale();
vec4 ComputeColor( vec3 P, vec3 grad, float isoValue, vec4 prevColor )
{
  vec4 c  = vec4( grad, 1. );
  c.xyz = vec3( abs( c.x ), abs( c.y ), abs( c.z ) );
  c = clamp( c, 0., 1. );
  float a = alphaScale * c.a;
  return vec4( ( 1.0 - a ) * prevColor.rgb +  a * c.rgb, prevColor.a + a );     
}