//
//  GrainGradient.metal
//  Wallpaper
//
//  Created by Nate de Jager on 2024-01-22.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>

using namespace metal;

float h00(float x) { return 2.0 * x * x * x - 3.0 * x * x + 1.0; }
float h10(float x) { return x * x * x - 2.0 * x * x + x; }
float h01(float x) { return 3.0 * x * x - 2.0 * x * x * x; }
float h11(float x) { return x * x * x - x * x; }

float hermite(float p0, float p1, float m0, float m1, float x) {
    return p0 * h00(x) + m0 * h10(x) + p1 * h01(x) + m1 * h11(x);
}

int getIndex(int x, int y, int2 gridSize, int lastIndex) {
    return clamp(y * gridSize.x + x, 0, lastIndex);
}

int4 getIndices(float2 gridCoords, int2 gridSize, int lastIndex) {
    int2 idStart = int2(gridCoords);
    int2 idEnd = int2(ceil(gridCoords));

    int4 id = int4(getIndex(idStart.x, idStart.y, gridSize, lastIndex),
                   getIndex(idEnd.x,   idStart.y, gridSize, lastIndex),
                   getIndex(idStart.x, idEnd.y, gridSize, lastIndex),
                   getIndex(idEnd.x,   idEnd.y, gridSize, lastIndex));
    return id;
}

half4 gridInterpolation(float2 coords, device const half4 *colors, float4 gridRange, int2 gridSize, int lastIndex, float time) {

    float a = sin(time * 1.0) * 0.5 + 0.5;
    float b = sin(time * 1.5) * 0.5 + 0.5;
    float c = sin(time * 2.0) * 0.5 + 0.5;
    float d = sin(time * 2.5) * 0.5 + 0.5;

    float y0 = mix(a, b, coords.x);
    float y1 = mix(c, d, coords.x);
    float x0 = mix(a, c, coords.y);
    float x1 = mix(b, d, coords.y);

    coords.x = hermite(0.0, 1.0, 2.0 * x0, 2.0 * x1, coords.x);
    coords.y = hermite(0.0, 1.0, 2.0 * y0, 2.0 * y1, coords.y);

    float2 gridCoords = coords * gridRange.zw;
    int4 id = getIndices(gridCoords, gridSize, lastIndex);

    float2 factors = smoothstep(float2(0.0), float2(1.0), fract(gridCoords));

    half4 result[2];
    result[0] = mix(colors[id.x], colors[id.y], factors.x);
    result[1] = mix(colors[id.z], colors[id.w], factors.x);

    return half4(mix(result[0], result[1], factors.y));
}

float easeInOut(float t) {
    return t < 0.5 ? 4.0 * t * t * t : 1.0 - pow(-2.0 * t + 2.0, 3.0) / 2.0;
}

float noise(float2 st) {
    float2 i = floor(st);
    float2 f = fract(st);
    float a = fract(sin(dot(i, float2(12.9898, 78.233))) * 43758.5453);
    float b = fract(sin(dot(i + float2(1.0, 0.0), float2(12.9898, 78.233))) * 43758.5453);
    float c = fract(sin(dot(i + float2(0.0, 1.0), float2(12.9898, 78.233))) * 43758.5453);
    float d = fract(sin(dot(i + float2(1.0, 1.0), float2(12.9898, 78.233))) * 43758.5453);
    f = smoothstep(0.0, 1.0, f);
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

float smoothNoise(float2 st) {
    float2 i = floor(st);
    float2 f = fract(st);
    float2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(noise(i + float2(0.0, 0.0)),
                   noise(i + float2(1.0, 0.0)), u.x),
               mix(noise(i + float2(0.0, 1.0)),
                   noise(i + float2(1.0, 1.0)), u.x), u.y);
}

[[ stitchable ]]
half4 circleMotionWithBackground(float2 position, float4 bounds, float size, float time, float secondTime) {
    float2 center = bounds.zw / 2.0;
    float2 pos = position - center;
    
    float maxRadius = min(bounds.z, bounds.w) / 2.0;
    float minRadius = maxRadius / 4.0;
    
    float cycleTime = 15.0;
    float t = fmod(secondTime, cycleTime);
    float radius;
    
    if (t < 5.0) {
        radius = maxRadius;
    } else if (t < 10.0) {
        float progress = smoothstep(0.0, 1.0, (t - 5.0) / 5.0);
        radius = mix(maxRadius, minRadius, progress);
    } else if (t < 13.0) {
        radius = minRadius;
    } else {
        float progress = smoothstep(0.0, 1.0, (t - 13.0) / 2.0);
        radius = mix(minRadius, maxRadius, progress);
    }
    
    float angle = atan2(pos.y, pos.x);
    float slowTime = time / 5.0; // Slower time for smoother movement
    
    // Use smoothNoise for a more continuous, less "broken" effect
    float noiseValue = smoothNoise(float2(angle * 3.0 + slowTime, slowTime * 0.5));
    float edgeNoise = noiseValue * 0.15 + 0.85; // Reduced noise influence
    
    float edgeRadius = radius * edgeNoise;
    
    float distFromCenter = length(pos);
    
    half4 greenColor = half4(149.0/255.0, 178.0/255.0, 150.0/255.0, 1.0);
    half4 beigeColor = half4(240.0/255.0, 224.0/255.0, 188.0/255.0, 1.0);
    
    float smoothWidth = maxRadius / 3.0;
    half4 color = mix(greenColor, beigeColor, smoothstep(edgeRadius - smoothWidth, edgeRadius + smoothWidth, distFromCenter));
    
    // Softer edge effect
    float edgeWidth = smoothWidth * 8.0;
    float edgeGap = smoothWidth * 3.0;
    float edgeEffect = smoothstep(edgeRadius + edgeGap, edgeRadius + edgeGap + edgeWidth * 0.5, distFromCenter) *
                       (1.0 - smoothstep(edgeRadius + edgeGap + edgeWidth * 0.5, edgeRadius + edgeGap + edgeWidth, distFromCenter));
    color = mix(color, greenColor, edgeEffect * 0.4);
    
    // Grain effect
    float2 coords = position / bounds.zw;
    float strength = 0.02;
    float x = (coords.x + 4.0) * (coords.y + 4.0) * 10.0;
    float grain = fract((fract(x * 13.0) + 1.0) * (fract(x * 123.0) + 1.0)) * 0.01 - 0.005;
    
    color.rgb += half3(grain, grain, grain) * strength;
    
    return color;
}
