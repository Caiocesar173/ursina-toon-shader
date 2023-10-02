#include "NiloOutlineUtil.glsl"
#include "NiloZOffset.glsl"
#include "NiloInvLerpRemap.glsl"

// Estruturas
struct Attributes {
    vec3 positionOS;
    vec3 normalOS;
    vec4 tangentOS;
    vec2 uv;
};

struct Varyings {
    vec2 uv;
    vec4 positionWSAndFogFactor;
    vec3 normalWS;
    vec4 positionCS;
};

// Variáveis Uniformes
uniform sampler2D _BaseMap;
uniform sampler2D _EmissionMap;
uniform sampler2D _OcclusionMap;
uniform sampler2D _OutlineZOffsetMaskTex;
uniform vec3 _CameraPositionWS;

layout (std140) uniform UnityPerMaterial {
    float _IsFace;
    vec4  _BaseMap_ST;
    vec3  _BaseColor;
    float _Cutoff;
    float _UseEmission;
    vec3  _EmissionColor;
    float _EmissionMulByBaseColor;
    vec3  _EmissionMapChannelMask;
    float _UseOcclusion;
    float _OcclusionStrength;
    vec4  _OcclusionMapChannelMask;
    float _OcclusionRemapStart;
    float _OcclusionRemapEnd;
    vec3  _IndirectLightMinColor;
    float _CelShadeMidPoint;
    float _CelShadeSoftness;
    float _ReceiveShadowMappingAmount;
    float _ReceiveShadowMappingPosOffset;
    vec3  _ShadowMapColor;
    float _OutlineWidth;
    vec3  _OutlineColor;
    float _OutlineZOffset;
    float _OutlineZOffsetMaskRemapStart;
    float _OutlineZOffsetMaskRemapEnd;
};

struct Light {
    vec3 direction;
    vec3 color;
    float distanceAttenuation;
    float shadowAttenuation;
};

uniform Light mainLight;
uniform Light additionalLights[4]; // Suposição de que existem 4 luzes adicionais

// Funções de Transformação de Vértice
vec3 GetVertexPositionInputs(vec3 positionOS) {
    // Implementação simplificada
    return positionOS;
}

vec3 GetVertexNormalInputs(vec3 normalOS, vec4 tangentOS) {
    // Implementação simplificada
    return normalOS;
}

// Funções de Névoa (Fog)
float ComputeFogFactor(float z) {
    float fogFactor = 1.0;
    return fogFactor;
}

vec3 MixFog(vec3 color, float fogFactor) {
    return color;
}

// Funções de Iluminação
vec3 ShadeGI(ToonSurfaceData surfaceData, ToonLightingData lightingData) {
    return vec3(1.0);
}

vec4 GetFinalBaseColor(Varyings input) {
    return texture(_BaseMap, input.uv) * vec4(_BaseColor, 1.0);
}

vec3 GetFinalEmissionColor(Varyings input) {
    vec3 result = vec3(0.0);
    if (_UseEmission > 0.5) {
        result = texture(_EmissionMap, input.uv).rgb * _EmissionMapChannelMask * _EmissionColor;
    }
    return result;
}

float GetFinalOcculsion(Varyings input) {
    float result = 1.0;
    if (_UseOcclusion > 0.5) {
        vec4 texValue = texture(_OcclusionMap, input.uv);
        float occlusionValue = dot(texValue, _OcclusionMapChannelMask.xyz);
        occlusionValue = mix(1.0, occlusionValue, _OcclusionStrength);
        result = occlusionValue;
    }
    return result;
}

Varyings VertexShaderWork(Attributes input) {
    Varyings output;
    // Código de transformação de vértice
    return output;
}

vec4 ShadeFinalColor(Varyings input) {
    vec3 color = vec3(1.0);
    return vec4(color, 1.0);
}
