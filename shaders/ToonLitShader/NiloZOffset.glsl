#ifndef NILOZOFFSET_H
#define NILOZOFFSET_H

uniform float panda3D_ortho_w;

vec4 NiloGetNewClipPosWithZOffset(vec4 originalPositionCS, float viewSpaceZOffsetAmount) {
    if (panda3D_ortho_w == 0) {
        vec2 ProjM_ZRow_ZW = vec2(1.0, 1.0); // Placeholder
        float modifiedPositionVS_Z = -originalPositionCS.w + -viewSpaceZOffsetAmount;
        float modifiedPositionCS_Z = modifiedPositionVS_Z * ProjM_ZRow_ZW.x + ProjM_ZRow_ZW.y;
        originalPositionCS.z = modifiedPositionCS_Z * originalPositionCS.w / (-modifiedPositionVS_Z);
        return originalPositionCS;
    } else {
        originalPositionCS.z += -viewSpaceZOffsetAmount / 1.0; // Placeholder
        return originalPositionCS;
    }
}

#endif
