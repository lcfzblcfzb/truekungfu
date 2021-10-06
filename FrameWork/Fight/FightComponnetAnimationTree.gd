extends AnimationTree

var state_machine_playback = get("parameters/sm/playback")

signal State_Changed;

func _map_action2animation(action)->String:
	
	match action:
		
		
		FightComponent_human.FightMotion.Run:
			return ""
		FightComponent_human.FightMotion.Idle:
			return "idle"
		FightComponent_human.FightMotion.Walk:
			return "walk"
		FightComponent_human.FightMotion.Run:
			return "run"
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
	
var expectNode = ""
var state : GDScriptFunctionState;

func _process(delta):
	
	if state!=null && state.is_valid():
		
		if state_machine_playback.get_current_node()==expectNode:
			state.resume(expectNode)
			expectNode = ""
	pass
#动作动作
func act(action):
	var animation = _map_action2animation(action)
	print("action: ",animation)
	if animation!=null:
		travelTo(animation)


func travelTo(name):
	if name!=state_machine_playback.get_current_node():
		expectNode = name
		state = emitSignal(expectNode)
		print(state)
		pass
	state_machine_playback.travel(name)
	
func emitSignal(toNode):
	
	yield()
	#sinal
	emit_signal("State_Changed",toNode)
	pass	
