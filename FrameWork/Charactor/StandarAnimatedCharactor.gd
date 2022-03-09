class_name StandarAnimatedCharactor
extends Node2D

var daoshi_scn = preload("res://FrameWork/Charactor/standar_charactors/DaoshiStandar.tscn")
var rusheng_scn = preload("res://FrameWork/Charactor/standar_charactors/RushengStandar.tscn")

onready var charactor_scene:StandarCharactor = $hip

var chosed_animation_player:AnimationPlayer

func _ready():
	chosed_animation_player = $AnimationPlayers/AnimationPlayer
	_check_dependency()
	$AnimationTree.active = true
	pass

func choose_charactor(c,animation_node):
	
	if charactor_scene.charactor_type == c:
		return 
	
	if charactor_scene!= null :
		remove_child(charactor_scene)
		charactor_scene.queue_free()
	
	match c:
		Tool.CharactorEnum.Rusheng:
			charactor_scene = rusheng_scn.instance()
			charactor_scene.set("animation_node",animation_node)
			add_child(charactor_scene)
			
		Tool.CharactorEnum.Daoshi:
			charactor_scene = daoshi_scn.instance()
			charactor_scene.set("animation_node",animation_node)
			add_child(charactor_scene)
	
	_check_dependency()
	
func choose_coresponding_wuxue(wuxue:BaseWuXue):
	
	match wuxue.get_wuxue_type() :
		WuxueMng.WuxueEnum.Fist:
			chosed_animation_player = $AnimationPlayers/AnimationPlayer_Fist
		WuxueMng.WuxueEnum.Sword:
			chosed_animation_player = $AnimationPlayers/AnimationPlayer_Sword
		_:
			chosed_animation_player = $AnimationPlayers/AnimationPlayer
	
	_check_dependency()
	$AnimationTree.active = true
	
	#武器 的 外形 在此初始化
	if wuxue.weapon_path:
		var weapon = load(wuxue.weapon_path).instance() as Weapon
		wuxue._gear_cache.append(weapon)
		charactor_scene.add_gear(weapon)

		charactor_scene.state = StandarCharactor.CharactorState.Peace
		weapon.repath_to_animation_charactor(self)
		
func get_coresponding_animation_tree():
	return $AnimationTree

func _check_dependency():
	chosed_animation_player.root_node = chosed_animation_player.get_path_to(charactor_scene)
	$AnimationTree.anim_player = $AnimationTree.get_path_to(chosed_animation_player)
	pass

func set_state(s):
	charactor_scene.state =s

func get_standar_charactor()->StandarCharactor:
	return charactor_scene
