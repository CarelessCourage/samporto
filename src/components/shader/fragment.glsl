varying vec2 vUv;
uniform sampler2D texture1;
uniform float inFocus;
uniform bool hole;
uniform bool expanded;
uniform float opacity;
void main() {
    vec4 t = texture2D(texture1, vUv);

    //Make texture grayscale based to distance to center
    float bw = (t.r + t.b + t.g) / 3.;
    vec4 another = vec4(bw, bw, bw, 1.);
    gl_FragColor = mix(another, t, inFocus);

    //Make opacity based on distance to center
    //Also decide whether or not to make a hole by turning the middle image to opacity 0

    float focus = inFocus;
    float mexie = 1.0;
    float op = opacity;

    if(hole) {
        focus = 1. - inFocus;
        mexie = opacity;
    }

    //fix ghosts left when clicking quickly after scrolling
    if(!hole) {
        if(inFocus > 0.8) {
            focus = inFocus;
        } else {
            focus = inFocus - 0.5;
        }
    }

    //Apply all the opacity decitions    
    gl_FragColor.a = clamp(focus, 0.0, mexie);
}