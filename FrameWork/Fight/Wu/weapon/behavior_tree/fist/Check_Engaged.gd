extends BTNode

func _tick(agent: Node, blackboard: Blackboard) -> bool:
	assert("is_engaged" in agent)
	agent.check_engaged()
	
	if agent.is_engaged:
		return succeed()
	else:
		return fail()
	
