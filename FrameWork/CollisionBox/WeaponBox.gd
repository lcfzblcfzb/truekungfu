class_name WeaponBox

extends Area2D

var fight_cpn 

func _physics_process(delta):
	#检测武器实时碰撞(不使用信号是因为信号无法检测 在启动 monitoring的瞬间已经处于碰撞状态的情况
	if monitoring :
		var list =get_overlapping_areas()
		if list.size()>0:
			emit_signal("Hit",list)	
			monitoring = false
			for area in list:
				var fight_cpn = area.fight_cpn
				fight_cpn.sprite_animation.emit_signal("Hurt",self)	

func start_monitoring():
	monitoring = true
