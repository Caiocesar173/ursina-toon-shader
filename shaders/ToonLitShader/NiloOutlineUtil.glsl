#ifndef NILOOUTLINEUTIL_H
#define NILOOUTLINEUTIL_H

uniform float panda3D_m11;
uniform float panda3D_ortho_w;

float GetCameraFOV() {
    float t = panda3D_m11;
    float Rad2Deg = 180.0 / 3.1415;
    return atan(1.0 / t) * 2.0 * Rad2Deg;
}

// Função para aplicar um efeito de desvanecimento à distância do contorno.
// A implementação precisa ser definida com base no seu uso desejado.
float ApplyOutlineDistanceFadeOut(float inputMulFix) {
    // Implemente a lógica aqui
    return inputMulFix;
}

float GetOutlineCameraFovAndDistanceFixMultiplier(float positionVS_Z) {
    float cameraMulFix;
    if (panda3D_ortho_w == 0) {
        cameraMulFix = abs(positionVS_Z);
        cameraMulFix = ApplyOutlineDistanceFadeOut(cameraMulFix);
        cameraMulFix *= GetCameraFOV();
    } else {
        float orthoSize = abs(1.0); // Placeholder
        orthoSize = ApplyOutlineDistanceFadeOut(orthoSize);
        cameraMulFix = orthoSize * 50.0;
    }
    return cameraMulFix * 0.00005;
}

#endif
