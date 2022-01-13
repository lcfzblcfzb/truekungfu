class_name BasePlatformerCharactor
extends BaseCharactor

#是否处于可攀爬场景楼梯的范围内。是改变运动状态为攀爬的必要条件
var is_climbing =false setget set_climbing;
#是否处于平台之上
var is_on_platform = false setget set_on_platform
#是否在地面
var on_floor = false setget set_on_floor

func set_climbing(b):
	is_climbing = b

func set_on_platform(b):
	is_on_platform = b

func set_on_floor(b):
	on_floor = b
	#如果不在floor 就表示不在platform
	if not b:
		self.is_on_platform = b

#在地面或者平台之上
func is_on_genelized_floor():
	return is_on_platform or on_floor

#获得当前速度
func get_velocity()->Vector2:
	return Vector2.ZERO
