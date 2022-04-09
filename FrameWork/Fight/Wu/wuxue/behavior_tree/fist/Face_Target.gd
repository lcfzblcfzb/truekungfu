extends BTLeaf



func _tick(agent: Node, blackboard: Blackboard) -> bool:
	
	assert(agent is FightComponent_human)
	
	var fight_componnent = agent as FightComponent_human
	
	var target  = blackboard.get_data("locked_target") as FightComponent_human
	
	var is_on_left = fight_componnent.global_position.x < target.global_position.x
	var moving_direction = Vector2.ZERO
	if is_on_left :
		if fight_componnent.is_face_left():
			moving_direction = Vector2.RIGHT
	else:
		if not fight_componnent.is_face_left():
			moving_direction = Vector2.LEFT
	
	fight_componnent.fightKinematicMovableObj.charactor_face_direction = moving_direction
	return succeed()
