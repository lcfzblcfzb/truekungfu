class_name BaseAction

extends Object


#func _init(param:Dictionary):
#
#	id= param.get("id") as int
#	name= param.get("name")
#	animation_name= param.get("animation_name")
#	type= param.get("type")
#	duration= param.get("duration")
	

var id;
var name;
var animation_name;
var type:Array;
var duration #单位：s

func get_duration(unit=O.TimeUnit.MS):
	#若小于0  不需要计算单位
	if duration <0:
		return duration
	#计算单位
	match unit:
		O.TimeUnit.MS:
			return duration*1000
		#TODO 有新单位需求添加其他单位
	#默认处理
	return duration
	
	pass

