tool
extends Node


var dPi = 2*PI
var hPi = PI/2

var PoolDict ={}

#从对象池中返回 指定类型的对象
func getPollObject(type:GDScript,param=null):
	
	if PoolDict.has(type):
		var pool = PoolDict.get(type) as ObjPool
		return pool.instance(param)
	else:
		var newPool =ObjPool.new(type)
		PoolDict[type] = newPool
		return newPool.instance(param)
		

#TODO 动态创建 ObjPool发
#通过get 方法 检测一遍 如果没找到就NEW 一个

enum EventType{
	
	NewAction,
	Move,
	AI_Event
	
}

enum CampEnum {
	Good,
	Bad,
	Neutral,#以上可以互相攻击
	Harmless#任何一方都无法攻击
}

func test():
	print("print test global")

#返回一个介于0-》2PI 之间的角度
func normalizeAngle(angle:float):
	var absAngle =abs(angle)
	if(absAngle>dPi||angle<0):
		angle = fposmod(angle,dPi)
	
	return angle
#详情见godot文档。节点在屏幕上的坐标章节 
func getCameraPosition(node:Node2D)->Vector2:
	
#	print(node.get_viewport_transform(),node.get_global_transform(),node.position)
	
	return node.get_viewport_transform() * (node.get_global_transform() * node.position)

#从text文件中读取json 并保存为json对象
func load_json_file(path):
	"""Loads a JSON file from the given res path and return the loaded JSON object."""
	var file = File.new()
	file.open(path, file.READ)
	var text = file.get_as_text()
	var result_json = JSON.parse(text)
	if result_json.error != OK:
		print("[load_json_file] Error loading JSON file '" + str(path) + "'.")
		print("\tError: ", result_json.error)
		print("\tError Line: ", result_json.error_line)
		print("\tError String: ", result_json.error_string)
		return null
	var obj = result_json.result
	return obj

# 武 动作枚举（抽象动作，每个特定的武术会有自己的实现)
enum WuMotion{
	
	Idle,
	Walk,
	Run,
	Holding,
	Stunned,
	JumpUp,
	JumpDown,
	Hanging,
	HangingClimb,
	Attack,
	Defend,
	
	Attack_Up,
	Attack_Mid,
	Attack_Bot,
	
	Attack_U2M,
	Attack_U2B,
	Attack_M2U,
	Attack_M2B,
	Attack_B2M,
	Attack_B2U,
	
	Defend_Up,
	Defend_Mid,
	Defend_Bot
	
}

#动作类型
enum FightMotionType{
	Move=1,
	Action=2,
	AttackAction=3,
	DefendAction=4,
}


#动画ID名称
enum FightMotion{
	
	Idle =154,
	Walk=155,
	Run=156,
	Holding=157,
	Idle2Run=158,
	Run2Idle=159,
	Stunned =160,
	JumpUp =161,
	JumpDown =162,
	Climb = 163,
	Hanging = 164,
	HangingClimb = 165,
	Attack = 166,
	Defend = 167,
	
	Attack_Up_Pre=100,
	Attack_Up_In=101,
	Attack_Up_After=102,
	Attack_Mid_Pre=103,
	Attack_Mid_In=104,
	Attack_Mid_After=105,
	Attack_Bot_Pre=106,
	Attack_Bot_In=107,
	Attack_Bot_After=108,
	
	HeavyAttack_U_Pre=109,
	HeavyAttack_U_In=110,
	HeavyAttack_U_After=111,
	HeavyAttack_M_Pre=112,
	HeavyAttack_M_In=113,
	HeavyAttack_M_After=114,
	HeavyAttack_B_Pre=115,
	HeavyAttack_B_In=116,
	HeavyAttack_B_After=117,
	
	HeavyAttack_U2M_Pre=118,
	HeavyAttack_U2M_In=119,
	HeavyAttack_U2M_After=120,
	HeavyAttack_U2B_Pre=121,
	HeavyAttack_U2B_In=122,
	HeavyAttack_U2B_After=123,
	
	HeavyAttack_M2B_Pre=124,
	HeavyAttack_M2B_In=125,
	HeavyAttack_M2B_After=126,
	HeavyAttack_M2U_Pre=127,
	HeavyAttack_M2U_In=128,
	HeavyAttack_M2U_After=129,
	
	HeavyAttack_B2M_Pre=130,
	HeavyAttack_B2M_In=131,
	HeavyAttack_B2M_After=132,
	HeavyAttack_B2U_Pre=133,
	HeavyAttack_B2U_In=134,
	HeavyAttack_B2U_After=135,
	
	Def_Up_Pre=136,
	Def_Up_In=137,
	Def_Up_After=138,
	Def_Mid_Pre=139,
	Def_Mid_In=140,
	Def_Mid_After=141,
	Def_Bot_Pre=142,
	Def_Bot_In=143,
	Def_Bot_After=144,
	
