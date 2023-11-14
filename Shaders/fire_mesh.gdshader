shader_type spatial;
render_mode unshaded;

uniform sampler2D tex_dissolve : source_color;
uniform sampler2D tex_displace : source_color;
uniform float dissolve_power = 1;
uniform float dissolve_amount = 0.1;
uniform vec2 dissolve_tiling = vec2(1., 1.); 
uniform vec2 dissolve_speed = vec2(1., 1.);
uniform vec2 dissolve_tiling2 = vec2(1., 1.); 
uniform vec2 dissolve_speed2 = vec2(1., 1.);
uniform vec3 color_a : source_color;
uniform vec3 color_b : source_color;
uniform vec3 color_c : source_color;

vec2 getDissolveUV(vec2 uv) {
	vec2 t = uv * dissolve_tiling;
	vec2 s = TIME * dissolve_speed;
	return t + s;
}

vec2 getDissolveUV2(vec2 uv) {
	vec2 t = uv * dissolve_tiling2;
	vec2 s = TIME * dissolve_speed2;
	return t + s;
}

vec4 calculateDissolveAlpha(vec4 dissolve_value) {
	dissolve_value = pow(dissolve_value, vec4(dissolve_power));
	dissolve_value.a = (dissolve_value.r + dissolve_value.g + dissolve_value.b) / 3.;
	return dissolve_value;
}

void fragment() {
	vec4 dissolve_value = texture(tex_dissolve, getDissolveUV(UV));
	vec4 dissolve_value2 = texture(tex_dissolve, getDissolveUV2(UV));
	dissolve_value = calculateDissolveAlpha(dissolve_value);
	dissolve_value2 = calculateDissolveAlpha(dissolve_value2);
	dissolve_value.a = (dissolve_value.a + dissolve_value2.a) / 2.0;
	dissolve_value.a = pow(dissolve_value.a, .5);
	
	ALBEDO = color_a;
	ALPHA = 1.0;
	if (dissolve_value.a > 0.5) {
		ALBEDO = color_b;
	}
	else if (dissolve_value.a > 0.2 && dissolve_value.a < 0.3) {
		ALBEDO = color_c;
	}
	
}

void vertex() {
	vec4 dissolve_value = texture(tex_dissolve, getDissolveUV(UV) * 0.5f);
	VERTEX.xyz += dissolve_value.xyz * vec3(1.5, 0.0, 1.5);
}