#version 330 core

in vec3 TexCoords;
out vec4 FragColor;

uniform vec3 sunPosition;
uniform vec3 moonPosition;

const float sunRadius = 0.2;
const float moonRadius = 0.2;

// Definição de cores
vec3 sunriseColor = vec3(0.8, 0.6, 0.5);
vec3 dayColor = vec3(0.5, 0.8, 0.9);
vec3 sunsetColor = vec3(0.9, 0.5, 0.4);
vec3 nightColor = vec3(0.2, 0.3, 0.5);

vec3 sunCoreColor = vec3(0.95, 0.72, 0.04);
vec3 sunHaloColor = vec3(1.0, 0.8, 0.5);

vec3 moonCoreColor = vec3(0.8, 0.8, 1.0);
vec3 moonHaloColor = vec3(0.9, 0.9, 1.0);

void main()
{
    float luminance = sunPosition.y;
    vec3 skyColor;
    vec3 finalColor;

    float distanceToSun = length(TexCoords - sunPosition);
    float distanceToMoon = length(TexCoords - moonPosition);

    // Lógica de mistura com base na luminância
    if(luminance > 0.5)
        skyColor = mix(sunsetColor, dayColor, (luminance - 0.5) * 2.0);
    else if(luminance > 0)
        skyColor = mix(sunriseColor, dayColor, luminance * 2.0);
    else if(luminance > -0.5)
        skyColor = mix(nightColor, sunriseColor, (luminance + 0.5) * 2.0);
    else
        skyColor = mix(nightColor, sunsetColor, (luminance + 1.0));


    // É dia, então renderiza o Sol
    if (luminance > 0) {
        if (distanceToSun < sunRadius) {
            finalColor = mix(sunHaloColor, sunCoreColor, (sunRadius - distanceToSun) / sunRadius);
        } else {
            finalColor = skyColor;
        }
    // É noite, então renderiza a Lua
    } else {
        if (distanceToMoon < moonRadius) {
            finalColor = mix(moonHaloColor, moonCoreColor, (moonRadius - distanceToMoon) / moonRadius);
        } else {
            finalColor = skyColor;
        }
    }

    FragColor = vec4(finalColor, 1.0);
}
