// Material shader variables are not defined in SRP or URP shader library.
// This means _BaseColor, _BaseMap, _BaseMap_ST, and all variables in the Properties section of a shader
// must be defined by the shader itself. If you define all those properties in CBUFFER named
// UnityPerMaterial, SRP can cache the material properties between frames and reduce significantly the cost
// of each drawcall.
// In this case, although URP's LitInput.hlsl contains the CBUFFER for the material
// properties defined above. As one can see this is not part of the ShaderLibrary, it specific to the
// URP Lit shader.
// So we are not going to use LitInput.hlsl, we will implement everything by ourself.
//#include "Packages/com.unity.render-pipelines.universal/Shaders/LitInput.hlsl"

// we will include some utility .glsl files to help us
#include "NiloOutlineUtil.glsl"
#include "NiloZOffset.glsl"
#include "NiloInvLerpRemap.glsl"


// note:
// subfix OS means object spaces    (e.g. positionOS = position object space)
// subfix WS means world space      (e.g. positionWS = position world space)
// subfix VS means view space       (e.g. positionVS = position view space)
// subfix CS means clip space       (e.g. positionCS = position clip space)

// all pass will share this Attributes struct (define data needed from Unity app to our vertex shader)
struct Attributes {
    vec3 positionOS;
    vec3 normalOS;
    vec4 tangentOS;
    vec2 uv;
};

// all pass will share this Varyings struct (define data needed from our vertex shader to our fragment shader)
struct Varyings {
    vec2 uv;
    vec4 positionWSAndFogFactor;
    vec3 normalWS;
    vec4 positionCS;
};

///////////////////////////////////////////////////////////////////////////////////////
// CBUFFER and Uniforms
// (you should put all uniforms of all passes inside this single UnityPerMaterial CBUFFER! else SRP batching is not possible!)
///////////////////////////////////////////////////////////////////////////////////////

// Variáveis Uniformes
uniform sampler2D _OutlineZOffsetMaskTex;

// camera
uniform float u_fov;
uniform vec3 _CameraPositionWS;

// fog
uniform float fogStart;
uniform float fogEnd;

// high level settings
uniform float _IsFace;

// base color
uniform vec4  _BaseMap_ST;
uniform vec3  _BaseColor;

// alpha
uniform float _Cutoff;

// emission
uniform float _UseEmission;
uniform vec3  _EmissionColor;
uniform float _EmissionMulByBaseColor;
uniform vec3  _EmissionMapChannelMask;

// occlusion
uniform float _UseOcclusion;
uniform float _OcclusionStrength;
uniform vec4  _OcclusionMapChannelMask;
uniform float _OcclusionRemapStart;
uniform float _OcclusionRemapEnd;

// lighting
uniform vec3  _LightDirection;
uniform vec3  _IndirectLightMinColor;
uniform float _CelShadeMidPoint;
uniform float _CelShadeSoftness;

// shadow mapping
uniform float _ReceiveShadowMappingAmount;
uniform float _ReceiveShadowMappingPosOffset;
uniform vec3  _ShadowMapColor;
uniform float shadowBias;

// outline
uniform float _OutlineWidth;
uniform vec3  _OutlineColor;
uniform float _OutlineZOffset;
uniform float _OutlineZOffsetMaskRemapStart;
uniform float _OutlineZOffsetMaskRemapEnd;

//a special uniform for applyShadowBiasFixToHClipPos() only, it is not a per material uniform
struct ToonSurfaceData {
    vec3   albedo;
    float  alpha;
    vec3   emission;
    float  occlusion;
};

struct ToonLightingData {
    vec3  normalWS;
    vec3  positionWS;
    vec3  viewDirectionWS;
    vec4  shadowCoord;
};

struct Light {
    vec3 direction;
    vec3 color;
    float distanceAttenuation;
    float shadowAttenuation;
};

struct VertexPositionInputs {
    vec4 positionOS; // Posição no espaço do objeto
    vec4 positionWS; // Posição no espaço mundial
    vec4 positionVS; // Posição no espaço da visão (espaço da câmera)
    vec4 positionCS; // Posição no espaço clip
};

struct VertexNormalInputs {
    vec3 normalOS;   // Normal no espaço do objeto
    vec3 normalWS;   // Normal no espaço mundial
    vec4 tangentOS;  // Tangente no espaço do objeto
};

///////////////////////////////////////////////////////////////////////////////////////
// vertex shared functions
///////////////////////////////////////////////////////////////////////////////////////
float TransformPositionWSToOutlinePositionWS(float positionWS, float positionVS_Z, float normalWS)
{
    float outlineExpandAmount = _OutlineWidth * GetOutlineCameraFovAndDistanceFixMultiplier(positionVS_Z);

    // Se você estiver usando estereoscopia, você pode manter essa parte
    // Caso contrário, você pode removê-la
    #ifdef UNITY_STEREO_INSTANCING_ENABLED || UNITY_STEREO_MULTIVIEW_ENABLED || UNITY_STEREO_DOUBLE_WIDE_ENABLED
    outlineExpandAmount *= 0.5;
    #endif

    return positionWS + normalWS * outlineExpandAmount;
}

