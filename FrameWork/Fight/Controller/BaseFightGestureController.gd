class_name BaseFightActionController
extends Node2D

signal NewFightMotion


#攻击指示器出现在角色的左边or右边
#虚拟方法
func is_on_left():
	pass

#获得当前移动向量
func get_moving_vector()->Vector2:
	return Vector2.ZERO

#新的ai 事件
func emit_new_fight_motion_event(event):
	
	emit_signal("NewFightMotion",event)
	pass
