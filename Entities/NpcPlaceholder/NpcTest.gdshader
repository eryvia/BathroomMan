shader_type spatial;

uniform vec4 my_color : source_color = vec4(2.0, 0.5, 0.0, 1.0);
uniform float my_roughness : hint_range(0.0, 1.0) = 0.5;
uniform sampler2D my_texture : source_color;
uniform sampler2D normal_tex : hint_normal;

void fragment() {
    ALBEDO = texture(my_texture, UV).rgb * my_color.rgb;
    ROUGHNESS = my_roughness;
    NORMAL = texture(normal_tex, UV).rgb;
}