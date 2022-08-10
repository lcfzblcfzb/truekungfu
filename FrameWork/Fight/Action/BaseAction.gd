class_name BaseAction

extends IntEntity

#用以区分处理时候的分类-》同一类型的action 按顺序执行，不同类型的action 是同步执行
#取自 Glob.ActionHandlingType
var handle_type=Glob.ActionHandlingType.Action;

var name;
var animation_name;
# Glob.FightMotionType
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

