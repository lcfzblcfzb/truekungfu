extends Weapon

#onready var sword_left_hand = $sword_left_hand
onready var sword_right_hand = $sword_right_hand
onready var sword_sheath = $sword_sheath

func _ready():
	animation_player = $AnimationPlayer

var	peace_transform = Transform2D(deg2rad(-110),Vector2(0,1))
var	engaged_transform = Transform2D(deg2rad(120),Vector2(0,0))
var sheath_engaged_transform =Transform2D(deg2rad(-120),Vector2(3.5,-1))

var sheath_remote:RemoteTransform2D
var sword_right_remote:RemoteTransform2D
var sword_left_remote:RemoteTransform2D

func _on_to_state(s):
	
	match s:
		StandarCharactor.CharactorState.Peace:
			sword_right_hand.z_index = 0
			sword_sheath.z_index = 1
			sheath_remote.transform = peace_transform
			sword_right_remote.remote_path = ""
			sword_left_remote.transform = peace_transform
			sword_left_remote.remote_path = sword_left_remote.get_path_to(sword_right_hand)
		StandarCharactor.CharactorState.Engaged:
			sword_right_hand.z_index = 12
			sword_right_remote.transform = engaged_transform
			sheath_remote.transform = sheath_engaged_transform
			sword_left_remote.remote_path = ""
			sword_right_remote.remote_path = sword_right_remote.get_path_to(sword_right_hand)
			
func on_add_to_charactor(_charactor:StandarCharactor):

	sheath_remote = RemoteTransform2D.new()
	_charactor.add_to_body(StandarCharactor.CharactorBodySlotEnum.Left_Weapon , sheath_remote )
	sheath_remote.remote_path = sheath_remote.get_path_to(sword_sheath)
	
	sword_right_remote = RemoteTransform2D.new()
	_charactor.add_to_body(StandarCharactor.CharactorBodySlotEnum.Right_Weapon , sword_right_remote )
	sword_right_remote.remote_path = sword_right_remote.get_path_to(sword_right_hand)
	
	sword_left_remote = RemoteTransform2D.new()
	_charactor.add_to_body(StandarCharactor.CharactorBodySlotEnum.Left_Weapon , sword_left_remote )
	sword_left_remote.remote_path = sword_left_remote.get_path_to(sword_right_hand)
	
	pass
func on_remove_from_charactor(_charactor:StandarCharactor):
	sheath_remote.get_parent().remove_child(sheath_remote)
	sword_right_remote.get_parent().remove_child(sword_right_remote)
	sword_left_remote.get_parent().remove_child(sword_left_remote)
	
	if _cached_anim_2_id.size()>0:
		
		var anim_array = _animated_charactor.chosed_animation_player.get_animation_list()
		
		for anim in anim_array:
			
			if animation_player.has_animation(anim):
				var prepared_animation = _animated_charactor.chosed_animation_player.get_animation(anim)
				#1 在源animationplayer上 名称为 anim 的动画 上新增一个 type_animation 的 track,获得返回的track id
				if _cached_anim_2_id.has(anim):
					var _track_id = _cached_anim_2_id[anim]
					print(prepared_animation.get_track_count())
					prepared_animation.remove_track(_track_id)
					print(prepared_animation.get_track_count())
		_cached_anim_2_id.clear()
	_animated_charactor.chosed_animation_player.clear_caches()
	_animated_charactor = null	
	
func set_sync_to_source():
	
	sheath_remote.remote_path = sheath_remote.get_path_to(sword_sheath)
	sheath_remote.update_position = true
	sheath_remote.update_rotation = true
	sheath_remote.update_scale = true
	
#	sword_right_remote.remote_path = sword_right_remote.get_path_to(sword_right_hand)
	sword_right_remote.update_position = true
	sword_right_remote.update_rotation = true
	sword_right_remote.update_scale = true

#	sword_left_remote.remote_path = sword_left_remote.get_path_to(sword_right_hand)
	sword_left_remote.update_position = true
	sword_left_remote.update_rotation = true
	sword_left_remote.update_scale = true
	
func set_unsync_to_source():
	
	sheath_remote.remote_path =""
	sheath_remote.update_position = false
	sheath_remote.update_rotation = false
	sheath_remote.update_scale = false
	
	sword_right_remote.remote_path =""
	sword_right_remote.update_position = false
	sword_right_remote.update_rotation = false
	sword_right_remote.update_scale = false
	
	
	sword_left_remote.remote_path =""
	sword_left_remote.update_position = false
	sword_left_remote.update_rotation = false
	sword_left_remote.update_scale = false
