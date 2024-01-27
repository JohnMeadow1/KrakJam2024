shader_type canvas_item;
uniform vec3 digested:source_color;

void fragment() {
	COLOR.rgb = digested;
}
