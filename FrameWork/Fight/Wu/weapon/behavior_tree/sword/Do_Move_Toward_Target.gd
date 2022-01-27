extends BTLeaf



func _tick(agent: Node, blackboard: Blackboard) -> bool:
	
	assert(agent is FightComponent_human)
	
	var fight_componnent = agent as FightComponent_human
	var target  = blackboard.get_data("locked_target") as FightComponent_human
	
	var moving_direction = Vector2.ZERO
	
	var is_on_left = fight_componnent.global_position.x < target.global_position.x
	
	if is_on_left:
		moving_direction = Vector2.RIGHT
	else:
		moving_direction = Vector2.LEFT
	
	fight_componnent.fight_controller.emit_new_fight_motion_event(Tool.getPollObject(MoveEvent,[moving_direction,false,false]))
	
	return succeed()
