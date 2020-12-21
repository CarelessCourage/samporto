uniform float time;
uniform float scroll;
uniform float inFocus;
varying vec2 vUv;
float PI = 3.141592653589793239;
void main() {
    vUv = (uv - vec2(0.5))*(0.9 - 0.2*inFocus) + vec2(0.5);
    vec3 pos = position;
    
    float scrollSpeed = scroll*0.5;

    pos.y += sin(PI*uv.x)*scrollSpeed;
    pos.z += sin(PI*uv.x)*scrollSpeed;

    pos.y += sin(time*0.001)*0.02;
    vUv.y -= sin(time*0.001)*0.02;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}