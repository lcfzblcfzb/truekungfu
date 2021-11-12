class_name NewActionEvent
extends BaseFightEvent

var last_byte;
var byte_array;
var action_begin_time;
var action_end_time;

func _init(pool,params:Array).(pool,Tool.EventType.NewAction,params):
	last_byte = params[0]
	byte_array = params[1]
	action_begin_time=params[2]
	action_end_time = params[3]
	pass

#TODO 
func _clean():
	
	last_byte = null
	byte_array=null
	action_begin_time=null
	action_end_time=null
	pass
