extends BTLeaf



func _tick(agent: Node, blackboard: Blackboard) -> bool:
	
	assert(agent is FightComponent_human)

	
	if not blackboard.has_data("state"):
		
		#TODO 根据情况set
		var decision =randi() % 2  +1
			#1 for dange; 2 for safe
		blackboard.set_data("state",1)
	
	return succeed()
