// For more information, visit -> https://github.com/ColinLeung-NiloCat/UnityURPToonLitShaderExample

#ifndef NILOOUTLINEUTIL_H
#define NILOOUTLINEUTIL_H

uniform float panda3D_m11;
uniform float panda3D_ortho_w;

// If your project has a faster way to get camera fov in shader, you can replace this slow function to your method.
// For example, you write cmd.SetGlobalFloat("_CurrentCameraFOV",cameraFOV) using a new RendererFeature in C#.
// For this tutorial shader, we will keep things simple and use this slower but convenient method to get camera fov
float GetCameraFOV() {
    //https://answers.unity.com/questions/770838/how-can-i-extract-the-fov-information-from-the-pro.html
    float t = panda3D_m11;
    float Rad2Deg = 180.0 / 3.1415;
    return atan(1.0 / t) * 2.0 * Rad2Deg;
}

float ApplyOutlineDistanceFadeOut(float inputMulFix) {
    //make outline "fadeout" if character is too small in camera's view
    return clamp(inputMulFix, 0.0, 1.0);
}

float GetOutlineCameraFovAndDistanceFixMultiplier(float positionVS_Z) {
    float cameraMulFix;
    if (panda3D_ortho_w == 0.0) {
        ////////////////////////////////
        // Perspective camera case
        ////////////////////////////////

        // keep outline similar width on screen accoss all camera distance
        cameraMulFix = abs(positionVS_Z);

        // can replace to a tonemap function if a smooth stop is needed
        cameraMulFix = ApplyOutlineDistanceFadeOut(cameraMulFix);

        // keep outline similar width on screen accoss all camera fov
        cameraMulFix *= GetCameraFOV();
    } else {
        ////////////////////////////////
        // Orthographic camera case
        ////////////////////////////////
        float orthoSize = abs(panda3D_ortho_w);
        orthoSize = ApplyOutlineDistanceFadeOut(orthoSize);
        cameraMulFix = orthoSize * 50.0; // 50 is a magic number to match perspective camera's outline width
    }
    return cameraMulFix * 0.00005; // mul a const to make return result = default normal expand amount WS
}

#endif
