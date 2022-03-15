extends BTConditional

# A conditional node MUST NOT override _tick but only 
# _pre_tick and _post_tick.


# The condition is checked BEFORE ticking. So it should be in _pre_tick.
func _pre_tick(agent: Node, blackboard: Blackboard) -> void:
	assert("is_engaged" in agent)
	
	var oppose_array = RoleMng.findOpposeMember(agent.camp)
	
	if oppose_array.size()>1:
		blackboard.set_data("oppose_array",oppose_array)
		verified = true
	else:
		blackboard.set_data("locked_target",oppose_array[0])
		verified = false
