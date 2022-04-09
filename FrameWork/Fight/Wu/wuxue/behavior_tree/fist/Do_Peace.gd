extends BTLeaf

func _tick(agent: Node, blackboard: Blackboard) -> bool:
	
	assert(agent is FightComponent_human)
	
	if agent.fightKinematicMovableObj.state != FightKinematicMovableObj.ActionState.Idle:
	
		var fight_componnent = agent as FightComponent_human
		fight_componnent.fight_controller.emit_new_fight_motion_event(Glob.getPollObject(MoveEvent,[Vector2.ZERO,false,false]))
	
	return succeed()
