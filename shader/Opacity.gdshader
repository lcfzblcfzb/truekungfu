shader_type canvas_item;

uniform float opacity =1;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	if(color.a >0.0){
		color.a = opacity;
	}
	COLOR = color;
}