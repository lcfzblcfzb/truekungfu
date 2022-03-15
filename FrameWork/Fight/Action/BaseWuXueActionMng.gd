class_name BaseWuXueActionMng
extends Node

var dict={}

func _init():
	
	load_from_file()

func load_from_file():
	var base_action_array = Tool.load_json_file("res://config/BaseWuXueAction.tres")
	
	if base_action_array!=null:
		for action in base_action_array:
			var base_action = BaseAction.new()
			#json 中数字默认是float 要转成INT
			dict[action.id as int]= base_action
			pass
		
	pass
	
#get 方法
func get_by_base_id(base_id):

	return dict.get(base_id)

#TODO 
static func get_by_wuxue_and_action(wuxue,actionId)->BaseWuxueAction:
	
	var baseWuxueAction = BaseWuxueAction.new()
	
	baseWuxueAction.id=0;
	baseWuxueAction.base_duration=0.3
	baseWuxueAction.action_force_type =Tool.RandomTool.get_random([BaseWuXue.ActionForceType.CI,BaseWuXue.ActionForceType.GE,BaseWuXue.ActionForceType.LIAO,BaseWuXue.ActionForceType.SAO])
	baseWuxueAction.base_action_id = actionId
	baseWuxueAction.wuxue_id = wuxue
	return baseWuxueAction
	pass
