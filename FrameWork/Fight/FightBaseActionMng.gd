extends "res://FrameWork/Fight/Action/BaseActionMng.gd"

func _ready():
	
	load_from_file()

func load_from_file():
	var base_action_array = Tool.load_json_file("res://config/BaseAction.tres")
	
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

#动作类型
#同一个baseAction可以拥有多个类型，针对不同操作自定义
enum FightActionType{
	MOVEMENT=1,
	GESTURE=2,
	ATTACK=3,
	DEFEND=4,
}
