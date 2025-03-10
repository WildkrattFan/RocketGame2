shader_type canvas_item;

void fragment() {
    // Get the original color of the sprite
    vec4 original_color = texture(TEXTURE, UV);

    // Convert the color to grayscale by averaging the RGB values
    float gray = dot(original_color.rgb, vec3(0.3, 0.59, 0.11));

    // Mix the original color with the grayscale version to mute the colors
    float saturation = 0.6; // Reduce saturation (0 = grayscale, 1 = full color)
    vec3 muted_color = mix(vec3(gray), original_color.rgb, saturation);

    // Optionally adjust brightness (use a value between 0 and 1 to darken or lighten)
    float brightness = 0.8; // Lower brightness for a more muted effect
    muted_color *= brightness;

    // Set the output color with the muted color and original alpha
    COLOR = vec4(muted_color, original_color.a);
}
