shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;
uniform float pixel_size = 3.0;         // pixelation amount
uniform float dither_strength = 0.08;   // grain/dither
uniform float color_depth = 16.0;       // color banding (lower = more PS1)

// Simple pseudo-random for dithering
float rand(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    vec2 uv = SCREEN_UV;

    // Pixelation — snap UVs to a grid
    vec2 screen_size = 1.0 / SCREEN_PIXEL_SIZE;
    vec2 pixelated = floor(uv * screen_size / pixel_size)
                     * pixel_size / screen_size;

    vec3 color = texture(SCREEN_TEXTURE, pixelated).rgb;

    // Color depth reduction (banding)
    color = floor(color * color_depth) / color_depth;

    // Dithering / film grain
    float noise = rand(uv + fract(TIME)) * dither_strength;
    color += noise - (dither_strength * 0.5);

    COLOR = vec4(color, 1.0);
}