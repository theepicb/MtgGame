shader_type canvas_item;
render_mode blend_mix;

uniform sampler2D overlay_texture;
uniform float overlay_opacity : hint_range(0.0, 1.0) = 0.42;
uniform float brightness = 1.05;
uniform float time;

void fragment() {
    // Sample base texture
    vec4 tex = texture(TEXTURE, UV);
    if (tex.a < 0.01) discard;

    // Brighten base image
    tex.rgb *= brightness;

    // Rainbow tint (on base image only)
    vec3 rainbow_color = vec3(
        sin(time * 8.0),
        sin(time * 9.0),
        sin(time * 5.0)
    );
    vec3 base_rgb = mix(tex.rgb, rainbow_color, 0.12);

    // Diagonal wave factor for overlay
    float wave = 0.5 + 0.5 * sin((UV.x + UV.y) * 11.0 + time * 6.0);

    // Sample overlay texture
    vec4 overlay = texture(overlay_texture, UV);

    // Blend overlay on top of the already rainbow-tinted base
    float final_alpha = overlay.a * overlay_opacity * wave;
    COLOR.rgb = mix(base_rgb, overlay.rgb, final_alpha);

    // Preserve original alpha
    COLOR.a = tex.a;
}