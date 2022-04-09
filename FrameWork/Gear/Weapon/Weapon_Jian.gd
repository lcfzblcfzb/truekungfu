extends Weapon

#onready var sword_left_hand = $sword_left_hand
onready var sword_right_hand = $sword_right_hand
onready var sword_sheath = $sword_sheath

var	peace_transform = Transform2D(deg2rad(-110),Vector2(0,1))
var	engaged_transform = Transform2D(deg2rad(120),Vector2(0,0))
var sheath_engaged_transform =Transform2D(deg2rad(-120),Vector2(3.5,-1))

var sheath_remote:RemoteTransform2D
var sword_right_remote:RemoteTransform2D
var sword_left_remote:RemoteTransform2D

func _init():
	
	pass

func init(base_gear:BaseGear,fcpn:FightComponent_human):
	.init(base_gear,fcpn)
	var size = base_gear.resourcePaths.size()
	
	if size>=2:
		sword_right_hand.texture = load(base_gear.resourcePaths[0])
		sword_sheath.texture = load(base_gear.resourcePaths[1])

func on_active(a):
	
	if a:
		sword_right_hand.visible = true
		sword_sheath.visible = true
	else:
		sword_right_hand.visible = false
		sword_sheath.visible = false
		getWeaponBox().monitoring = false

func init_state():
	
	getWeaponBox().monitoring=false
	
	if get_fight_cpn().camp == Glob.CampEnum.Bad:
		#设置武器碰撞检测层
		getWeaponBox().collision_layer =	 0b0100
		getWeaponBox().collision_mask = 	 0b0010
	elif get_fight_cpn().camp == Glob.CampEnum.Good:
		#设置武器碰撞检测层
		getWeaponBox().collision_layer	= 0b0001
		getWeaponBox().collision_mask 	=  0b1000

func get_animation_player():
	return $AnimationPlayer
	
func getWeaponBox():
	return $weaponBox

func _on_to_state(s):
	
	match s:
		StandarCharactor.CharactorState.Peace:
			sword_right_hand.z_index = 0
			sword_sheath.z_index = 1
#			sheath_remote.transform = peace_transform
			sword_right_remote.remote_path = ""
#			sword_left_remote.transform = peace_transform
			sword_left_remote.remote_path = sword_left_remote.get_path_to(sword_right_hand)
		StandarCharactor.CharactorState.Engaged:
			sword_right_hand.z_index = 12
#			sword_right_remote.transform = engaged_transform
#			sheath_remote.transform = sheath_engaged_transform
			sword_left_remote.remote_path = ""
			sword_right_remote.remote_path = sword_right_remote.get_path_to(sword_right_hand)
			
func on_add_to_charactor():
	
	init_state()
	
	var _charactor = get_fight_cpn().sprite_animation.get_standar_charactor()
	sheath_remote = RemoteTransform2D.new()
	_charactor.add_to_body(StandarCharactor.CharactorBodySlotEnum.Left_Weapon , sheath_remote )
	sheath_remote.remote_path = sheath_remote.get_path_to(sword_sheath)
	
	sword_right_remote = RemoteTransform2D.new()
	_charactor.add_to_body(StandarCharactor.CharactorBodySlotEnum.Right_Weapon , sword_right_remote )
	sword_right_remote.remote_path = sword_right_remote.get_path_to(sword_right_hand)
	
	sword_left_remote = RemoteTransform2D.new()
	_charactor.add_to_body(StandarCharactor.CharactorBodySlotEnum.Left_Weapon , sword_left_remote )
	sword_left_remote.remote_path = sword_left_remote.get_path_to(sword_right_hand)
	
func on_remove_from_charactor():
	sheath_remote.get_parent().remove_child(sheath_remote)
	sword_right_remote.get_parent().remove_child(sword_right_remote)
	sword_left_remote.get_parent().remove_child(sword_left_remote)
	
	sheath_remote.queue_free()
	sword_right_remote.queue_free()
	sword_left_remote.queue_free()
		
	queue_free()
	
func set_sync_to_source():
	
	sheath_remote.remote_path = sheath_remote.get_path_to(sword_sheath)
	sheath_remote.update_position = true
	sheath_remote.update_rotation = true
	sheath_remote.update_scale = true
	
#	sword_right_remote.remote_path = sword_right_remote.get_path_to(sword_right_hand)
	if state ==StandarCharactor.CharactorState.Engaged:
		sword_right_remote.remote_path = sword_right_remote.get_path_to(sword_right_hand)
	sword_right_remote.update_position = true
	sword_right_remote.update_rotation = true
	sword_right_remote.update_scale = true
	
	if state ==StandarCharactor.CharactorState.Peace:
		sword_left_remote.remote_path = sword_left_remote.get_path_to(sword_right_hand)
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

func on_actioninfo_start(action:ActionInfo):
	
	if active:
		
		if action.base_action == Glob.FightMotion.Prepared:
			
			get_animation_player().play("prepared")
		elif action.base_action == Glob.FightMotion.Unprepared:
			get_animation_player().play("unprepared")
#		elif action.base_action == Glob.FightMotion.Attack_Ci:
#	#		set_unsync_to_source()
#	#		print(action.action_duration_ms/1000.0)
#			getWeaponBox().damage_type = Glob.DamageType.Ci
#			get_animation_player().play("attack",-1,1000/action.action_duration_ms)
#			get_animation_player().advance(0)
#
#		elif action.base_action == Glob.FightMotion.Attack_Sao:
#	#		set_unsync_to_source()
#	#		print(action.action_duration_ms/1000.0)
#			getWeaponBox().damage_type = Glob.DamageType.Sao
#			get_animation_player().play("attack",-1,1000/action.action_duration_ms)
#			get_animation_player().advance(0)
#
#		elif action.base_action == Glob.FightMotion.Attack_Pi:
#	#		set_unsync_to_source()
#	#		print(action.action_duration_ms/1000.0)
#			getWeaponBox().damage_type = Glob.DamageType.Pi
#			get_animation_player().play("attack",-1,1000/action.action_duration_ms)
#			get_animation_player().advance(0)
		
		else:
			set_sync_to_source()
	pass
func on_actioninfo_end(action:ActionInfo):
	if active:
		if action.base_action == Glob.FightMotion.Attack_Ci:
			set_sync_to_source()
#		getWeaponBox().stop_monitoring()
