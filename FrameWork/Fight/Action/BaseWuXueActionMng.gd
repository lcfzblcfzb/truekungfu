extends Object

var dict={}

func _init():
	
	load_from_file()

func load_from_file():
	var base_action_array = Tool.load_json_file("res://config/BaseWuXueAction.tres")
	
	if base_action_array!=null:
		for action in base_action_array:
			var base_action = BaseAction.new(action)
			#json 中数字默认是float 要转成INT
			dict[action.id as int]= base_action
			pass
		
	pass
	
#get 方法
func get_by_base_id(base_id):

	return dict.get(base_id)

#TODO 
func find_by_wuxue_and_forcetype(wuxue,forceType):
	
	
	pass
