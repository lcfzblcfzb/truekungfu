tool
extends Node2D

#path to file
export(String, FILE) var cfg_path
# Declare member export(float, 0, 5, 0.1)  variables here. Examples:
# export(float, 0, 5, 0.1)  var a = 2
# export(float, 0, 5, 0.1)  var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	#从文件中读取JSON数据，并且赋值给对象同名属性上
	var json =Tool.load_json_file(cfg_path) as Dictionary

	for p in get_property_list():
		
		if json.has(p.name):
			var v = json.get(p.name)
			set(p.name,v.value)
			print(v)
			pass
		
		pass
	pass
	
	pass # Replace with function body.
#攻击——上路
export(float, 0, 5, 0.1)  var attack_up_pre_time :float;
export(float, 0, 5, 0.1)  var attack_up_in_time :float;
export(float, 0, 5, 0.1)  var attack_up_end_time :float;
#攻击——中路
export(float, 0, 5, 0.1)  var attack_center_pre_time :float;
export(float, 0, 5, 0.1)  var attack_center_in_time :float;
export(float, 0, 5, 0.1)  var attack_center_end_time :float;
#攻击——下路
export(float, 0, 5, 0.1)  var attack_down_pre_time :float;
export(float, 0, 5, 0.1)  var attack_down_in_time :float;
export(float, 0, 5, 0.1)  var attack_down_end_time :float;
	
#重攻击——上路
export(float, 0, 5, 0.1)  var heavyAttack_up_pre_time :float;
export(float, 0, 5, 0.1)  var heavyAttack_up_in_time :float;
export(float, 0, 5, 0.1)  var heavyAttack_up_end_time :float;
#重攻击——中路
export(float, 0, 5, 0.1)  var heavyAttack_center_pre_time :float;
export(float, 0, 5, 0.1)  var heavyAttack_center_in_time :float;
export(float, 0, 5, 0.1)  var heavyAttack_center_end_time :float;
#重攻击——下路
export(float, 0, 5, 0.1)  var heavyAttack_down_pre_time :float;
export(float, 0, 5, 0.1)  var heavyAttack_down_in_time :float;
export(float, 0, 5, 0.1)  var heavyAttack_down_end_time :float;


#防御——上路
export(float, 0, 5, 0.1)  var defend_up_pre_time :float;
export(float, 0, 5, 0.1)  var defend_up_in_time :float;
export(float, 0, 5, 0.1)  var defend_up_end_time :float;
#防御——中路
export(float, 0, 5, 0.1)  var defend_center_pre_time :float;
export(float, 0, 5, 0.1)  var defend_center_in_time :float;
export(float, 0, 5, 0.1)  var defend_center_end_time :float;
#防御——下路
export(float, 0, 5, 0.1)  var defend_down_pre_time :float;
export(float, 0, 5, 0.1)  var defend_down_in_time :float;
export(float, 0, 5, 0.1)  var defend_down_end_time :float;

#重防御——上路
export(float, 0, 5, 0.1)  var heavyDefend_up_pre_time :float;
export(float, 0, 5, 0.1)  var heavyDefend_up_in_time :float;
export(float, 0, 5, 0.1)  var heavyDefend_up_end_time :float;
#重防御——中路
export(float, 0, 5, 0.1)  var heavyDefend_center_pre_time :float;
export(float, 0, 5, 0.1)  var heavyDefend_center_in_time :float;
export(float, 0, 5, 0.1)  var heavyDefend_center_end_time :float;
#重防御——下路
export(float, 0, 5, 0.1)  var heavyDefend_down_pre_time :float;
export(float, 0, 5, 0.1)  var heavyDefend_down_in_time :float;
export(float, 0, 5, 0.1)  var heavyDefend_down_end_time :float;


