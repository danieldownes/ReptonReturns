shader_type spatial;
render_mode blend_mix, depth_prepass_alpha, cull_back;

// === Uniforms ===

// Core color & glow
uniform vec4 orb_color : source_color = vec4(0.3, 0.5, 1.0, 1.0);
uniform float orb_alpha : hint_range(0.0, 1.0) = 0.85;
uniform float glow_intensity : hint_range(0.0, 10.0) = 3.0;

// Scrolling electric texture
uniform float scroll_speed_1 : hint_range(0.0, 2.0) = 0.3;
uniform float scroll_speed_2 : hint_range(0.0, 2.0) = 0.2;
uniform float electric_scale : hint_range(0.5, 10.0) = 3.0;
uniform float electric_brightness : hint_range(0.0, 5.0) = 2.0;

// Vertex displacement
uniform float displacement_strength : hint_range(0.0, 0.2) = 0.06;
uniform float displacement_speed : hint_range(0.0, 3.0) = 1.2;
uniform float displacement_scale : hint_range(0.5, 10.0) = 2.5;

// Distortion (refraction)
uniform float distortion_strength : hint_range(0.0, 0.2) = 0.04;
uniform float distortion_speed : hint_range(0.0, 2.0) = 0.5;
uniform float distortion_scale : hint_range(0.5, 10.0) = 3.0;

// Fresnel (rim glow)
uniform float fresnel_power : hint_range(0.5, 8.0) = 2.5;
uniform float fresnel_intensity : hint_range(0.0, 5.0) = 1.5;
uniform vec4 fresnel_color : source_color = vec4(0.6, 0.8, 1.0, 1.0);

// Screen texture for refraction
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear_mipmap;

// =====================================================================
// Procedural noise functions (no external textures needed)
// =====================================================================

// Hash function for pseudo-random values
float hash(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

// 2D value noise
float value_noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	f = f * f * (3.0 - 2.0 * f); // smoothstep

	float a = hash(i);
	float b = hash(i + vec2(1.0, 0.0));
	float c = hash(i + vec2(0.0, 1.0));
	float d = hash(i + vec2(1.0, 1.0));

	return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

// Fractal Brownian Motion (layered noise)
float fbm(vec2 p, int octaves) {
	float value = 0.0;
	float amplitude = 0.5;
	float frequency = 1.0;
	for (int i = 0; i < octaves; i++) {
		value += amplitude * value_noise(p * frequency);
		frequency *= 2.0;
		amplitude *= 0.5;
	}
	return value;
}

// Electric/lightning pattern — sharp ridges from noise
float electric_pattern(vec2 uv, float time_offset) {
	float n1 = fbm(uv * electric_scale + time_offset, 4);
	float n2 = fbm(uv * electric_scale * 1.5 + time_offset * 0.7 + vec2(5.2, 1.3), 4);

	// Create sharp electric arcs by taking abs of centered noise
	float arc1 = 1.0 - abs(n1 - 0.5) * 2.0;
	float arc2 = 1.0 - abs(n2 - 0.5) * 2.0;

	// Sharpen with power function
	arc1 = pow(max(arc1, 0.0), 3.0);
	arc2 = pow(max(arc2, 0.0), 3.0);

	return arc1 + arc2;
}

// Twirl distortion pattern
vec2 twirl_noise(vec2 uv, float time_val) {
	float angle = fbm(uv * distortion_scale + time_val, 3) * 6.28318;
	float radius = fbm(uv * distortion_scale * 0.7 + time_val * 0.5 + vec2(3.7, 8.1), 3);
	return vec2(cos(angle), sin(angle)) * radius;
}

// =====================================================================
// Vertex shader — displacement for "living" wobble
// =====================================================================

void vertex() {
	float noise_val = fbm(
		VERTEX.xz * displacement_scale + TIME * displacement_speed,
		3
	);
	// Displace along normal for organic bulging
	VERTEX += NORMAL * (noise_val - 0.5) * displacement_strength;
}

// =====================================================================
// Fragment shader
// =====================================================================

void fragment() {
	// --- 1. Scrolling electric textures (two layers, opposite directions) ---
	vec2 uv1 = UV + vec2(TIME * scroll_speed_1, TIME * scroll_speed_1 * 0.7);
	vec2 uv2 = UV - vec2(TIME * scroll_speed_2 * 0.8, TIME * scroll_speed_2);

	float electric1 = electric_pattern(uv1, TIME * 0.3);
	float electric2 = electric_pattern(uv2, -TIME * 0.25);

	float electric_combined = (electric1 + electric2) * electric_brightness;

	// --- 2. Fresnel (rim glow) ---
	float fresnel = pow(1.0 - max(dot(NORMAL, VIEW), 0.0), fresnel_power);
	fresnel *= fresnel_intensity;

	// --- 3. Distortion of background (refraction) ---
	vec2 twirl = twirl_noise(UV, TIME * distortion_speed);
	// Convert to normal-map-like offset
	vec2 distort_offset = twirl * distortion_strength;

	vec2 screen_uv = SCREEN_UV + distort_offset;
	vec3 refracted_scene = textureLod(screen_texture, screen_uv, 0.0).rgb;

	// --- 4. Combine layers ---
	// Base: refracted scene behind the orb (transparency)
	vec3 base = refracted_scene;

	// Electric core: HDR colored lightning
	vec3 electric_color = orb_color.rgb * electric_combined * glow_intensity;

	// Fresnel rim
	vec3 rim = fresnel_color.rgb * fresnel * glow_intensity * 0.5;

	// Final mix: background + electric core + fresnel rim
	vec3 final_color = base * (1.0 - orb_alpha) + electric_color + rim;

	ALBEDO = final_color;
	// Use emission for HDR bloom
	EMISSION = electric_color * 0.25 + rim * 0.15;
	ALPHA = clamp(orb_alpha + fresnel * 0.3 + electric_combined * 0.15, 0.0, 1.0);
}
