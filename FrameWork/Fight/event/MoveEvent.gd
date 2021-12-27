class_name MoveEvent

extends BaseFightEvent

var is_jump
var move_direction
var is_echo

func _init(pool,params:Array).(pool,Tool.EventType.Move,params):
	move_direction = params[0]
	is_echo = params[1]
	is_jump = params[2]
	pass
#TODO 
func _clean():
	
	move_direction=null
	is_echo=null
	is_jump=null
	pass
