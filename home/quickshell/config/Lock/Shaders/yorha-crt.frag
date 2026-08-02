#version 440

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float time;
    float glitchAmount;
    vec2 resolution;
    float warpStrength;
    float chromaStrength;
    float overscan;
} ubuf;

layout(binding = 1) uniform sampler2D source;

float hash11(float value) {
    return fract(sin(value * 127.1) * 43758.5453123);
}

float hash21(vec2 value) {
    return fract(sin(dot(value, vec2(127.1, 311.7))) * 43758.5453123);
}

vec2 warp(vec2 uv) {
    vec2 centered = uv - 0.5;
    float aspect = ubuf.resolution.x / max(ubuf.resolution.y, 1.0);

    centered.x *= aspect;
    float radiusSquared = dot(centered, centered);
    centered *= 1.0 - clamp(ubuf.overscan, 0.0, 0.25);
    centered *= 1.0 + ubuf.warpStrength * radiusSquared;
    centered.x /= aspect;

    return centered + 0.5;
}

void main() {
    vec2 outputUv = qt_TexCoord0;
    vec2 edgePosition = (outputUv - 0.5) * 2.0;
    float edgeDistance = length(edgePosition) * 0.70710678;
    float edgeAmount = smoothstep(0.12, 0.92, edgeDistance);

    vec2 uv = warp(outputUv);

    // Glitches advance in discrete frames so they snap instead of drifting.
    float glitchFrame = floor(ubuf.time * 30.0);
    float coarseBand = floor(outputUv.y * 42.0);
    float fineBand = floor(outputUv.y * 135.0);

    float coarseNoise = hash21(vec2(coarseBand, glitchFrame));
    float fineNoise = hash21(vec2(fineBand, glitchFrame + 71.0));
    float coarseMask = smoothstep(0.78, 0.98, coarseNoise);
    float fineMask = smoothstep(0.90, 0.995, fineNoise);

    float coarseDirection = hash21(vec2(coarseBand + 19.0, glitchFrame)) - 0.5;
    float fineDirection = hash21(vec2(fineBand + 47.0, glitchFrame)) - 0.5;

    uv.x += coarseDirection * coarseMask * 0.065 * ubuf.glitchAmount;
    uv.x += fineDirection * fineMask * 0.018 * ubuf.glitchAmount;

    // A faint high-frequency wobble appears only during a glitch pulse.
    float scanWobble = sin(outputUv.y * ubuf.resolution.y * 0.23 + ubuf.time * 95.0);
    uv.x += scanWobble * 0.0012 * ubuf.glitchAmount;

    uv = clamp(uv, vec2(0.001), vec2(0.999));

    // Split red outward and cyan inward. The separation grows toward the edge.
    vec2 pixelDirection = normalize((outputUv - 0.5) * ubuf.resolution + vec2(0.0001));
    float separationPixels = ubuf.chromaStrength * pow(edgeAmount, 1.65);
    separationPixels += 3.5 * coarseMask * ubuf.glitchAmount;
    vec2 channelOffset = pixelDirection * separationPixels / max(ubuf.resolution, vec2(1.0));

    vec4 centerSample = texture(source, uv);
    vec4 redSample = texture(source, clamp(uv + channelOffset, vec2(0.001), vec2(0.999)));
    vec4 blueSample = texture(source, clamp(uv - channelOffset, vec2(0.001), vec2(0.999)));

    vec3 color = vec3(redSample.r, centerSample.g, blueSample.b);

    // Fine scanlines and brief brightness jumps keep the image from feeling flat.
    float scanline = 0.985 + 0.015 * sin(outputUv.y * ubuf.resolution.y * 3.14159265);
    float lineNoise = hash21(vec2(fineBand, glitchFrame + 113.0)) - 0.5;
    float frameFlicker = hash11(glitchFrame + 31.0) - 0.5;
    color *= scanline;
    color *= 1.0 + lineNoise * fineMask * 0.22 * ubuf.glitchAmount;
    color *= 1.0 + frameFlicker * 0.14 * ubuf.glitchAmount;

    // Subtle edge darkening reinforces the curved-display illusion.
    color *= 1.0 - 0.10 * smoothstep(0.45, 1.0, edgeDistance);

    fragColor = vec4(color, centerSample.a) * ubuf.qt_Opacity;
}
