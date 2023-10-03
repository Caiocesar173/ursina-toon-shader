#ifndef NILOOUTLINEUTIL_H
#define NILOOUTLINEUTIL_H

uniform float panda3D_m11;
uniform float panda3D_ortho_w;

float GetCameraFOV() {
    float t = panda3D_m11;
    float Rad2Deg = 180.0 / 3.1415;
    return atan(1.0 / t) * 2.0 * Rad2Deg;
}

float ApplyOutlineDistanceFadeOut(float inputMulFix) {
    return clamp(inputMulFix, 0.0, 1.0);
}

float GetOutlineCameraFovAndDistanceFixMultiplier(float positionVS_Z) {
    float cameraMulFix;
    if (panda3D_ortho_w == 0.0) {
        cameraMulFix = abs(positionVS_Z);
        cameraMulFix = ApplyOutlineDistanceFadeOut(cameraMulFix);
        cameraMulFix *= GetCameraFOV();
    } else {
        float orthoSize = abs(panda3D_ortho_w);
        orthoSize = ApplyOutlineDistanceFadeOut(orthoSize);
        cameraMulFix = orthoSize * 50.0;
    }
    return cameraMulFix * 0.00005;
}
#endif
