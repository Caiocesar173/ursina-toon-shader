#ifndef NILOINVLERPREMAP_H
#define NILOINVLERPREMAP_H

// Funções de mapeamento e interpolação
float invLerp(float from, float to, float value) {
    return (value - from) / (to - from);
}

float invLerpClamp(float from, float to, float value) {
    return clamp(invLerp(from, to, value), 0.0, 1.0);
}

float remap(float origFrom, float origTo, float targetFrom, float targetTo, float value) {
    float rel = invLerp(origFrom, origTo, value);
    return mix(targetFrom, targetTo, rel);
}

#endif
