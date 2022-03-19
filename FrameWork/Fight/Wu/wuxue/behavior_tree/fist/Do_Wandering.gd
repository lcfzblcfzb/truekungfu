extends BTWait

func _pre_tick(agent: Node, blackboard: Blackboard) -> void:
	print("Doing Wandering")
	
	assert(agent is FightComponent_human)
	
	var fight_componnent = agent as FightComponent_human
	
	if fight_componnent.fightKinematicMovableObj.state == FightKinematicMovableObj.ActionState.Idle:
		return 
	var moving_direction = Vector2.ZERO
	if fight_componnent.actionMng._current_action!=null:
		push_warning(fight_componnent.actionMng._current_action.base_action as String)
	
	fight_componnent.fight_controller.emit_new_fight_motion_event(Glob.getPollObject(MoveEvent,[moving_direction,false,false]))
