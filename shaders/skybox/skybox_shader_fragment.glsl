#version 330 core

in vec3 TexCoords;

out vec4 FragColor;

uniform float sunY;

void main()
{
    vec3 skyColor = mix(vec3(0.3, 0.7, 1.0), vec3(0.8, 0.2, 0.3), sunY);
    FragColor = vec4(skyColor, 1.0);
}
