extends BTLeaf


func _tick(agent: Node, blackboard: Blackboard) -> bool:
	
	var oppose_array = blackboard.get_data("oppose_array")
	
	if oppose_array:
		var prv_locked_tar = blackboard.get_data("locked_target")
		if prv_locked_tar and prv_locked_tar in oppose_array:
			return failed()
		
		blackboard.set_data("locked_target",oppose_array[0])
		
	return succeed()
