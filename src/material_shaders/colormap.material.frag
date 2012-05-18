uniform sampler1D colormap;
float GetAlphaScale();
float alphaScale = GetAlphaScale();
vec4 ComputeColor( vec3 P, vec3 grad, float isoValue, vec4 prevColor )
{
  vec4 c = texture1D( colormap, isoValue ).rgba;
  float a = alphaScale * c.a;
  return vec4( ( 1.0 - a ) * prevColor.rgb +  a * c.rgb, prevColor.a + a );     
}