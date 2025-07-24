// Wind Waker style water - NekotoArts
// Adapted from https://www.shadertoy.com/view/3tKBDz
// After which I added in some fractal Brownian motion
// as well as vertex displacement

shader_type spatial;

uniform vec4 WATER_COL : source_color =  vec4(0.04, 0.38, 0.88, 1.0);
uniform vec4 WATER2_COL : source_color =  vec4(0.04, 0.35, 0.78, 1.0);
uniform vec4 FOAM_COL : source_color = vec4(0.8125, 0.9609, 0.9648, 1.0);
uniform vec4 HORIZON_COL : source_color = vec4(0.3, 0.6, 0.9, 1.0); // NOUVEAU: Couleur horizon
uniform float distortion_speed = 1.5;
uniform vec2 tile = vec2(20.0, 20.0); // OPTIMAL: 20 tuiles pour 2000m = 100m par tuile
uniform float height = 1.5;
uniform vec2 wave_size = vec2(8.0, 8.0); // OPTIMAL: Vagues plus grandes pour 2000m
uniform float wave_speed = 1.2;
uniform float pattern_scale = 0.3; // OPTIMAL: Motifs très fins pour éviter répétition
uniform float pattern_variation = 1.2; // OPTIMAL: Forte variation
uniform float horizon_distance = 0.85; // NOUVEAU: Distance de début du fade horizon

const float M_2PI = 6.283185307;
const float M_6PI = 18.84955592;

float random(vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) *
            43758.5453123);
}

float noise(vec2 uv) {
    vec2 uv_index = floor(uv);
    vec2 uv_fract = fract(uv);

    // Four corners in 2D of a tile
    float a = random(uv_index);
    float b = random(uv_index + vec2(1.0, 0.0));
    float c = random(uv_index + vec2(0.0, 1.0));
    float d = random(uv_index + vec2(1.0, 1.0));

    vec2 blur = smoothstep(0.0, 1.0, uv_fract);

    return mix(a, b, blur.x) +
            (c - a) * blur.y * (1.0 - blur.x) +
            (d - b) * blur.x * blur.y;
}

float fbm(vec2 uv) {
    int octaves = 6;
    float amplitude = 0.5;
    float frequency = 3.0;
	float value = 0.0;

    for(int i = 0; i < octaves; i++) {
        value += amplitude * noise(frequency * uv);
        amplitude *= 0.5;
        frequency *= 2.0;
    }
    return value;
}

// OPTIMISÉ: FBM simplifié pour de meilleures performances
float fbm_detailed(vec2 uv) {
    int octaves = 4; // RÉDUIT de 8 à 4 octaves
    float amplitude = 0.5;
    float frequency = 1.0;
    float value = 0.0;
    
    for(int i = 0; i < octaves; i++) {
        value += amplitude * noise(frequency * uv);
        amplitude *= 0.5; // Simplifié
        frequency *= 2.0; // Simplifié
    }
    return value;
}

float circ(vec2 pos, vec2 c, float s)
{
    c = abs(pos - c);
    c = min(c, 1.0 - c);

    return smoothstep(0.0, 0.002, sqrt(s) - sqrt(dot(c, c))) * -1.0;
}

