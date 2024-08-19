shader_type canvas_item;

uniform float trail_fade = 0.98; // Controls how quickly the trail fades (0.0 to 1.0)
uniform vec4 trail_color : source_color = vec4(0.0, 0.5, 1.0, 1.0); // The color of the trail
uniform sampler2D SCREEN_TEXTRUE : hint_screen_texture, filter_linear_mipmap;


void fragment() {
    vec4 current_color = texture(SCREEN_TEXTURE, SCREEN_UV);

    // Mix the current screen color with the trail color
    vec4 final_color = mix(current_color, trail_color, 1.0 - trail_fade);
    
    // Blend the trail color based on the alpha and trail_fade
    final_color.a = max(final_color.a, trail_color.a * (1.0 - trail_fade));
    
    // Apply the final color to the screen
    COLOR = final_color;
}
