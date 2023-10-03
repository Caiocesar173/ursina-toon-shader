// For more information, visit -> https://github.com/ColinLeung-NiloCat/UnityURPToonLitShaderExample

#ifndef NILOZOFFSET_H
#define NILOZOFFSET_H

uniform float panda3D_ortho_w; // Substituto para unity_OrthoParams.w
uniform vec4 panda3D_ProjectionParams; // Substituto para _ProjectionParams
uniform mat4 panda3D_MATRIX_P; // Substituto para UNITY_MATRIX_P

// Push an imaginary vertex towards camera in view space (linear, view space unit),
// then only overwrite original positionCS.z using imaginary vertex's result positionCS.z value
// Will only affect ZTest ZWrite's depth value of vertex shader

// Useful for:
// -Hide ugly outline on face/eye
// -Make eyebrow render on top of hair
// -Solve ZFighting issue without moving geometry
vec4 NiloGetNewClipPosWithZOffset(vec4 originalPositionCS, float viewSpaceZOffsetAmount) {
    if (panda3D_ortho_w == 0.0) {
        ////////////////////////////////
        //Perspective camera case
        ////////////////////////////////
        vec2 ProjM_ZRow_ZW = panda3D_MATRIX_P[2].zw;
        float modifiedPositionVS_Z = -originalPositionCS.w - viewSpaceZOffsetAmount; // push imaginary vertex
        float modifiedPositionCS_Z = modifiedPositionVS_Z * ProjM_ZRow_ZW[0] + ProjM_ZRow_ZW[1];
        originalPositionCS.z = modifiedPositionCS_Z * originalPositionCS.w / (-modifiedPositionVS_Z); // overwrite positionCS.z
        return originalPositionCS;
    } else {
        ////////////////////////////////
        //Orthographic camera case
        ////////////////////////////////
        originalPositionCS.z += -viewSpaceZOffsetAmount / panda3D_ProjectionParams.z;  // push imaginary vertex and overwrite positionCS.z
        return originalPositionCS;
    }
}

#endif