// OPTIMISÉ: Foam pattern simplifié
float waterlayer(vec2 uv)
{
    // SIMPLIFIÉ: Domain warp réduit pour de meilleures performances
    vec2 domain_warp = vec2(
        fbm_detailed(uv * 0.2), // RÉDUIT de 0.3 à 0.2
        fbm_detailed(uv * 0.2 + vec2(127.1, 311.7))
    ) * pattern_variation * 0.5; // RÉDUIT l'intensité
    uv += domain_warp;
    
    uv = mod(uv, 1.0);

    float ret = 1.0;
    float scale = pattern_scale;
    
    // OPTIMISÉ: Gardé seulement les cercles les plus importants (20 au lieu de 62)
    ret += circ(uv, vec2(0.37378, 0.277169), 0.0268181 * scale);
    ret += circ(uv, vec2(0.0317477, 0.540372), 0.0193742 * scale);
    ret += circ(uv, vec2(0.430044, 0.882218), 0.0232337 * scale);
    ret += circ(uv, vec2(0.641033, 0.695106), 0.0117864 * scale);
    ret += circ(uv, vec2(0.0146398, 0.0791346), 0.0299458 * scale);
    ret += circ(uv, vec2(0.43871, 0.394445), 0.0289087 * scale);
    ret += circ(uv, vec2(0.909446, 0.878141), 0.028466 * scale);
    ret += circ(uv, vec2(0.310149, 0.686637), 0.0128496 * scale);
    ret += circ(uv, vec2(0.928617, 0.195986), 0.0152041 * scale);
    ret += circ(uv, vec2(0.0438506, 0.868153), 0.0268601 * scale);
    ret += circ(uv, vec2(0.563517, 0.244991), 0.0292322 * scale);
    ret += circ(uv, vec2(0.566936, 0.954457), 0.00981141 * scale);
    ret += circ(uv, vec2(0.71403, 0.576945), 0.0215641 * scale);
    ret += circ(uv, vec2(0.748873, 0.413325), 0.0110795 * scale);
    ret += circ(uv, vec2(0.0623365, 0.896713), 0.0236203 * scale);
    ret += circ(uv, vec2(0.647463, 0.654349), 0.0188713 * scale);
    ret += circ(uv, vec2(0.428928, 0.382426), 0.0298806 * scale);
    ret += circ(uv, vec2(0.525104, 0.572233), 0.0141796 * scale);
    ret += circ(uv, vec2(0.431526, 0.911372), 0.0213234 * scale);
    ret += circ(uv, vec2(0.514523, 0.243263), 0.0270685 * scale);
    
	return max(ret, 0.0);
}

// Procedural texture generation for the water - OPTIMISÉ
vec3 water(vec2 uv, vec3 cdir, float iTime)
{
    // SIMPLIFIÉ: Calcul de distance une seule fois
    float distance_from_center = length(uv - vec2(0.5));
    
    uv *= vec2(0.25);
    uv += fbm(uv) * 0.2;

    // Parallax height distortion - simplifié
    vec2 a = 0.025 * cdir.xz / cdir.y;
    float h = sin(uv.x + iTime);
    uv += a * h;
    h = sin(0.841471 * uv.x - 0.540302 * uv.y + iTime);
    uv += a * h;

    // Texture distortion - RESTAURÉ pour vagues visibles
    float d1 = mod(uv.x + uv.y, M_2PI);
    float d2 = mod((uv.x + uv.y + 0.25) * 1.3, M_6PI);
    d1 = iTime * 0.07 + d1;
    d2 = iTime * 0.5 + d2;
    
    vec2 dist = vec2(
        sin(d1) * 0.15 + sin(d2) * 0.05,
        cos(d1) * 0.15 + cos(d2) * 0.05
    );

    // Génération de la texture eau
    vec3 ret = mix(WATER_COL.rgb, WATER2_COL.rgb, waterlayer(uv + dist.xy));
    ret = mix(ret, FOAM_COL.rgb, waterlayer(vec2(1.0) - uv - dist.yx));
    
    // EFFET HORIZON OPTIMISÉ: Fade simple vers l'horizon
    float horizon_fade = smoothstep(horizon_distance, 1.0, distance_from_center);
    ret = mix(ret, HORIZON_COL.rgb, horizon_fade * 0.7); // Réduction de l'intensité
    
    return ret;
}


void vertex(){
    float time = TIME * wave_speed;
    vec2 uv = UV * wave_size;
    
    // OPTIMISÉ: Calcul simplifié des vagues
    float d1 = mod(uv.x + uv.y, M_2PI);
    float d2 = mod((uv.x + uv.y + 0.25) * 1.3, M_6PI);
    
    d1 = time * 0.07 + d1;
    d2 = time * 0.5 + d2;
    
    float wave_height = sin(d1) * 0.15 + sin(d2) * 0.05;
    
    // RESTAURÉ: Vagues visibles avec atténuation douce seulement aux bords
    float distance_from_center = length(UV - vec2(0.5));
    float wave_attenuation = 1.0 - smoothstep(0.85, 1.0, distance_from_center);
    
    VERTEX.y += wave_height * height * wave_attenuation;
}

void fragment()
{
	vec2 uv = UV;

    ALBEDO = vec3(water(uv * tile, vec3(0,1,0), TIME * distortion_speed));
}