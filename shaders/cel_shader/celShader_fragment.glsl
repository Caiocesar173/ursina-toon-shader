#version 330

in vec3 frag_normal;
in vec3 frag_position;

uniform vec3 light_position;

out vec4 frag_color;

void main()
{
    vec3 light_dir = normalize(light_position - frag_position);
    float diff = max(dot(frag_normal, light_dir), 0.0);

    // Logic for cel shading effect
    if(diff > 0.95) diff = 1.0;
    else if(diff > 0.5) diff = 0.7;
    else if(diff > 0.2) diff = 0.4;
    else diff = 0.2;

    frag_color = vec4(vec3(diff), 1.0);
}
