extends ListDataMng

var dict;


func _init():
	file_path="res://resource/config/BaseAction.tres"
	data_type=BaseAction
#func load_from_file():
#	var base_action_array = Glob.load_json_file("res://resource/config/BaseAction.tres")
#
#	if base_action_array!=null:
#		for action in base_action_array:
#			var base_action = BaseAction.new(action)
#			#json 中数字默认是float 要转成INT
#			dict[action.id as int]= base_action
#			pass
#
#	pass
	

func get_by_anim_name(anim)->String:
	
	for i in dict:
		var item = dict.get(i)
		if item.animation_name ==anim:
			return item
	
	return ""

#动作类型
#同一个baseAction可以拥有多个类型，针对不同操作自定义
enum FightActionType{
	MOVEMENT=1,
	GESTURE=2,
	ATTACK=3,
	DEFEND=4,
}
