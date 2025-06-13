shader_type canvas_item;

uniform float radius = 16.0; // Eckenradius in Pixeln
uniform float border_size = 2.0;
uniform vec4 border_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
    vec2 size = vec2(textureSize(TEXTURE, 0));
    vec2 pos = UV * size;
    vec2 dist = min(pos, size - pos);
    float corner_dist = min(dist.x, dist.y);

    float mask = smoothstep(0.0, 1.0, corner_dist - radius);
    vec4 tex = texture(TEXTURE, UV);

    // Rahmen
    float border = smoothstep(radius, radius + border_size, corner_dist);
    vec4 final_color = mix(border_color, tex, border);

    COLOR = final_color * mask;
}
