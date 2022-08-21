class_name StateMachine
extends Node

signal state_inited(inited_state)
signal state_changed(current_state)
#指定初始state ，如果没有指定，则是第一个子节点
export(NodePath) var start_state_path
var states_map = {}

var host
var current_state:State = null

#should specified by different usage
var state_enum 

func get_current_status():
	if current_state!=null:
		return current_state.state 
	LogTool.error("current_state is null while getting state")
	return -1

func _ready():
	for child in get_children():
		if child is State:
			child.state_machine = self
			if child["state"]:
				states_map[child["state"]] = child

func check_state_can_go(state_to,data=null)->bool:
	return current_state.check_can_go(state_to,data)

func initialize(p_host):
	host = p_host
	
func state_start(state=-1):
	
	if state<0:
		var start_state
		if start_state_path!=null and not start_state_path.is_empty():
			start_state = get_node(start_state_path)
		else:
			start_state = get_child(0)
		current_state = start_state
	else:
		#
		for child in get_children():
			if child.state == state:
				current_state = child
				break
	
	if not current_state:
		LogTool.error("Cant find current state .state:[%d]" % state)
		return
		
	current_state.enter()	
	LogTool.info("%s: Statemachine initialize" %name)
	emit_signal("state_inited",current_state)
	
	
func change_state(state_to,data=null)->bool:
	if not check_state_can_go(state_to,data):
		return false
	
	current_state.exit(state_to,data)
	var prv_state = current_state
	current_state = states_map[state_to]
	current_state.enter(state_to,data)
	
	LogTool.info("%s: Statemachine enter:%s"%[name,CommonTools.get_enum_key_name(state_enum,state_to)])
	emit_signal("state_changed", current_state)
	return true
