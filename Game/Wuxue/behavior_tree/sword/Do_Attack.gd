extends BTLeaf



func _tick(agent: Node, blackboard: Blackboard) -> bool:
	
	assert(agent is FightComponent_human)
	
	var fight_componnent = agent as FightComponent_human
	
	fight_componnent.fight_controller.emit_new_fight_motion_event(Glob.getPollObject(AIEvent,[Glob.WuMotion.Attack_Mid]))
	
	return fail()
