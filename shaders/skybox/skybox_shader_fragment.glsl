#version 330 core

in vec3 TexCoords;
out vec4 FragColor;

uniform vec3 sunPosition;

const float sunRadius = 0.005; // raio do sol no céu

void main()
{
    // Definição de cores
    vec3 sunriseColor = vec3(0.8, 0.6, 0.5);
    vec3 dayColor = vec3(0.5, 0.8, 0.9);
    vec3 sunsetColor = vec3(0.9, 0.5, 0.4);
    vec3 nightColor = vec3(0.2, 0.3, 0.5);
    vec3 sunCoreColor = vec3(0.95, 0.72, 0.04);
    vec3 sunHaloColor = vec3(1.0, 0.8, 0.5);

    float luminance = sunPosition.y;
    vec3 skyColor;

    // Lógica de mistura com base na luminância
    if(luminance > 0.5)
        skyColor = mix(sunsetColor, dayColor, (luminance - 0.5) * 2.0);
    else if(luminance > 0)
        skyColor = mix(sunriseColor, dayColor, luminance * 2.0);
    else if(luminance > -0.5)
        skyColor = mix(nightColor, sunriseColor, (luminance + 0.5) * 2.0);
    else
        skyColor = mix(nightColor, sunsetColor, (luminance + 1.0));

    float distanceToSun = length(TexCoords - sunPosition);

    vec3 finalColor;
    if (distanceToSun < sunRadius) {
        finalColor = mix(sunHaloColor, sunCoreColor, (sunRadius - distanceToSun) / sunRadius);
    } else {
        finalColor = skyColor;
    }

    FragColor = vec4(finalColor, 1.0);
}
