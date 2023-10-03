#ifndef NILOZOFFSET_H
#define NILOZOFFSET_H

uniform float panda3D_ortho_w; // Substituto para unity_OrthoParams.w
uniform vec4 panda3D_ProjectionParams; // Substituto para _ProjectionParams
uniform mat4 panda3D_MATRIX_P; // Substituto para UNITY_MATRIX_P

vec4 NiloGetNewClipPosWithZOffset(vec4 originalPositionCS, float viewSpaceZOffsetAmount) {
    if (panda3D_ortho_w == 0.0) {
        // Caso de câmera perspectiva
        vec2 ProjM_ZRow_ZW = panda3D_MATRIX_P[2].zw;
        float modifiedPositionVS_Z = -originalPositionCS.w - viewSpaceZOffsetAmount; // empurrar vértice imaginário
        float modifiedPositionCS_Z = modifiedPositionVS_Z * ProjM_ZRow_ZW[0] + ProjM_ZRow_ZW[1];
        originalPositionCS.z = modifiedPositionCS_Z * originalPositionCS.w / (-modifiedPositionVS_Z); // sobrescrever positionCS.z
        return originalPositionCS;
    } else {
        // Caso de câmera ortográfica
        originalPositionCS.z += -viewSpaceZOffsetAmount / panda3D_ProjectionParams.z; // empurrar vértice imaginário e sobrescrever positionCS.z
        return originalPositionCS;
    }
}

#endif
