shader_type canvas_item;

uniform vec2 center;
uniform float force: hint_range(0.0, 0.1, 0.001) = 0.08;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform float radius: hint_range(0.0, 1.0, 0.001) = 0.25;
uniform float thickness: hint_range(0.001, 0.300, 0.001);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 st = SCREEN_UV;
	float ratio = SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;
	vec2 scaled_uv = (SCREEN_UV - vec2(0.0, 0.5)) / vec2(1.0, ratio) + vec2(0, 0.5);
	float mask = (1.0 - smoothstep(radius - 0.1, radius, length(scaled_uv - center))) *
	smoothstep(radius - thickness - 0.1, radius - thickness, length(scaled_uv - center));
	vec2 disp = normalize(scaled_uv - center) * force * mask;
	COLOR = texture(SCREEN_TEXTURE, st * (1.0-mask) + (scaled_uv - disp)*mask);
	//COLOR.rgb = vec3(mask);	// show mask
 }

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
