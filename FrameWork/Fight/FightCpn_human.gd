extends Node2D

class_name FightComponent_human


#接口
#需要传入controlableMovingObj的速度参数
func getSpeed():
	return $ActionHandler.getSpeed()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

