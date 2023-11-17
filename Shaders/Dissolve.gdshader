shader_type spatial;
render_mode blend_mix, cull_disabled;
uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color;
uniform float specular;
uniform float metallic;
uniform float roughness : hint_range(0,1);
uniform float point_size : hint_range(0,128);
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;

uniform sampler2D dissolve_texture;
uniform sampler2D dissolve_ramp;

varying float dissolve_amount;
varying float uv_offset;


void vertex() {
	dissolve_amount = textureLod(dissolve_ramp, vec2(INSTANCE_CUSTOM.y/INSTANCE_CUSTOM.w, 0.0), 0.0).r;
	uv_offset = INSTANCE_CUSTOM.x;
}


void fragment() {
	ALBEDO = COLOR.rgb;
	vec2 sample_vector = UV + uv_offset;
	float sample = texture(dissolve_texture, sample_vector).r;
	ALPHA = clamp(smoothstep(dissolve_amount - 0.3, dissolve_amount, sample), 0.0, 1.0);
}