shader_type canvas_item;
uniform float shift = 0;

vec3 hueShift(vec3 col, float hue) {
    const vec3 k = vec3(0.57735, 0.57735, 0.57735);
    float cosAngle = cos(hue);
    return vec3(col * cosAngle + cross(k, col) * sin(hue) + k * dot(k, col) * (1.0 - cosAngle));
}

void fragment() {
	vec4 c = texture(TEXTURE, UV);
	c.rgb = hueShift(c.rgb, shift);
//	c.a = COLOR.a;
	c.a = COLOR.a;
	COLOR = c;
}