VertexPositionInputs GetVertexPositionInputs(vec4 positionOS) {
    VertexPositionInputs result;
    result.positionOS = positionOS;

    // Transformação da posição para o espaço mundial
    result.positionWS = modelMatrix * positionOS;

    // Transformação da posição para o espaço da visão (espaço da câmera)
    result.positionVS = viewMatrix * result.positionWS;

    // Transformação da posição para o espaço clip
    result.positionCS = projectionMatrix * result.positionVS;

    return result;
}

VertexNormalInputs GetVertexNormalInputs(vec3 normalOS, vec4 tangentOS) {
    VertexNormalInputs result;
    result.normalOS = normalOS;
    result.tangentOS = tangentOS;

    // Transformação da normal para o espaço mundial
    result.normalWS = normalize(mat3(modelMatrix) * normalOS);

    return result;
}

void UNITY_SETUP_INSTANCE_ID(Attributes input) {
    // Configura o ID da instância
    int instanceID = input.instanceID;
    // Faça algo com o instanceID, como armazená-lo em um varying para o fragment shader
}

void UNITY_TRANSFER_INSTANCE_ID(Attributes input, Varyings output) {
    // Transfere o ID da instância para o fragment shader
    output.instanceID = input.instanceID;
}

void UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(Varyings output) {
    // Inicializa variáveis específicas para renderização estéreo
    // Isso pode incluir coisas como ajustar a posição do vértice com base no olho esquerdo/direito
    // ou outras variáveis específicas para VR/AR
    return output;
}

vec2 TRANSFORM_TEX(vec2 uv, mat3 baseMapMatrix) {
    // Transforma as coordenadas de textura usando a matriz baseMapMatrix
    vec3 transformedUV = baseMapMatrix * vec3(uv, 1.0);
    return transformedUV.xy;
}

float ComputeFogFactor(float z) {
    // Calcula a distância linear da neblina
    float fogDistance = z;

    // Calcula o fator de neblina
    float fogFactor = (fogEnd - fogDistance) / (fogEnd - fogStart);
    fogFactor = clamp(fogFactor, 0.0, 1.0);  // Garante que o fator esteja no intervalo [0, 1]

    return fogFactor;
}

vec4 TransformWorldToHClip(vec4 positionWS) {
    // Transforma a posição para o espaço da câmera (espaço da visão)
    vec4 positionVS = viewMatrix * positionWS;

    // Transforma a posição para o espaço clip
    vec4 positionCS = projectionMatrix * positionVS;

    return positionCS;
}


vec3 ApplyShadowBias(vec3 positionWS, vec3 normalWS, vec3 lightDirection) {
    // Calcula o viés de sombra
    vec3 bias = normalWS * shadowBias;

    // Aplica o viés de sombra à posição no espaço mundial
    vec3 biasedPositionWS = positionWS + bias;

    return biasedPositionWS;
}

// if "ToonShaderIsOutline" is not defined    = do regular MVP transform
// if "ToonShaderIsOutline" is defined        = do regular MVP transform + push vertex out a bit according to normal direction
Varyings VertexShaderWork(Attributes input)
{
    Varyings output;

    // Cálculos iniciais
    UNITY_SETUP_INSTANCE_ID(input);
    UNITY_TRANSFER_INSTANCE_ID(input, output);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);
    VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS);
    VertexNormalInputs vertexNormalInput = GetVertexNormalInputs(input.normalOS, input.tangentOS);
    float3 positionWS = vertexInput.positionWS;

#ifdef ToonShaderIsOutline
    // Cálculo do deslocamento Z do contorno com base na textura e remapeamento
    float outlineZOffsetMask = tex2Dlod(_OutlineZOffsetMaskTex, float4(input.uv, 0, 0)).r;
    outlineZOffsetMask = 1 - outlineZOffsetMask;
    outlineZOffsetMask = invLerpClamp(_OutlineZOffsetMaskRemapStart, _OutlineZOffsetMaskRemapEnd, outlineZOffsetMask);
    output.positionCS = NiloGetNewClipPosWithZOffset(output.positionCS, _OutlineZOffset * outlineZOffsetMask + 0.03 * _IsFace);
#endif

