#version 330 core

in vec3 TexCoords;

out vec4 FragColor;

uniform float sunY;

void main()
{
    vec3 sunriseColor = vec3(0.8, 0.3, 0.2);
    vec3 dayColor = vec3(0.3, 0.7, 1.0);
    vec3 sunsetColor = vec3(0.8, 0.2, 0.3);
    vec3 nightColor = vec3(0.1, 0.1, 0.3);

    vec3 skyColor;

    if(sunY > 0.75)
        skyColor = mix(sunsetColor, dayColor, (sunY - 0.75) * 4.0);
    else if(sunY > 0.25)
        skyColor = mix(sunriseColor, dayColor, (sunY - 0.25) * 2.0);
    else if(sunY > -0.25)
        skyColor = mix(nightColor, sunriseColor, sunY + 0.25);
    else
        skyColor = mix(nightColor, sunsetColor, sunY + 0.75);

    FragColor = vec4(skyColor, 1.0);
}
