class_name BaseAction
extends Resource

export(int) var id
export(String) var name
#second
export(float) var duration

export(Glob.ActionHandlingType) var handle_type

export(Array,Glob.FightMotionType) var type
#属于哪一种 wu_motion
export(Glob.WuMotion) var wu_motion
#声音关键点时间（用来同步音效）
export(float) var sound_effect_key =0.0
#动作音效列表
export(Array,Glob.SoundEffectEnums) var sound_effects 

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
