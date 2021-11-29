class_name NewActionEvent
extends BaseFightEvent

var wu_motion;
var action_begin_time;
var action_end_time;

func _init(pool,params:Array).(pool,Tool.EventType.NewAction,params):
	wu_motion = params[0]
	pass

#TODO 
func _clean():
	wu_motion =null
	action_begin_time=null
	action_end_time=null
	pass
