shader_type canvas_item;

// === COLORES DE BIOMAS (EDITABLES EN INSPECTOR) ===
uniform vec4 desert_color     : source_color = vec4(1.0, 0.9, 0.2, 1.0);
uniform vec4 dirt_color       : source_color = vec4(0.45, 0.3, 0.15, 1.0);
uniform vec4 grass_color      : source_color = vec4(0.2, 0.7, 0.2, 1.0);
uniform vec4 snow_color       : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 concrete_color   : source_color = vec4(0.6, 0.6, 0.6, 1.0);
uniform vec4 fungus_color     : source_color = vec4(0.6, 0.2, 0.7, 1.0);
uniform vec4 agua_color     : source_color = vec4(0.6, 0.2, 0.7, 1.0);

// === AJUSTES ===
uniform float color_threshold = 0.06;
uniform float noise_scale = 18.0;
uniform float blend_strength = 0.6;

// ================= NOISE =================
float rand(vec2 p) {
    p = fract(p * vec2(123.34, 6.21));
    p += dot(p, p + 25.32);
    return fract(p.x * p.y);
}

float noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	vec2 u = f * f * (3.0 - 2.0 * f);
	
	return mix(
		mix(rand(i), rand(i + vec2(1,0)), u.x),
		mix(rand(i + vec2(0,1)), rand(i + vec2(1,1)), u.x),
		u.y
	);
}

float fbm(vec2 p) {
	float v = 0.0;
	float a = 0.5;
	for (int i = 0; i < 4; i++) {
		v += noise(p) * a;
		p *= 2.0;
		a *= 0.5;
	}
	return v;
}

vec2 warp(vec2 p) {
	float w1 = noise(p * 3.8);
	float w2 = noise(p * 2.8 + 1513.4);
	return p + vec2(w1, w2) * 25.5;
}

float blobs(vec2 p) {
	float n = fbm(p * 0.6);
	return smoothstep(0.65, 0.8, n);
}

float match_color(vec3 a, vec3 b) {
	return smoothstep(color_threshold, 0.0, distance(a, b));
}

// ================= BIOMAS =================
vec3 desert(float n) {
	return mix(vec3(0.82,0.72,0.4), vec3(0.95,0.85,0.55), n);
}

vec3 dirt(float n) {
	return mix(vec3(0.35,0.2,0.1), vec3(0.5,0.35,0.2), n);
}

/*vec3 grass(float n) {
	return mix(vec3(0.1,0.45,0.1), vec3(0.25,0.75,0.25), n);
}*/
vec3 grass(vec2 px) {
	vec2 p = warp(px * 0.05);

	float base = fbm(p);
	float rocks = blobs(p * 0.7);

	vec3 col = mix(
		vec3(0.15, 0.5, 0.15),
		vec3(0.3, 0.75, 0.3),
		base
	);

	// grumos claros/oscuros
	col = mix(col, col * 0.75, rocks);

	return col;
}

vec3 snow(float n) {
	return mix(vec3(0.9), vec3(1.0), n);
}

vec3 concrete(float n) {
	return mix(vec3(0.5), vec3(0.7), n);
}

vec3 fungus(float n) {
	return mix(
		vec3(0.45, 0.18, 0.55),
		vec3(0.7, 0.35, 0.85),
		n
	);
}

vec3 water(vec2 px) {
	// corregir escala según tamaño real del sprite

	float w1 = noise(px * 1.5 + vec2(TIME * 0.7, 0.0));
	float w2 = noise(px * 1.8 + vec2(0.0, TIME * 0.5));

	float w = (w1 + w2) * 0.5;

	return mix(
		vec3(0.03, 0.18, 0.35),
		vec3(0.12, 0.45, 0.7),
		w
	);
}

// ================= MAIN =================
void fragment() {
	vec4 map = texture(TEXTURE, UV);
	float n = noise(UV * noise_scale);
	
	// === MATCHES ===
	float d_desert   = match_color(map.rgb, desert_color.rgb);
	float d_dirt     = match_color(map.rgb, dirt_color.rgb);
	float d_grass    = match_color(map.rgb, grass_color.rgb);
	float d_snow     = match_color(map.rgb, snow_color.rgb);
	float d_concrete = match_color(map.rgb, concrete_color.rgb);
	float d_fungus   = match_color(map.rgb, fungus_color.rgb);
	float d_water = match_color(map.rgb, agua_color.rgb);

	vec3 col = vec3(0.0);
	float total = 0.0;
	vec2 px = UV / TEXTURE_PIXEL_SIZE;

	col += desert(n)   * d_desert;   total += d_desert;
	col += dirt(n)     * d_dirt;     total += d_dirt;
	col += grass(px)    * d_grass;    total += d_grass;
	col += snow(n)     * d_snow;     total += d_snow;
	col += concrete(n) * d_concrete; total += d_concrete;
	col += fungus(n)   * d_fungus;   total += d_fungus;
	col += water(px) * d_water; total += d_water;

	col /= max(total, 0.001);

	COLOR = vec4(col, 1.0);
}
