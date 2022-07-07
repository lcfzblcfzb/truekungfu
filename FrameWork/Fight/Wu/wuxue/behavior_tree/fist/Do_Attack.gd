extends BTLeaf



func _tick(agent: Node, blackboard: Blackboard) -> bool:
	
	assert(agent is FightComponent_human)
	
	var attack_time = blackboard.get_data("attak_time") 
	
	if attack_time and OS.get_ticks_msec() - attack_time <1000:
		#in cd
		return fail()
	
	var fight_componnent = agent as FightComponent_human
	
	fight_componnent.fight_controller.emit_new_fight_motion_event(GlobVar.getPollObject(AIEvent,[Glob.WuMotion.Attack]))
	blackboard.set_data("attak_time",OS.get_ticks_msec()) 
	blackboard.set_data("attacking",true)
	return fail()
