shader_type canvas_item;

uniform float blur_strength : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec2 uv_offset = vec2(blur_strength * 0.005);
    vec4 blurred_color = (
        texture(TEXTURE, UV + uv_offset) +
        texture(TEXTURE, UV - uv_offset)
    ) * 0.5;
    COLOR = blurred_color;
}
