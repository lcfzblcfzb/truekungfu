extends Node2D


onready var back_ground = $world ;
onready var dynamic_camera = $world/Camera2D;

func _ready():
	
	var bg_size:Vector2  = Vector2.ZERO
	if back_ground.region_enabled:
		bg_size = back_ground.region_rect.size
	else:
		bg_size = back_ground.texture.get_size() 
	
	var left_limit = 0
	var top_limit = 0
	var right_limit =0
	var bot_limit =0
	
	#计算Limit
	if back_ground.centered:
		left_limit = -bg_size.x/2
		top_limit = -bg_size.y/2
		right_limit = - left_limit
		bot_limit = - top_limit
	else:
		left_limit =0
		top_limit =0
		right_limit = bg_size.x
		bot_limit = bg_size.y
		
	#设置Limit
	dynamic_camera.limit_left = left_limit
	dynamic_camera.limit_right = right_limit
	dynamic_camera.limit_top = top_limit
	dynamic_camera.limit_bottom = bot_limit
	pass
