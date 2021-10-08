extends AnimationTree

var state_machine_playback = get("parameters/sm/playback")

signal State_Changed;

func _map_action2animation(action)->String:
	
	match action:
		
		FightComponent_human.FightMotion.Idle:
			return "idle"
		FightComponent_human.FightMotion.Walk:
			return "walk"
		FightComponent_human.FightMotion.Run:
			return "run"
			pass
		FightComponent_human.FightMotion.Holding:
			return "holding"
			pass	
		FightComponent_human.FightMotion.Attack_Up:
			return "a_u_after"
			pass
		FightComponent_human.FightMotion.Attack_Bot:
			return "a_b_after"
			pass
		FightComponent_human.FightMotion.Attack_Mid:
			return "a_m_after"
			pass	
		
		FightComponent_human.FightMotion.HeavyAttack_B:
			return "ha_b_after"
			pass
			
		FightComponent_human.FightMotion.HeavyAttack_B2M:
			return "ha_b2m_after"
			pass
			
		FightComponent_human.FightMotion.HeavyAttack_B2U:
			return "ha_b2u_after"	
			pass
			
		FightComponent_human.FightMotion.HeavyAttack_M:
			return "ha_m_after"
			pass
			
		FightComponent_human.FightMotion.HeavyAttack_M2B:
			return "ha_m2b_after"
			pass
			
		FightComponent_human.FightMotion.HeavyAttack_M2U:
			return "ha_m2u_after"
			pass
			
		FightComponent_human.FightMotion.HeavyAttack_U:
			return "ha_u_after"
			pass
			
		FightComponent_human.FightMotion.HeavyAttack_U2B:
			return "ha_u2b_after"
			pass
			
		FightComponent_human.FightMotion.HeavyAttack_U2M:
			return "ha_u2m_after"
			pass
	return ''
	pass

#由于在使用animationTree 的时候 animationPlayer 的信号都会失效（如文档里所说，此时animationplayer只用来添加动画)
#所以只能在animationtree中监测
var expectNode = ""
var state : GDScriptFunctionState;

#前一个结点；
var prv_node =""

func _process(delta):
	
	var current_node = state_machine_playback.get_current_node()
	if current_node!=prv_node:
		emitSignal(current_node)
		prv_node = current_node
		
	pass
#动作动作
func act(action):
	var animation = _map_action2animation(action)
	print("action: ",animation)
	if animation!=null:
		travelTo(animation)

#封装的travel 方法;状态切换在此实现。使用yield函数。
#攻击动画分为 前中后 三个部分，在播放的时候添加一个expectNode；
# 添加后在process中检测；
# 检测后返回会emitSignal 函数中；
func travelTo(name):
	print(name)
	state_machine_playback.travel(name)
	pass

#玩一下yield方法；
func emitSignal(toNode):
	
	
	$Label.text +=( "-->" + toNode as String)
	#sinal
	emit_signal("State_Changed",toNode)
