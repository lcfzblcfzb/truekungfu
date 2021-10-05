extends AnimationTree

var state_machine_playback = get("parameters/sm/playback")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _map_action2animation(action)->String:
	
	match action:
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

#动作动作
func act(action):
	var animation = _map_action2animation(action)
	print("action: ",animation)
	if animation!=null:
		state_machine_playback.travel(animation)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
