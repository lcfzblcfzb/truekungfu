extends Camera2D

var target_obj:KinematicBody2D
export (NodePath)var target_path 

#鼠标 移动相机跟随 启动距离
var horizontal_follow_start_distance =100
var vertical_follow_start_distance=100

#鼠标 移动相机跟随 最大距离
var horizontal_follow_max_distance =200;
var vertical_follow_max_distance =200;

#鼠标移动 速度
var h_follow_speed;
var v_follow_speed;

#相机距离眼睛距离.用来计算远近 场景对象 偏移
export var camera_distance = 10;

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	target_obj = get_node(target_path)
	pass # Replace with function body.

#上一帧的位置	
var speed =Vector2.ZERO

func _physics_process(delta):
	
	var camera_position = self.get_camera_screen_center();
	
	print(camera_position)
	if camera_position.distance_squared_to(target_obj.global_position) >1:
		
		var prv_position = camera_position
		
		self.global_position =camera_position.linear_interpolate(target_obj.global_position,0.3)
		
		speed = (self.global_position - prv_position) / delta
				
		pass
	else:
		speed = Vector2.ZERO
	pass


var is_follow = false


func _input(event):
	
	if(event is InputEventMouseMotion):
		var mouseMovingPos = event.global_position
		var screenPos =Tool.getCameraPosition(target_obj)
