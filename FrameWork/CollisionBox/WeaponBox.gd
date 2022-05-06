class_name WeaponBox

extends Area2D

#Glob.DamageType
var damage_type

#在Weapon 类的 init() 方法中初始化
var fight_cpn

func get_attr_type_by_dmg_type():
	
	match damage_type:
		Glob.DamageType.Ci:
			return Glob.CharactorAttribute.AttackCiDamage
		Glob.DamageType.Sao:
			return Glob.CharactorAttribute.AttackSaoDamage
		Glob.DamageType.Pi:
			return Glob.CharactorAttribute.AttackPiDamage

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
					var attr_mng = fight_cpn.attribute_mng as AttribugeMng
					var attack = attr_mng.get_value(get_attr_type_by_dmg_type())
					
					var oppo = area.fight_cpn
					var oppo_attr_mng = oppo.attribute_mng as AttribugeMng
					var def = oppo_attr_mng.get_value(Glob.CharactorAttribute.BlockReduceDamage)
					
					oppo.sprite_animation.emit_signal("Hurt",self,clamp(attack-def,0,attack))	
					hitted.append(area)
				elif area.counter_attack_type ==Glob.CounterDamageType.Rolling and damage_type !=Glob.DamageType.Pi:
					
					var oppo = area.fight_cpn
					oppo.sprite_animation.emit_signal("Hurt",self,0)	
					hitted.append(area)
				elif area.counter_attack_type ==Glob.CounterDamageType.Dodge and damage_type != Glob.DamageType.Ci:
					
					var oppo = area.fight_cpn
					oppo.sprite_animation.emit_signal("Hurt",self,0)	
					hitted.append(area)
				elif area.counter_attack_type ==Glob.CounterDamageType.AutoBlock:
					var attr_mng = fight_cpn.attribute_mng as AttribugeMng
					var attack = attr_mng.get_value(get_attr_type_by_dmg_type())
					var oppo = area.fight_cpn
					oppo.sprite_animation.emit_signal("Hurt",self,attack)	
					hitted.append(area)
			
			if hitted.size()>0:		
				#TODO 有点怪 通过sprite_animation 发出信号 最终还是fight_cpn 处理了；；
				fight_cpn.sprite_animation.emit_signal("Hit",hitted)	
			
func start_monitoring():
	monitoring = true

func stop_monitoring():
	set_deferred("monitoring",false)
