extends BTLeaf

var _command_frame_id =0;

func _tick(agent: Node, blackboard: Blackboard) -> bool:
	
	assert(agent is FightComponent_human)
	
	var fight_componnent = agent as FightComponent_human
	
	if fight_componnent.fightKinematicMovableObj.state == FightKinematicMovableObj.ActionState.Idle:
		return succeed()
	var moving_direction = Vector2.ZERO
	if _command_frame_id == get_tree().get_frame():	
		return succeed()
	
	fight_componnent.fight_controller.emit_new_fight_motion_event(Glob.getPollObject(MoveEvent,[moving_direction,false,false]))
	_command_frame_id = get_tree().get_frame()
	return succeed()
