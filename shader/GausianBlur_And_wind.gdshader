shader_type canvas_item;


const float PI = 3.14159265358979323846;
const float STD = 1.5;
const int STRENGTH = 1;
uniform bool is_gausiian = true;


float gauss(int x, int y){
	return exp(-float(x * x + y * y) / (2. * STD * STD)) / (2. * PI * STD * STD);
}


void fragment() {
	
	if(is_gausiian){
		
		int x = int(UV.x / TEXTURE_PIXEL_SIZE.x);
		int y = int(UV.y / TEXTURE_PIXEL_SIZE.y);
		int i_min = max(x - STRENGTH, 0);
		int i_max = min(x + STRENGTH + 1, int(1./TEXTURE_PIXEL_SIZE.x));
		int i_diff = i_max - i_min;
		int j_min = max(y - STRENGTH, 0);
		int j_max = min(y + STRENGTH + 1, int(1./TEXTURE_PIXEL_SIZE.y));
		int j_diff = j_max - j_min;
		// Should be equal to (STRENGTH * 2 + 1)^2
		vec4 weights[9];
		vec4 total = vec4(0., 0., 0., 0.);
		for(int i = i_min; i < i_max; i++){
			for(int j = j_min; j < j_max; j++){
				vec4 weight = vec4(
					gauss(i-x, y-j),
					gauss(i-x, y-j),
					gauss(i-x, y-j),
					gauss(i-x, y-j)
				);
				weights[j-j_min + (i-i_min) * (j_max-j_min)] = weight;
				total += weight;
			}
		}
		vec4 color_total = vec4(0., 0., 0., 0.);
		for(int k = 0; k < weights.length(); k++){
			weights[k] /= total;
			weights[k] *= texture(TEXTURE, (UV / TEXTURE_PIXEL_SIZE + vec2(float(k / i_diff), float(k % i_diff))) * TEXTURE_PIXEL_SIZE);
			color_total += weights[k];
		}
		COLOR = color_total;
	
	}else{
		
		COLOR =texture(TEXTURE, UV);
	}
}

// original wind shader from https://github.com/Maujoe/godot-simple-wind-shader-2d/tree/master/assets/maujoe.simple_wind_shader_2d
// original script modified by HungryProton so that the assets are moving differently : https://pastebin.com/VL3AfV8D
//
// speed - The speed of the wind movement.
// minStrength - The minimal strength of the wind movement.
// maxStrength - The maximal strength of the wind movement.
// strengthScale - Scalefactor for the wind strength.
// interval - The time between minimal and maximal strength changes.
// detail - The detail (number of waves) of the wind movement.
// distortion - The strength of geometry distortion.
// heightOffset - The height where the wind begins to move. By default 0.0.

render_mode blend_mix;

// Wind settings.
uniform float speed = 1.0;
uniform float minStrength : hint_range(0.0, 1.0) = 0.05;
uniform float maxStrength : hint_range(0.0, 1.0) = 0.01;
uniform float strengthScale = 100.0;
uniform float interval = 3.5;
uniform float detail = 1.0;
uniform float distortion : hint_range(0.0, 1.0);
uniform float heightOffset : hint_range(0.0, 1.0);

// With the offset value, you can if you want different moves for each asset. Just put a random value (1, 2, 3) in the editor. Don't forget to mark the material as unique if you use this
uniform float offset = 0; 


float getWind(vec2 vertex, vec2 uv, float time){
    float diff = pow(maxStrength - minStrength, 2.0);
    float strength = clamp(minStrength + diff + sin(time / interval) * diff, minStrength, maxStrength) * strengthScale;
    float wind = (sin(time) + cos(time * detail)) * strength * max(0.0, (1.0-uv.y) - heightOffset);
    
    return wind; 
}

void vertex() {
    vec4 pos = WORLD_MATRIX * vec4(0.0, 0.0, 0.0, 1.0);
    float time = TIME * speed + offset;
    //float time = TIME * speed + pos.x * pos.y  ; not working when moving...
    VERTEX.x += getWind(VERTEX.xy, UV, time);
}
