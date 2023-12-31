// For more information, visit -> https://github.com/ColinLeung-NiloCat/UnityURPToonLitShaderExample

// This file is intented for you to edit and experiment with different lighting equation.
// Add or edit whatever code you want here

// Variáveis uniformes (substitutos para as variáveis do Unity)
uniform vec3 _IndirectLightMinColor;
uniform float _CelShadeMidPoint;
uniform float _CelShadeSoftness;
uniform float _ReceiveShadowMappingAmount;
uniform vec3 _ShadowMapColor;
uniform float _EmissionMulByBaseColor;
uniform bool _IsFace;

vec3 SampleSH(vec3 normalWS) {
    // Inicialize a iluminação indireta como zero
    vec3 indirectLighting = vec3(0.0, 0.0, 0.0);

    // Calcula os polinômios esféricos para a direção dada
    float Y0 = 0.282095f;
    float Y1 = 0.488603f * normalWS.y;
    float Y2 = 0.488603f * normalWS.z;
    float Y3 = 0.488603f * normalWS.x;
    float Y4 = 1.092548f * normalWS.x * normalWS.y;
    float Y5 = 1.092548f * normalWS.y * normalWS.z;
    float Y6 = 0.315392f * (3.0f * normalWS.z * normalWS.z - 1.0f);
    float Y7 = 1.092548f * normalWS.x * normalWS.z;
    float Y8 = 0.546274f * (normalWS.x * normalWS.x - normalWS.y * normalWS.y);

    // Calcula a iluminação indireta usando os coeficientes SH e os polinômios esféricos
    indirectLighting += SHCoefficients[0].xyz * Y0;
    indirectLighting += SHCoefficients[1].xyz * Y1;
    indirectLighting += SHCoefficients[2].xyz * Y2;
    indirectLighting += SHCoefficients[3].xyz * Y3;
    indirectLighting += SHCoefficients[4].xyz * Y4;
    indirectLighting += SHCoefficients[5].xyz * Y5;
    indirectLighting += SHCoefficients[6].xyz * Y6;
    indirectLighting += SHCoefficients[7].xyz * Y7;
    indirectLighting += SHCoefficients[8].xyz * Y8;

    // Certifique-se de que a iluminação indireta não seja negativa
    return max(indirectLighting, vec3(0.0, 0.0, 0.0));
}

// Funções de sombreamento
vec3 ShadeGI(ToonSurfaceData surfaceData, ToonLightingData lightingData) {
    // hide 3D feeling by ignoring all detail SH (leaving only the constant SH term)
    // we just want some average envi indirect color only
    vec3 averageSH = SampleSH(0);

    // can prevent result becomes completely black if lightprobe was not baked
    averageSH = max(_IndirectLightMinColor, averageSH);

    // occlusion (maximum 50% darken for indirect to prevent result becomes completely black)
    float indirectOcclusion = mix(1.0, surfaceData.occlusion, 0.5);
    return averageSH * indirectOcclusion;
}

// Most important part: lighting equation, edit it according to your needs, write whatever you want here, be creative!
// This function will be used by all direct lights (directional/point/spot)
vec3 ShadeSingleLight(ToonSurfaceData surfaceData, ToonLightingData lightingData, Light light, bool isAdditionalLight) {
    vec3 N = lightingData.normalWS;
    vec3 L = light.direction;

    float NoL = dot(N, L);

    float lightAttenuation = 1.0;

    // light's distance & angle fade for point light & spot light (see GetAdditionalPerObjectLight(...) in Lighting.hlsl)
    // Lighting.hlsl -> https://github.com/Unity-Technologies/Graphics/blob/master/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl
    float distanceAttenuation = min(4.0, light.distanceAttenuation); //clamp to prevent light over bright if point/spot light too close to vertex

    // N dot L
    // simplest 1 line cel shade, you can always replace this line by your own method!
    float litOrShadowArea = smoothstep(_CelShadeMidPoint - _CelShadeSoftness, _CelShadeMidPoint + _CelShadeSoftness, NoL);

    // occlusion
    litOrShadowArea *= surfaceData.occlusion;

    // face ignore celshade since it is usually very ugly using NoL method
    litOrShadowArea = _IsFace ? mix(0.5, 1.0, litOrShadowArea) : litOrShadowArea;

    // light's shadow map
    litOrShadowArea *= mix(1.0, light.shadowAttenuation, _ReceiveShadowMappingAmount);
    vec3 litOrShadowColor = mix(_ShadowMapColor, vec3(1.0), litOrShadowArea);
    vec3 lightAttenuationRGB = litOrShadowColor * distanceAttenuation;

    // saturate() light.color to prevent over bright
    // additional light reduce intensity since it is additive
    return clamp(light.color, 0.0, 1.0) * lightAttenuationRGB * (isAdditionalLight ? 0.25 : 1.0);
}

vec3 ShadeEmission(ToonSurfaceData surfaceData, ToonLightingData lightingData) {
    vec3 emissionResult = mix(surfaceData.emission, surfaceData.emission * surfaceData.albedo, _EmissionMulByBaseColor);
    return emissionResult;
}

vec3 CompositeAllLightResults(vec3 indirectResult, vec3 mainLightResult, vec3 additionalLightSumResult, vec3 emissionResult, ToonSurfaceData surfaceData, ToonLightingData lightingData) {
    // [remember you can write anything here, this is just a simple tutorial method]
    // here we prevent light over bright,
    // while still want to preserve light color's hue
    vec3 rawLightSum = max(indirectResult, mainLightResult + additionalLightSumResult);
    return surfaceData.albedo * rawLightSum + emissionResult;
}
