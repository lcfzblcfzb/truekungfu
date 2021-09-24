shader_type canvas_item;

uniform bool active;
uniform bool t13;

void vertex() {
	if(active){
		
		
		if(t13){
			//将图画向左下和右上倾斜
			VERTEX.x = VERTEX.x*0.5;
			VERTEX.y = VERTEX.y-VERTEX.x/2.0;
		}else{
			//将图像向左上和右下倾斜
			VERTEX.x = VERTEX.x*0.5;
			VERTEX.y = VERTEX.y+VERTEX.x/2.0;
		}
	}
	
}