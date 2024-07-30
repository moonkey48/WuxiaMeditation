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

[[ stitchable ]]
half4 circleMotion(float2 position, float4 bounds, float size, float time) {
    float2 center = bounds.zw / 2.0;
    float2 pos = position - center;
    
    float maxRadius = min(bounds.z, bounds.w) / 2.0;
    float minRadius = maxRadius / 4.0;
    
    // 시간에 따른 반지름 계산
    float cycleTime = 15.0; // 전체 사이클 시간 (5 + 3 + 5 + 2 = 15초)
    float t = fmod(time, cycleTime);
    float radius;
    
    
    if (t < 5.0) {
        // 5초 동안 커짐
        float progress = easeInOut(t / 5.0);
        radius = mix(minRadius, maxRadius, progress);
    } else if (t < 8.0) {
        // 3초 동안 최대 크기 유지
        radius = maxRadius;
    } else if (t < 13.0) {
        // 5초 동안 작아짐
        float progress = easeInOut((t - 8.0) / 5.0);
        radius = mix(maxRadius, minRadius, progress);
    } else {
        // 2초 동안 최소 크기 유지
        radius = minRadius;
    }
    
    float distFromCenter = length(pos);
    
    half4 greenColor = half4(0.0, 1.0, 0.0, 1.0);
    half4 beigeColor = half4(0.96, 0.96, 0.86, 1.0);
    
    float smoothWidth = 2.0;
    half4 color = mix(greenColor, beigeColor, smoothstep(radius - smoothWidth, radius + smoothWidth, distFromCenter));
    
    float2 coords = position / bounds.zw;
    float strength = 0.05;
    float x = (coords.x + 4.0) * (coords.y + 4.0) * 10.0;
    float4 grain = float4(fmod((fmod(x, 13.0) + 1.0) * (fmod(x, 123.0) + 1.0), 0.01)-0.005) * strength;
    
    return color + half4(grain);
}
