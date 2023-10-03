// https://github.com/ronja-tutorials/ShaderTutorials/blob/master/Assets/047_InverseInterpolationAndRemap/Interpolation.cginc
// edit float to half for optimization, because we usually use this to process color data(half)

#ifndef NILOINVLERPREMAP_H
#define NILOINVLERPREMAP_H

// just like smoothstep(), but linear, not clamped
float invLerp(float from, float to, float value) {
    return (value - from) / (to - from);
}

float invLerpClamp(float from, float to, float value) {
    return clamp(invLerp(from, to, value), 0.0, 1.0);
}

// full control remap, but slower
float remap(float origFrom, float origTo, float targetFrom, float targetTo, float value) {
    float rel = invLerp(origFrom, origTo, value);
    return mix(targetFrom, targetTo, rel);
}

#endif
