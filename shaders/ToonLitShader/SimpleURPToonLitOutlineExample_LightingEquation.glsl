// Estruturas de dados equivalentes
struct ToonSurfaceData {
    vec3 albedo;
    float occlusion;
    vec3 emission;
};

struct ToonLightingData {
    vec3 normalWS;
};

struct Light {
    vec3 direction;
    vec3 color;
    float distanceAttenuation;
    float shadowAttenuation;
};

// Variáveis uniformes (substitutos para as variáveis do Unity)
uniform vec3 _IndirectLightMinColor;
uniform float _CelShadeMidPoint;
uniform float _CelShadeSoftness;
uniform float _ReceiveShadowMappingAmount;
uniform vec3 _ShadowMapColor;
uniform float _EmissionMulByBaseColor;
uniform bool _IsFace;

// Placeholder para a função SampleSH.
// TODO: Implementar a função SampleSH ou substituir pela lógica correta.
vec3 SampleSH(int index) {
    return vec3(1.0, 1.0, 1.0);
}

// Funções de sombreamento
vec3 ShadeGI(ToonSurfaceData surfaceData, ToonLightingData lightingData) {
    vec3 averageSH = SampleSH(0);
    averageSH = max(_IndirectLightMinColor, averageSH);
    float indirectOcclusion = mix(1.0, surfaceData.occlusion, 0.5);
    return averageSH * indirectOcclusion;
}

vec3 ShadeSingleLight(ToonSurfaceData surfaceData, ToonLightingData lightingData, Light light, bool isAdditionalLight) {
    vec3 N = lightingData.normalWS;
    vec3 L = light.direction;
    float NoL = dot(N, L);
    float lightAttenuation = 1.0;
    float distanceAttenuation = min(4.0, light.distanceAttenuation);
    float litOrShadowArea = smoothstep(_CelShadeMidPoint - _CelShadeSoftness, _CelShadeMidPoint + _CelShadeSoftness, NoL);
    litOrShadowArea *= surfaceData.occlusion;
    litOrShadowArea = _IsFace ? mix(0.5, 1.0, litOrShadowArea) : litOrShadowArea;
    litOrShadowArea *= mix(1.0, light.shadowAttenuation, _ReceiveShadowMappingAmount);
    vec3 litOrShadowColor = mix(_ShadowMapColor, vec3(1.0), litOrShadowArea);
    vec3 lightAttenuationRGB = litOrShadowColor * distanceAttenuation;
    return clamp(light.color, 0.0, 1.0) * lightAttenuationRGB * (isAdditionalLight ? 0.25 : 1.0);
}

vec3 ShadeEmission(ToonSurfaceData surfaceData, ToonLightingData lightingData) {
    vec3 emissionResult = mix(surfaceData.emission, surfaceData.emission * surfaceData.albedo, _EmissionMulByBaseColor);
    return emissionResult;
}

vec3 CompositeAllLightResults(vec3 indirectResult, vec3 mainLightResult, vec3 additionalLightSumResult, vec3 emissionResult, ToonSurfaceData surfaceData, ToonLightingData lightingData) {
    vec3 rawLightSum = max(indirectResult, mainLightResult + additionalLightSumResult);
    return surfaceData.albedo * rawLightSum + emissionResult;
}
