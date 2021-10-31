extends AnimationTree

var state_machine_playback = get("parameters/sm/playback")

export (NodePath)var _fight_action_path setget set_fight_action_control

var fight_action_control;

func set_fight_action_control(f):
	fight_action_control = get_node(f)

signal State_Changed;

func _map_action2animation(action)->String:
	
	var baseAction =  FightBaseActionMng.get_by_base_id(action)
	
	if baseAction:
		return baseAction.animation_name
	
	match action:
		
		Tool.FightMotion.Idle:
			return "idle"
		Tool.FightMotion.Walk:
			return "walk"
		Tool.FightMotion.Run:
			return "run"
			pass
		Tool.FightMotion.Holding:
			return "holding"
			pass	
		Tool.FightMotion.Def_Bot:
			return 	"d_b_after"
		Tool.FightMotion.Def_Mid:
			return "d_m_after"	
		Tool.FightMotion.Def_Up:
			return "d_u_after"
			
		Tool.FightMotion.Attack_Up:
			return "a_u_after"
			pass
		Tool.FightMotion.Attack_Bot:
			return "a_b_after"
			pass
		Tool.FightMotion.Attack_Mid:
			return "a_m_after"
			pass	
		
		Tool.FightMotion.HeavyAttack_B:
			return "ha_b_after"
			pass
			
		Tool.FightMotion.HeavyAttack_B2M:
			return "ha_b2m_after"
			pass
			
		Tool.FightMotion.HeavyAttack_B2U:
			return "ha_b2u_after"	
			pass
			
		Tool.FightMotion.HeavyAttack_M:
			return "ha_m_after"
			pass
			
		Tool.FightMotion.HeavyAttack_M2B:
			return "ha_m2b_after"
			pass
			
		Tool.FightMotion.HeavyAttack_M2U:
			return "ha_m2u_after"
			pass
			
		Tool.FightMotion.HeavyAttack_U:
			return "ha_u_after"
			pass
			
		Tool.FightMotion.HeavyAttack_U2B:
			return "ha_u2b_after"
			pass
			
		Tool.FightMotion.HeavyAttack_U2M:
			return "ha_u2m_after"
			pass
	return ''
	pass

#前一个路过的结点；
var prv_node =""

func _process(delta):
	
	var current_node = state_machine_playback.get_current_node()
	if current_node!=prv_node:
		emitSignal(current_node)
		prv_node = current_node
		
	pass
#动作动作
func act(action:ActionInfo,timescale):
	var animation = action.get_base_action().get("animation_name")
	print("【action】: ",animation)
	if animation!=null:
		
		travelTo(animation)
		#set_deferred("parameters/TimeScale/scale",5)
		var time = 1/timescale
		print(time)
		set_deferred("parameters/TimeScale/scale",time)
		
#封装的travel 方法;
func travelTo(name):
	state_machine_playback.travel(name)

#玩一下yield方法；
func emitSignal(toNode):
	print("current time scale",get("parameters/TimeScale/scale"))
	print("current node",toNode,OS.get_ticks_msec())
	$RichTextLabel.text +=( "-->" + toNode as String)
	#sinal
	emit_signal("State_Changed",toNode)
