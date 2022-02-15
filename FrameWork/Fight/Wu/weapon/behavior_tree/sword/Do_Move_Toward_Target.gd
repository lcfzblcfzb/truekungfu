extends BTLeaf

var _command_frame_id =0

func _tick(agent: Node, blackboard: Blackboard) -> bool:
	
	assert(agent is FightComponent_human)
	
	var fight_componnent = agent as FightComponent_human
	var target  = blackboard.get_data("locked_target") as FightComponent_human
	
	if fight_componnent.fightKinematicMovableObj.state == FightKinematicMovableObj.ActionState.Walk:
		return succeed()
	
	var moving_direction = Vector2.ZERO
	
	var is_on_left = fight_componnent.global_position.x < target.global_position.x
	
	if is_on_left:
		moving_direction = Vector2.RIGHT
	else:
		moving_direction = Vector2.LEFT
	push_warning("MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMtoward")
	
	if _command_frame_id == get_tree().get_frame():	
		return succeed()
	
	fight_componnent.fight_controller.emit_new_fight_motion_event(Tool.getPollObject(MoveEvent,[moving_direction,false,false]))
	_command_frame_id = get_tree().get_frame()
	
	return succeed()
