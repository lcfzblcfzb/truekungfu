class_name AIEvent

extends BaseFightEvent
#glob.wumotion
var action_id

func _init(pool,params:Array).(pool,Glob.EventType.AI_Event,params):
	action_id = params[0]
	pass
#TODO 
func _clean():
	action_id=null
	pass
