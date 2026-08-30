shader_type canvas_item;

uniform bool is_hit = false;

uniform vec3 flash_color: source_color = vec3(1.0);

vec4 hit_flash(vec4 cur_color) {
	return vec4(flash_color.rgb, cur_color.a);
}

void fragment() {
	vec4 cur_color = texture(TEXTURE, UV);
	if (is_hit && cur_color.a > 0.0) {
		COLOR = hit_flash(cur_color);
	}
}