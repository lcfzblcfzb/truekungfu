class_name FightActionMng

extends Node

signal ActionStart
signal ActionProcess
signal ActionFinish

var _action_handler_dict ={}

func _ready():
	
	for type in Glob.ActionHandlingType:
		_action_handler_dict[Glob.ActionHandlingType[type]] = ActionHandler.new(Glob.ActionHandlingType[type],self)

#type -> Glob.ActionHandlingType
func get_handler_by_handling_type(type)->ActionHandler:
	return  _action_handler_dict.get(type as int)

#保持数组长度不超过 MAX_ACTION_ARRAY_SIZE 的长度
#缓存上一个数组的数据
# Deprecated
func regist_action(a, duration=1, exemod=ActionInfo.EXEMOD_NEWEST,groupId =-1,param:Array=[] ):
	#var action =ActionInfo.new(a,OS.get_ticks_msec(),param)
	var input_array = [a ,OS.get_ticks_msec(),param,duration*1000,exemod,groupId]
	var action =Glob.getPollObject(ActionInfo,input_array)
	regist_actioninfo (action)

#注册整个action
func regist_actioninfo(action:ActionInfo):
	
	var handler =get_handler_by_handling_type(action.get_base_action().handle_type)
	return handler.regist_actioninfo(action)

#添加一个组的动作
func regist_group_actions(actions:Array,groupId,group_exe_mod=ActionInfo.EXEMOD_NEWEST):
	for act in actions:
		var action = act as ActionInfo
		action.group_id = groupId
		action.group_exe_mod = group_exe_mod
		regist_actioninfo(action)
		pass
	pass


func get_action_array(handling_type):
	return get_handler_by_handling_type(handling_type).get_action_array()	

func nearest_executed_action(handling_type):
	return get_handler_by_handling_type(handling_type).nearest_executed_action()	

func last_action(handling_type):
	return get_handler_by_handling_type(handling_type).last_action()	

func next_group_id(handling_type):
	return get_handler_by_handling_type(handling_type).next_group_id()	

func is_playing_loop(handling_type):
	return get_handler_by_handling_type(handling_type).is_playing_loop()	

func _physics_process(delta):
	
	for _h  in _action_handler_dict.values():
		_h.on_tick(delta)

func action_start(action:ActionInfo):
	emit_signal("ActionStart",action)

func action_process(action:ActionInfo):
	emit_signal("ActionProcess",action)

#发射此信号的时刻， 取得的action 是完成态的action ；current_action 是正在(准备)进行中的其他actin 或者null
func action_finish(action:ActionInfo):
	emit_signal("ActionFinish",action)
