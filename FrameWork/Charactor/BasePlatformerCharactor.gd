class_name BasePlatformerCharactor
extends BaseCharactor

#是否处于可攀爬场景楼梯的范围内。是改变运动状态为攀爬的必要条件
var is_climbing =false setget set_climbing;
#是否处于平台之上
var is_on_platform = false setget set_on_platform



func set_climbing(b):
	is_climbing = b

func set_on_platform(b):
	is_on_platform = b


#在地面或者平台之上
func is_on_genelized_floor():
	var parent =.is_on_floor()
	return is_on_platform or .is_on_floor()

#获得当前速度
func get_velocity()->Vector2:
	return Vector2.ZERO
