class_name Gear
extends Node2D

#dynamic
var animation_player:AnimationPlayer setget ,get_animation_player

#static
var base_gear_id
var _base_gear:BaseGear setget ,get_base_gear
var fight_cpn setget set_fight_cpn ,get_fight_cpn


export(int) var state setget  to_state,get_state

#init after ready func
func init(base_gear:BaseGear,fcpn):
	
	self.fight_cpn = fcpn
	self._base_gear = base_gear
	self.base_gear_id = base_gear.id


func set_fight_cpn(f):
	
	fight_cpn = f

func get_fight_cpn():
		
	return fight_cpn

func get_animation_player():
	
	return animation_player


func get_base_gear()->BaseGear:
	if !_base_gear:
		_base_gear = BaseGearDmg.get_by_id(base_gear_id)
	return _base_gear

func get_state():
	return state

func to_state(s):
		
	state = s
	_on_to_state(s)

func _on_to_state(_s):
	pass
#装备的回调方法
func on_add_to_charactor():
	pass

func on_remove_from_charactor():
	pass

func on_actioninfo_start(_action:ActionInfo):
	pass
#同上 是 end 方法的回调
func on_actioninfo_end(_action:ActionInfo):
	pass
#func repath_to_animation_charactor(animation_charactor):
#
#	if animation_player==null:
#		return
#	_animated_charactor = animation_charactor
#
#	var anim_array = animation_charactor.chosed_animation_player.get_animation_list()
#
#	for anim in anim_array:
#
#		if animation_player.has_animation(anim):
#			var prepared_animation = animation_charactor.chosed_animation_player.get_animation(anim)
#			#1 在源animationplayer上 名称为 anim 的动画 上新增一个 type_animation 的 track,获得返回的track id
#			var track_idx = prepared_animation.add_track(Animation.TYPE_ANIMATION)
#			var path =animation_charactor.charactor_scene.get_path_to(animation_player)
#			#2设置 track 的 path; 动画类型的path是 源到 目标的 path
#			prepared_animation.track_set_path(track_idx,path)
#			#3 在track 上 插入key ,和在editor 上创建动画时候一样
#			prepared_animation.animation_track_insert_key(track_idx,0,anim)
#
#			_cached_anim_2_id[anim]= track_idx
#		else:
#			sync_to_remote_movement(animation_charactor,anim)
#			pass

#将组件动作同步到源
#func sync_to_remote_movement(animation_charactor,anim):
#
#	var prepared_animation = animation_charactor.chosed_animation_player.get_animation(anim)
#	#1 在源animationplayer上 名称为 anim 的动画 上新增一个 type_animation 的 track,获得返回的track id
#	var track_idx = prepared_animation.add_track(Animation.TYPE_ANIMATION)
#	var path =animation_charactor.charactor_scene.get_path_to(animation_player)
#	#2设置 track 的 path; 动画类型的path是 源到 目标的 path
#	prepared_animation.track_set_path(track_idx,path)
#	#3 在track 上 插入key ,和在editor 上创建动画时候一样
#	prepared_animation.animation_track_insert_key(track_idx,0,"sync_to_source")
#
#	_cached_anim_2_id[anim]= track_idx
#	pass
#Wu 那里回调的 actioninfo start方法
