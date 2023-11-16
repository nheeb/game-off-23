vec2 rotateUV(vec2 uv, vec2 pivot, float angle) {
    float sine = sin(angle);
    float cosine = cos(angle);

    uv -= pivot;
    uv.x = uv.x * cosine - uv.y * sine;
    uv.y = uv.x * sine + uv.y * cosine;
    uv += pivot;

    return uv;
}

mat3 rotation_matrix_x(float angle) {
    float sine = sin(angle);
    float cosine = cos(angle);
	vec3 x = vec3(1, 0, 0);
	vec3 y = vec3(0, cosine, sine);
	vec3 z = vec3(0, -sine, cosine);
	return mat3(x, y, z);
}

mat3 rotation_matrix_y(float angle) {
    float sine = sin(angle);
    float cosine = cos(angle);
	vec3 x = vec3(cosine, 0, -sine);
	vec3 y = vec3(0, 1, 0);
	vec3 z = vec3(sine, 0, cosine);
	return mat3(x, y, z);
}

mat3 rotation_matrix_z(float angle) {
    float sine = sin(angle);
    float cosine = cos(angle);
	vec3 x = vec3(cosine, sine, 0);
	vec3 y = vec3(-sine, cosine, 0);
	vec3 z = vec3(0, 0, 1);
	return mat3(x, y, z);
}