extends Node2D


onready var back_ground = $world ;
onready var dynamic_camera = $world/Camera2D;

export (Array,NodePath) var dynamic_object_nodepath_list =[]

#动态物体 列表
var dynamic_object_list:Array = []

#从 nodepath 引用中初始化 动态物体 列表
func _init_dynamic_object():
	
	for p  in dynamic_object_nodepath_list:
		
		var node = get_node(p)
		if node !=null:
			dynamic_object_list.append(node)
		pass
	pass
	
#计算 动态物体 相机跟随 移动距离

#公式：    速度  * 相机视距  / （相机视距 *动态物体深度 ）
func calc_dynamic_object_delta_distance(var object_depth:int,var camera_speed:Vector2) ->Vector2:
	
	var result = camera_speed * dynamic_camera.camera_distance / (dynamic_camera.camera_distance * object_depth)
	
	return result
	

func _physics_process(delta):
	
	for obj  in dynamic_object_list:
		
		obj = obj as Sprite
		
		var ds =calc_dynamic_object_delta_distance(obj.distance_to_screen , dynamic_camera.speed)
		
		obj.position = (obj.position +ds )
		pass
	
	pass

func _ready():
	
	_init_dynamic_object()
	
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
