extends BTLeaf

var wiggle_direction  =Vector2.ZERO

func _tick(agent: Node, blackboard: Blackboard) -> bool:
	
	assert(agent is FightComponent_human)
	
	var fight_componnent = agent as FightComponent_human
	var target  = blackboard.get_data("locked_target") as FightComponent_human
	
	if wiggle_direction ==Vector2.ZERO:
		var is_on_left = fight_componnent.global_position.x < target.global_position.x
		if is_on_left:
			wiggle_direction =  Vector2.RIGHT
		else:
			wiggle_direction = Vector2.LEFT
	else:
		wiggle_direction = wiggle_direction.reflect(Vector2.UP)
	
	fight_componnent.fight_controller.emit_new_fight_motion_event(GlobVar.getPollObject(MoveEvent,[wiggle_direction,false,false]))
	
#	if distance> 60:
#		return succeed()
	return succeed()