#ifdef ToonShaderApplyShadowBiasFix
    // Correção de viés de sombra
    vec4 positionCS = TransformWorldToHClip(ApplyShadowBias(positionWS, output.normalWS, _LightDirection));
    #if UNITY_REVERSED_Z
    positionCS.z = min(positionCS.z, positionCS.w * UNITY_NEAR_CLIP_VALUE);
    #else
    positionCS.z = max(positionCS.z, positionCS.w * UNITY_NEAR_CLIP_VALUE);
    #endif
    output.positionCS = positionCS;
#endif

    // Outros cálculos que estavam na função original
    float fogFactor = ComputeFogFactor(vertexInput.positionCS.z);
    output.uv = TRANSFORM_TEX(input.uv, _BaseMap);
    output.positionWSAndFogFactor = float4(positionWS, fogFactor);
    output.normalWS = vertexNormalInput.normalWS;
    output.positionCS = TransformWorldToHClip(positionWS);

    return output;
}

vec4 GetFinalBaseColor(Varyings input) {
    // Amostra a textura base usando as coordenadas UV
    vec4 baseMapColor = texture(_BaseMap, input.uv);
    // Multiplica pela cor base
    return baseMapColor * _BaseColor;
}

vec3 GetFinalEmissionColor(Varyings input) {
    // Inicializa a cor de emissão como zero
    vec3 result = vec3(0.0);

    // Verifica se a emissão está ativada
    if(_UseEmission == 1) {
        // Amostra a textura de emissão usando as coordenadas UV
        vec4 emissionMapColor = texture(_EmissionMap, input.uv);
        // Aplica a máscara do canal e a cor de emissão
        result = emissionMapColor.rgb * _EmissionMapChannelMask * _EmissionColor.rgb;
    }

    return result;
}

float GetFinalOcclusion(Varyings input) {
    float result = 1.0;

    if(_UseOcclusion == 1) {
        vec4 texValue = texture(_OcclusionMap, input.uv);
        float occlusionValue = dot(texValue, _OcclusionMapChannelMask);
        occlusionValue = mix(1.0, occlusionValue, _OcclusionStrength);
        // Implementação de invLerpClamp pode variar
        occlusionValue = invLerpClamp(_OcclusionRemapStart, _OcclusionRemapEnd, occlusionValue);
        result = occlusionValue;
    }

    return result;
}

void DoClipTestToTargetAlphaValue(float alpha) {
    #ifdef _UseAlphaClipping
        if(alpha < _Cutoff) discard;
    #endif
}

ToonSurfaceData InitializeSurfaceData(Varyings input) {
    ToonSurfaceData output;
    vec4 baseColorFinal = GetFinalBaseColor(input);
    output.albedo = baseColorFinal.rgb;
    output.alpha = baseColorFinal.a;
    DoClipTestToTargetAlphaValue(output.alpha);
    output.emission = GetFinalEmissionColor(input);
    output.occlusion = GetFinalOcclusion(input);
    return output;
}

ToonLightingData InitializeLightingData(Varyings input) {
    ToonLightingData lightingData;
    lightingData.positionWS = input.positionWSAndFogFactor.xyz;
    lightingData.viewDirectionWS = normalize(GetCameraPositionWS() - lightingData.positionWS);
    lightingData.normalWS = normalize(input.normalWS);
    return lightingData;
}

vec3 ShadeAllLights(ToonSurfaceData surfaceData, ToonLightingData lightingData) {
    vec3 indirectResult = ShadeGI(surfaceData, lightingData);
    Light mainLight = GetMainLight();
    vec3 shadowTestPosWS = lightingData.positionWS + mainLight.direction * (_ReceiveShadowMappingPosOffset + _IsFace);

    #ifdef _MAIN_LIGHT_SHADOWS
        vec4 shadowCoord = TransformWorldToShadowCoord(shadowTestPosWS);
        mainLight.shadowAttenuation = MainLightRealtimeShadow(shadowCoord);
    #endif

    vec3 mainLightResult = ShadeSingleLight(surfaceData, lightingData, mainLight, false);
    vec3 additionalLightSumResult = vec3(0.0);

    #ifdef _ADDITIONAL_LIGHTS
        int additionalLightsCount = GetAdditionalLightsCount();
        for (int i = 0; i < additionalLightsCount; ++i) {
            int perObjectLightIndex = GetPerObjectLightIndex(i);
            Light light = GetAdditionalPerObjectLight(perObjectLightIndex, lightingData.positionWS);
            light.shadowAttenuation = AdditionalLightRealtimeShadow(perObjectLightIndex, shadowTestPosWS);
            additionalLightSumResult += ShadeSingleLight(surfaceData, lightingData, light, true);
        }
    #endif

    vec3 emissionResult = ShadeEmission(surfaceData, lightingData);
    return CompositeAllLightResults(indirectResult, mainLightResult, additionalLightSumResult, emissionResult, surfaceData, lightingData);
}