	HeavyDef_U_Pre=145,
	HeavyDef_U_In=146,
	HeavyDef_U_After=147,
	
#	HeavyDef_U2M_Pre=148,
#	HeavyDef_U2M_In=149,
#	HeavyDef_U2M_After=150,
#	HeavyDef_U2B_Pre=151,
#	HeavyDef_U2B_In=152,
#	HeavyDef_U2B_After=153,
	
	HeavyDef_M_Pre=148,
	HeavyDef_M_In=149,
	HeavyDef_M_After=150,
#	HeavyDef_M2U_Pre=157,
#	HeavyDef_M2U_In=158,
#	HeavyDef_M2U_After=159,
#	HeavyDef_M2B_Pre=160,
#	HeavyDef_M2B_In=100,
#	HeavyDef_M2B_After=100,
	
	HeavyDef_B_Pre=151,
	HeavyDef_B_In=152,
	HeavyDef_B_After=153,
#	HeavyDef_B2M_Pre=100,
#	HeavyDef_B2M_In=100,
#	HeavyDef_B2M_After=100,
#	HeavyDef_B2U_Pre=100,
#	HeavyDef_B2U_In=100,
#	HeavyDef_B2U_After=100
}

#将fihgt motion 和动画名称11 队应
func _map_action2animation(action)->String:
	
	match action:
		
		FightMotion.Idle:
			return "idle"
		FightMotion.Walk:
			return "walk"
		FightMotion.Run:
			return "run"
		FightMotion.Holding:
			return "holding"
			
		FightMotion.Attack_Up_Pre:
			return "a_u_pre"
			
		FightMotion.Attack_Up_In:
			return "a_u_in"
			
		FightMotion.Attack_Up_After:
			return "a_u_after"
			pass
		FightMotion.Attack_Bot_Pre:
			return "a_b_prer"
		
		FightMotion.Attack_Bot_In:
			return "a_b_in"
		
		FightMotion.Attack_Bot_After:
			return "a_b_after"
			pass
		FightMotion.Attack_Mid_Pre:
			return "a_m_pre"
			pass	
			
		FightMotion.Attack_Mid_In:
			return "a_m_in"
			pass	
			
		FightMotion.Attack_Mid_After:
			return "a_m_after"
			pass	
		
		FightMotion.HeavyAttack_B_Pre:
			return "ha_b_pre"
			pass
			
		FightMotion.HeavyAttack_B_In:
			return "ha_b_in"
			pass
			
		FightMotion.HeavyAttack_B_After:
			return "ha_b_after"
			pass
			
		FightMotion.HeavyAttack_B2M_Pre:
			return "ha_b2m_pre"
			pass
			
		FightMotion.HeavyAttack_B2M_In:
			return "ha_b2m_in"
			pass
			
		FightMotion.HeavyAttack_B2M_After:
			return "ha_b2m_after"
			pass
			
		FightMotion.HeavyAttack_B2U_Pre:
			return "ha_b2u_pre"	
			pass
			
		FightMotion.HeavyAttack_B2U_In:
			return "ha_b2u_in"	
			pass
			
		FightMotion.HeavyAttack_B2U_After:
			return "ha_b2u_after"	
			pass
			
		FightMotion.HeavyAttack_M_Pre:
			return "ha_m_pre"
			pass
			
		FightMotion.HeavyAttack_M_In:
			return "ha_m_in"
			pass
		FightMotion.HeavyAttack_M_After:
			return "ha_m_after"
			pass
			
		FightMotion.HeavyAttack_M2B_Pre:
			return "ha_m2b_pre"
			pass
		FightMotion.HeavyAttack_M2B_In:
			return "ha_m2b_in"
			pass
		FightMotion.HeavyAttack_M2B_After:
			return "ha_m2b_after"
			pass
			
		FightMotion.HeavyAttack_M2U_Pre:
			return "ha_m2u_pre"
			pass
		FightMotion.HeavyAttack_M2U_In:
			return "ha_m2u_after"
			pass
		FightMotion.HeavyAttack_M2U:
			return "ha_m2u_after"
			pass
			
		FightMotion.HeavyAttack_U:
			return "ha_u_after"
			pass
			
		FightMotion.HeavyAttack_U2B:
			return "ha_u2b_after"
			pass
			
		FightMotion.HeavyAttack_U2M:
			return "ha_u2m_after"
			pass
		FightMotion.Def_Bot_Pre:
			return "d_b_pre"
		FightMotion.Def_Bot_In:
			return "d_b_in"
		FightMotion.Def_Bot_After:
			return "d_b_after"
		
		FightMotion.Def_Mid_Pre:
			return "d_m_pre"
			
		FightMotion.Def_Mid_In:
			return "d_m_in"
			
		FightMotion.Def_Mid_After:
			return "d_m_after"	
			
		FightMotion.Def_Up_Pre:
			return "d_u_pre"
			
		FightMotion.Def_Up_In:
			return "d_u_in"
			
		FightMotion.Def_Up_After:
			return "d_u_after"
			
		
	return ''
	pass


class RandomTool:
	
	static func get_random(list:Array):
		var rand_num = floor(rand_range(0,list.size()))
		return list[rand_num]		
	
	
