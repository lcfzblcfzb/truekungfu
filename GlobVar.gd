extends Node

const BaseOutfitConfig = preload("res://resource/config/outfit/BaseOutfitList.tres")
const BaseGearConfig = preload("res://resource/config/outfit/BaseGearList.tres")
const BaseWeaponConfig = preload("res://resource/config/outfit/BaseWeaponList.tres")
const SoundResrouceConfigs = preload("res://resource/config/Sound/SoundConfigList.tres")
const BaseWuxueConfig = preload("res://resource/config/Wuxue/BaseWuxueConfigs.tres")

#对象池
var PoolDict ={}

var global_unique_id :int= 0

#outfitmng
var outfitMng:OutfitMng

var user_interface

func _ready():
	outfitMng = OutfitMng.new()
	
func get_next_gid():
	global_unique_id+=1
	return global_unique_id
	
#从对象池中返回 指定类型的对象
func getPollObject(type:GDScript,param=null):
	
	if PoolDict.has(type):
		var pool = PoolDict.get(type) as ObjPool
		return pool.instance(param)
	else:
		var newPool =ObjPool.new(type)
		PoolDict[type] = newPool
		return newPool.instance(param)
