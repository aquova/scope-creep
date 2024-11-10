shader_type canvas_item;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	if (color.a != 0.0) {
		color.r = 0.25 * sin(TIME * 2.0) + 0.5;
		color.g = 0.0;
		color.b = 0.25;
	}
	COLOR = color;
}