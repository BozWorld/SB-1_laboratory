shader_type spatial;
render_mode unshaded, depth_test_disabled, depth_draw_never, cull_disabled, blend_mix;

// Declare depth texture explicitly for Godot 4
uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_linear_mipmap;

uniform vec3 outline_color : source_color = vec3(0.0);
uniform float edge_thickness = 2.0;    // en pixels (1–3)
uniform float depth_threshold = 0.008; // seuil pour profondeur non linéaire
uniform float softness = 0.02;

// IMPORTANT: ne redéclare pas SCREEN_TEXTURE/DEPTH_TEXTURE, ils sont fournis par Godot.

float sobel_depth(vec2 uv, vec2 t) {
	float d00 = texture(DEPTH_TEXTURE, uv + t * vec2(-1.0,-1.0)).r;
	float d10 = texture(DEPTH_TEXTURE, uv + t * vec2( 0.0,-1.0)).r;
	float d20 = texture(DEPTH_TEXTURE, uv + t * vec2( 1.0,-1.0)).r;
	float d01 = texture(DEPTH_TEXTURE, uv + t * vec2(-1.0, 0.0)).r;
	float d21 = texture(DEPTH_TEXTURE, uv + t * vec2( 1.0, 0.0)).r;
	float d02 = texture(DEPTH_TEXTURE, uv + t * vec2(-1.0, 1.0)).r;
	float d12 = texture(DEPTH_TEXTURE, uv + t * vec2( 0.0, 1.0)).r;
	float d22 = texture(DEPTH_TEXTURE, uv + t * vec2( 1.0, 1.0)).r;

    float sx = (d20 + 2.0*d21 + d22) - (d00 + 2.0*d01 + d02);
    float sy = (d02 + 2.0*d12 + d22) - (d00 + 2.0*d10 + d20);
    return length(vec2(sx, sy));
}

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec2 texel = edge_thickness / VIEWPORT_SIZE;
	vec3 scene = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0).rgb;

	float de = sobel_depth(SCREEN_UV, texel);
	float edge = smoothstep(depth_threshold, depth_threshold + softness, de);

	ALBEDO = mix(scene, outline_color, edge);
	ALPHA = 1.0;
}
