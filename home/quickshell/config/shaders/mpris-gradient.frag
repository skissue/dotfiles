#version 440

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
} ubuf;

layout(binding = 1) uniform sampler2D source;

const vec3 shadowColor = vec3(0.411765, 0.403922, 0.349020);
const vec3 midtoneColor = vec3(0.505882, 0.486275, 0.415686);
const vec3 highlightColor = vec3(0.603922, 0.588235, 0.505882);

void main() {
    vec4 sampleColor = texture(source, qt_TexCoord0);
    vec3 sourceColor = sampleColor.a > 0.0
        ? sampleColor.rgb / sampleColor.a
        : vec3(0.0);

    float luminance = dot(sourceColor, vec3(0.2126, 0.7152, 0.0722));
    vec3 mappedColor;

    if (luminance < 0.5) {
        float amount = smoothstep(0.0, 0.5, luminance);
        mappedColor = mix(shadowColor, midtoneColor, amount);
    } else {
        float amount = smoothstep(0.5, 1.0, luminance);
        mappedColor = mix(midtoneColor, highlightColor, amount);
    }

    fragColor = vec4(mappedColor * sampleColor.a, sampleColor.a) * ubuf.qt_Opacity;
}
