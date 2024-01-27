shader_type canvas_item;
uniform vec3 digested:source_color;
uniform sampler2D dissolve_texture:source_color;
uniform float dissolve_value : hint_range(0,1);

void fragment() {
    vec4 main_texture = texture(TEXTURE, UV);
    vec4 noise_texture = texture(dissolve_texture, UV);
    main_texture.a *= floor(dissolve_value + min(1, noise_texture.x));
	main_texture.rgb += digested;
    COLOR = main_texture;
}
