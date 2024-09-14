uniform vec3 iResolution; // resolution of the screen
uniform float iTime;      // time variable
float pixelSize = 0.5;  // size of the pixels for pixelation effect

float distanceToPoint(vec2 p1, vec2 p2) {
    return sqrt(pow(p1.x - p2.x, 2.0) + pow(p1.y - p2.y, 2.0));
}

vec3 yuv2rgb(vec3 yuv) {
    float y = yuv.x;
    float u = yuv.y - 0.5;
    float v = yuv.z - 0.5;

    float r = y + 1.402 * v;
    float g = y - 0.344136 * u - 0.714136 * v;
    float b = y + 1.772 * u;

    return vec3(r, g, b);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Retrieve screen resolution and pixel coordinates
    vec2 uv = fragCoord.xy / iResolution.xy;

    // Pixelation effect: reduce resolution by pixelSize
    uv = floor(uv * pixelSize) / pixelSize;

    // Time value limited to 20 FPS (1/20th of a second)
    float frameRate = 30.0;
    float frameTime = 1.0 / frameRate;
    float tempTime = floor(iTime / frameTime) * frameTime * -0.1;

    // Calculate x and y based on the UV coordinates
    float x = uv.x * iResolution.x;
    float y = uv.y * iResolution.y;

    // Calculate the hex color value directly
    // float colorHex = floor(
    //     mod(abs((mod(x / 10.0, 100.0) * y * tan(x * 10.0 + tempTime) * 10.0 )+ 400000.0)  , 16777215.0)
    // );
    float colorHex = floor(
        mod(0.3*abs(
          (distanceToPoint(vec2(x*x*x/100.0+tempTime*10.0, (y*y*100.0-tempTime*20000.0)+cos(x/100.0+tempTime*10.0)*10000000.0), vec2(10000.0+sin(x)*1000000.0,0.0))*1.0 - tempTime*5000.0) 
          //(mod(x / 10.0, 100.0) * y * tan(x * 10.0 + tempTime) * 10.0 ) + 400000.0
          ), 16777215.0)
    );

    // Extract RGB components using bitwise operations
    float r = floor(mod(colorHex / 65536.0, 256.0)) / 255.0;
    float g = floor(mod(colorHex / 256.0, 256.0)) / 255.0;
    float b = floor(mod(colorHex, 256.0)) / 255.0;

    // Combine into a color vector
    // vec3 color = vec3(r*30.0+g/2.0, g/2.0, b*b*b*100.0);
    vec3 color = yuv2rgb(vec3(r, g, b));

    // Set the final fragment color
    fragColor = vec4(color, 1.0);
}

void main() {
    mainImage(gl_FragColor, gl_FragCoord.xy);
}

