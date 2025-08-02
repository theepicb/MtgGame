shader_type canvas_item;

uniform float time;

void fragment() {
    // Use time to control color variations
    vec3 rainbow_color = vec3(
        sin(time * 1.0),   // Adjust frequency and amplitude as needed
        sin(time * 2.0),
        sin(time * 3.0)
    );

    // Set the opacity (alpha) value for the rainbow effect
    float rainbow_opacity = 0.08; // Adjust the opacity value between 0.0 (fully transparent) and 1.0 (fully opaque)

    // Set the opacity (alpha) value for the original image
    float image_opacity = 1.0;  // Keep the original image fully opaque

    // Combine rainbow color and opacity
    vec4 rainbow_fragment_color = vec4(rainbow_color, rainbow_opacity);

    // Combine original image color and opacity
    vec4 image_fragment_color = texture(TEXTURE, UV) * image_opacity;

    // Blend rainbow effect with original image
    COLOR = mix(image_fragment_color, rainbow_fragment_color, rainbow_opacity);
 }
