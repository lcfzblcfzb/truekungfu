class_name WeaponBox

extends Area2D

#Glob.DamageType
var damage_type

#在Weapon 类的 init() 方法中初始化
var fight_cpn

func _physics_process(delta):
	#检测武器实时碰撞(不使用信号是因为信号无法检测 在启动 monitoring的瞬间已经处于碰撞状态的情况
	if monitoring :
		var list =get_overlapping_areas()
		if list.size()>0:
			
			if damage_type == -1:
				push_warning("attack_box damage type is not attacking state")
				return
		
			var hitted=[]
			monitoring = false
			for area in list:
				area = area as HurtBox
				
				if area.counter_attack_type ==Glob.CounterDamageType.Block:
				
					var fight_cpn = area.fight_cpn
					fight_cpn.sprite_animation.emit_signal("Hurt",self)	
					hitted.append(area)
				
				elif area.counter_attack_type ==Glob.CounterDamageType.Rolling and damage_type !=Glob.DamageType.Pi:
					
					var fight_cpn = area.fight_cpn
					fight_cpn.sprite_animation.emit_signal("Hurt",self)	
					hitted.append(area)
				elif area.counter_attack_type ==Glob.CounterDamageType.Dodge and damage_type != Glob.DamageType.Ci:
					
					var fight_cpn = area.fight_cpn
					fight_cpn.sprite_animation.emit_signal("Hurt",self)	
					hitted.append(area)
				elif area.counter_attack_type ==Glob.CounterDamageType.AutoBlock:
					var fight_cpn = area.fight_cpn
					fight_cpn.sprite_animation.emit_signal("Hurt",self)	
					hitted.append(area)
			
			if hitted.size()>0:		
				#TODO 有点怪 通过sprite_animation 发出信号 最终还是fight_cpn 处理了；；
				fight_cpn.sprite_animation.emit_signal("Hit",hitted)	
			
func start_monitoring():
	monitoring = true

func stop_monitoring():
	set_deferred("monitoring",false)
