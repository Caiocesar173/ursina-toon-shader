// SimpleURPToonLitOutlineExample.glsl

#include "NiloOutlineUtil.glsl"
#include "NiloZOffset.glsl"
#include "NiloInvLerpRemap.glsl"


// Estruturas e variáveis uniformes compartilhadas
struct Attributes {
    vec3 positionOS;
    vec3 normalOS;
    vec4 tangentOS;
    vec2 uv;
    // ... outros atributos, como instânciaID, etc.
};

struct Varyings {
    vec2 uv;
    vec4 positionWSAndFogFactor;
    vec3 normalWS;
    vec4 positionCS;
    // ... outros atributos, como instânciaID, etc.
};

uniform struct {
    // ... todas as variáveis uniformes, como _BaseColor, _Cutoff, etc.
} UnityPerMaterial;

// Funções utilitárias compartilhadas, como TransformPositionWSToOutlinePositionWS
vec3 TransformPositionWSToOutlinePositionWS(vec3 positionWS, float positionVS_Z, vec3 normalWS) {
    // ... implementação
}
