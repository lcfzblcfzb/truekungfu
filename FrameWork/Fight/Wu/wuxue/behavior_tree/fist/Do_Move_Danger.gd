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
	
	if fight_componnent.fightKinematicMovableObj.faceDirection.x != moving_direction.x:
		print(fight_componnent.fightKinematicMovableObj.faceDirection)
		fight_componnent.fight_controller.emit_new_fight_motion_event(Glob.getPollObject(MoveEvent,[moving_direction,false,false]))
	
	var distance = abs(fight_componnent.global_position.x - target.global_position.x)
	
	if distance< 30:
		fight_componnent.fight_controller.emit_new_fight_motion_event(Glob.getPollObject(MoveEvent,[Vector2.ZERO,false,false]))
		blackboard.set_data("state",2)
		return succeed()
	
	return fail()
