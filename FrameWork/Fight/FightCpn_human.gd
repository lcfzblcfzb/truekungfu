extends Node2D

class_name FightComponent_human

#接口
#需要传入controlableMovingObj的速度参数
func getSpeed():
	return $ActionHandler.getSpeed()

var i=true
func _input(event):
	
	i=!i
	$AnimationTree.set("parameters/sm/BlendTree/OneShot/active",i)
	
	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	FighterState.new()
	pass # Replace with function body.

enum FightMotion{
	
	Idle,
	Holding,
	Walk,
	Run,
	
	Attack_Up,
	Attack_Mid,
	Attack_Bot,
	
	HeavyAttack_U2M,
	HeavyAttack_U,
	HeavyAttack_U2B,
	
	HeavyAttack_M2U,
	HeavyAttack_M,
	HeavyAttack_M2B,
	
	HeavyAttack_B2U,
	HeavyAttack_B,
	HeavyAttack_B2M,
	
	Def_Up,
	Def_Mid,
	Def_Bot,
	
	HeavyDef_U,
	HeavyDef_U2M,
	HeavyDef_U2B,
	
	HeavyDef_M,
	HeavyDef_M2U,
	HeavyDef_M2B,
	
	HeavyDef_B,
	HeavyDef_B2M,
	HeavyDef_B2U
}



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


#检测到新动作
func _on_FightController_NewFightMotion(motion):
	
	print(motion)
	$AnimationTree.act(motion)
	pass # Replace with function body.


func _on_ControlableMovingObj_State_Changed(state):
	
	if state == ControlableMovingObj.PlayState.Idle:
		$AnimationTree.travel("idle")
	elif state ==ControlableMovingObj.PlayState.Moving:
		$AnimationTree.travel("move")
	
	pass # Replace with function body.
