// NOTE: Shader automatically converted from Godot Engine 4.1.3.stable's StandardMaterial3D.

shader_type spatial;
render_mode unshaded,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;
uniform vec4 albedo : source_color;

uniform float progress  : hint_range(0,1);

void fragment() {
	vec2 base_uv = UV;
	ALBEDO = albedo.rgb;
	//ALPHA = float(distance(base_uv, vec2(0.5, 1.0)) < progress);
	ALPHA = float(distance(UV.x,0.5) < (1.0- UV.y) * .5 && (1.0-UV.y) < progress);
}
