extends BTLeaf



func _tick(agent: Node, blackboard: Blackboard) -> bool:
	
	assert(agent is FightComponent_human)
	
	var fight_componnent = agent as FightComponent_human
	
	var moving_direction = Vector2.ZERO
		
	fight_componnent.fight_controller.emit_new_fight_motion_event(Tool.getPollObject(MoveEvent,[moving_direction,false,false]))
	
	return succeed()
