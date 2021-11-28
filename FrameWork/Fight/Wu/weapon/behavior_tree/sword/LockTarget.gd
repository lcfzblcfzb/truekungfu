extends BTLeaf


func _tick(agent: Node, blackboard: Blackboard) -> bool:
	
	var oppose_array = blackboard.get_data("oppose_array")
	blackboard.set_data("locked_target",oppose_array[0])
	
	return succeed()
