class_name NewActionEvent
extends BaseFightEvent

var wu_motion;
#玩家按下按键的开始时间
var action_begin_time;
#玩家抬起按键的时间。 用来判断是否是重攻击
var action_end_time;

func _init(pool,params:Array).(pool,Tool.EventType.NewAction,params):
	wu_motion = params[0]
	action_begin_time = params[1]
	action_end_time = params[2]
	pass

#TODO 
func _clean():
	wu_motion =null
	action_begin_time=null
	action_end_time=null
	pass
