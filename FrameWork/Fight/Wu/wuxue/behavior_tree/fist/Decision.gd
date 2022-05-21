extends BTLeaf



func _tick(agent: Node, blackboard: Blackboard) -> bool:
	
	assert(agent is FightComponent_human)
		
	#TODO 根据情况set
	var decision =randi() % 3  +1
	#1 for attacking; 2 for safe ;3 for wiggling
	blackboard.set_data("state",3)
	
	return succeed()
