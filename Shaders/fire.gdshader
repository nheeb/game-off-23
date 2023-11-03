shader_type spatial;

uniform sampler2D tex_main : source_color;
uniform sampler2D tex_dissolve : source_color;
uniform float dissolve_power = 1;
uniform float dissolve_amount = 0.1;
uniform vec2 dissolve_tiling = vec2(1., 1.); 
uniform vec2 dissolve_speed = vec2(1., 1.);


vec2 getDissolveUV(vec2 uv) {
	vec2 t = uv * dissolve_tiling;
	vec2 s = TIME * dissolve_speed;
	return t + s;
}

void fragment() {
	vec4 texture_value = texture(tex_main, UV);
	
	vec4 dissolve_value = texture(tex_dissolve, getDissolveUV(UV));
	dissolve_value = pow(dissolve_value, vec4(dissolve_power));
	dissolve_value.a = (dissolve_value.r + dissolve_value.g + dissolve_value.b) / 3.;
	
	vec4 tex_dissolve_product = texture_value * dissolve_value;
	vec4 mix_dissolved = mix(texture_value, tex_dissolve_product, dissolve_amount);
	
	vec4 colored = mix_dissolved * COLOR;
	
	ALBEDO = colored.xyz;
	ALPHA = colored.w;
}

void vertex() {
	// Billboard
	mat4 __wm = mat4(normalize(INV_VIEW_MATRIX[0]), normalize(INV_VIEW_MATRIX[1]), normalize(INV_VIEW_MATRIX[2]), MODEL_MATRIX[3]);
	__wm = __wm * mat4(vec4(cos(INSTANCE_CUSTOM.x), -sin(INSTANCE_CUSTOM.x), 0.0, 0.0), vec4(sin(INSTANCE_CUSTOM.x), cos(INSTANCE_CUSTOM.x), 0.0, 0.0), vec4(0.0, 0.0, 1.0, 0.0), vec4(0.0, 0.0, 0.0, 1.0));
	__wm = __wm * mat4(vec4(length(MODEL_MATRIX[0].xyz), 0.0, 0.0, 0.0), vec4(0.0, length(MODEL_MATRIX[1].xyz), 0.0, 0.0), vec4(0.0, 0.0, length(MODEL_MATRIX[2].xyz), 0.0), vec4(0.0, 0.0, 0.0, 1.0));
	MODELVIEW_MATRIX = VIEW_MATRIX * __wm;
}