uniform float panda3D_ortho_w; // Substituto para unity_OrthoParams.w

vec4 NiloGetNewClipPosWithZOffset(vec4 originalPositionCS, float viewSpaceZOffsetAmount) {
    if (panda3D_ortho_w == 0) { // Usando o valor passado de Panda3D
        vec2 ProjM_ZRow_ZW = vec2(1.0, 1.0); // Placeholder, você pode passar isso como um uniforme também
        float modifiedPositionVS_Z = -originalPositionCS.w + -viewSpaceZOffsetAmount;
        float modifiedPositionCS_Z = modifiedPositionVS_Z * ProjM_ZRow_ZW.x + ProjM_ZRow_ZW.y;
        originalPositionCS.z = modifiedPositionCS_Z * originalPositionCS.w / (-modifiedPositionVS_Z);
        return originalPositionCS;
    } else {
        originalPositionCS.z += -viewSpaceZOffsetAmount / 1.0; // Placeholder para _ProjectionParams.z, você pode passar isso como um uniforme também
        return originalPositionCS;
    }
}
