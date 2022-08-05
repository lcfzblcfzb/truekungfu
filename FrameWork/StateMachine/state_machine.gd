class_name StateMachine
extends Node

signal state_inited(inited_state)
signal state_changed(current_state)

export(NodePath) var start_state_path
var states_map = {}

var host
var current_state:State = null

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

func check_state_can_go(state_to)->bool:
	return current_state.check_can_go(state_to)

func initialize(p_host):
	var start_state
	if start_state_path!=null and not start_state_path.is_empty():
		start_state = get_node(start_state_path)
	else:
		start_state = get_child(0)
	host = p_host
	current_state = start_state
	current_state.enter(start_state.state)
	
	LogTool.info("%s: Statemachine initialize" %name)
	emit_signal("state_inited",current_state)
	
func change_state(state_to):
	if not check_state_can_go(state_to):
		return
	
	current_state.exit(state_to)
	var prv_state = current_state
	current_state = states_map[state_to]
	current_state.enter(state_to)
	
	LogTool.info("%s: Statemachine enter:%s"%[name,CommonTools.get_enum_key_name(Glob.SubGameState,state_to)])
	emit_signal("state_changed", current_state)
	
