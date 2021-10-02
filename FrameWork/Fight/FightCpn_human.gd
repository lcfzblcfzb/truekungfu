extends Node2D

class_name FightComponent_human

#接口
#需要传入controlableMovingObj的速度参数
func getSpeed():
	return $ActionHandler.getSpeed()


# Called when the node enters the scene tree for the first time.
func _ready():
	FighterState.new()
	pass # Replace with function body.

#角色各项数据类
class FighterState:
	#攻击——上路
	var attack_up_pre_time :float;
	var attack_up_in_time :float;
	var attack_up_end_time :float;
	#攻击——中路
	var attack_center_pre_time :float;
	var attack_center_in_time :float;
	var attack_center_end_time :float;
	#攻击——下路
	var attack_down_pre_time :float;
	var attack_down_in_time :float;
	var attack_down_end_time :float;
		
	#重攻击——上路
	var heavyAttack_up_pre_time :float;
	var heavyAttack_up_in_time :float;
	var heavyAttack_up_end_time :float;
	#重攻击——中路
	var heavyAttack_center_pre_time :float;
	var heavyAttack_center_in_time :float;
	var heavyAttack_center_end_time :float;
	#重攻击——下路
	var heavyAttack_down_pre_time :float;
	var heavyAttack_down_in_time :float;
	var heavyAttack_down_end_time :float;
	
	
	#防御——上路
	var defend_up_pre_time :float;
	var defend_up_in_time :float;
	var defend_up_end_time :float;
	#防御——中路
	var defend_center_pre_time :float;
	var defend_center_in_time :float;
	var defend_center_end_time :float;
	#防御——下路
	var defend_down_pre_time :float;
	var defend_down_in_time :float;
	var defend_down_end_time :float;
	
	#重防御——上路
	var heavyDefend_up_pre_time :float;
	var heavyDefend_up_in_time :float;
	var heavyDefend_up_end_time :float;
	#重防御——中路
	var heavyDefend_center_pre_time :float;
	var heavyDefend_center_in_time :float;
	var heavyDefend_center_end_time :float;
	#重防御——下路
	var heavyDefend_down_pre_time :float;
	var heavyDefend_down_in_time :float;
	var heavyDefend_down_end_time :float;
	
	func _init():

		#从文件中读取JSON数据，并且赋值给对象同名属性上
		var json =Tool.load_json_file("res://config/Sword_Cfg.tres") as Dictionary

		for p in get_property_list():
			
			if json.has(p.name):
				var v = json.get(p.name)
				set(p.name,v.value)
				pass
			
			pass
		pass
	
	
	pass

