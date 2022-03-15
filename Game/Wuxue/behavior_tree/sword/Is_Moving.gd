extends BTConditional

# A conditional node MUST NOT override _tick but only 
# _pre_tick and _post_tick.


# The condition is checked BEFORE ticking. So it should be in _pre_tick.
func _pre_tick(agent: Node, blackboard: Blackboard) -> void:
	assert(agent is FightComponent_human)
	
	var fight_componnent = agent as FightComponent_human
	
	if fight_componnent.fightKinematicMovableObj.state in [FightKinematicMovableObj.ActionState.Idle,FightKinematicMovableObj.ActionState.Stop,FightKinematicMovableObj.ActionState.Run2Idle]:
#	if fight_componnent.actionMng._current_action and Tool.FightMotionType.Move in fight_componnent.actionMng._current_action.get_base_action().type:
		
		verified = false
	else:
		verified = true
	
