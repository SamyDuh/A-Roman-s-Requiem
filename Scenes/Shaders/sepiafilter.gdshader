shader_type canvas_item;
	
uniform sampler2D screen_tex: hint_screen_texture, filter_linear;
uniform float intensity: hint_range(0.0,1.0) = 0.0;

void fragment() {
	// Called for every pixel the material is visible on.
	vec3 pixel_color = texture(screen_tex, SCREEN_UV).rgb;
	
	float r = pixel_color.r;
	float g = pixel_color.g;
	float b = pixel_color.b;
	
	vec3 sepia;
	sepia.r = (r * .393) + (g * .769) + (b * .189);
	sepia.g = (r * .393) + (g * .769) + (b * .189);
	sepia.b = (r * .393) + (g * .769) + (b * .189);
	
	COLOR.rgb = mix(pixel_color, sepia, intensity);
	COLOR.a = texture(screen_tex, SCREEN_UV).a;
	
}
