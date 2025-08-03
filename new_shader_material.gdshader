shader_type canvas_item;

uniform float time;
uniform sampler2D overlay_texture;
uniform float overlay_opacity : hint_range(0.0, 1.0) = 1.0;
uniform float brightness : hint_range(0.0, 2.0) = 1.0;

void fragment() {
    vec4 image_color = texture(TEXTURE, UV);

    // Skip fully transparent pixels
    if (image_color.a < 0.01) {
        discard;
    }

    // Apply brightness to base image
    image_color.rgb *= brightness;

    // Time-based foil effect
    vec3 rainbow_color = vec3(
        sin(time * 1.0),
        sin(time * 2.0),
        sin(time * 3.0)
    );
    float rainbow_opacity = 0.08;
    vec3 blended_rgb = mix(image_color.rgb, rainbow_color, rainbow_opacity);

    vec4 base = vec4(blended_rgb, image_color.a); // maintain original alpha

    // Overlay texture
    vec4 overlay_color = texture(overlay_texture, UV);
    overlay_color.a *= overlay_opacity;

    // Final blend
    COLOR = mix(base, overlay_color, overlay_color.a);
}