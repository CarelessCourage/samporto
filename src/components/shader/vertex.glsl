uniform float time;
uniform float scroll;
uniform float inFocus;
varying vec2 vUv;
float PI=3.141592653589793239;
void main(){
    vUv=(uv-vec2(.5))*(.9-.2*inFocus)+vec2(.5);
    vec3 pos=position;
    
    float scrollSpeed=scroll*.5;
    
    pos.y+=sin(PI*uv.x)*scrollSpeed;
    pos.z+=sin(PI*uv.x)*scrollSpeed;
    
    pos.y+=sin(time*.001)*.02;
    vUv.y-=sin(time*.001)*.02;
    gl_Position=projectionMatrix*modelViewMatrix*vec4(pos,1.);
}