class_name StandarAnimatedCharactor
extends Node2D

var daoshi_scn = preload("res://FrameWork/Charactor/standar_charactors/DaoshiStandar.tscn")
var rusheng_scn = preload("res://FrameWork/Charactor/standar_charactors/RushengStandar.tscn")
var fatguy_scn = preload("res://FrameWork/Charactor/standar_charactors/FatGuy.tscn")
var normal_standar = preload("res://FrameWork/Charactor/standar_charactors/NormalStandar.tscn")

onready var charactor_scene:StandarCharactor = $standar_charactor

var chosed_animation_player:AnimationPlayer 

# wuxue -> { animation_name-> Animation }
var _wuxue_2_animations_map={}

var fight_cpn

var appearance_node

func _ready():
	chosed_animation_player= $CharactorAnimationPlayers/AnimationPlayer
#	_cache_animations()
	_check_dependency()
	$AnimationTree.active = true


#animationPlayer中 由call_method_track 调用的方法
#做一个代理调用方法
func animation_call_method(args1):
	appearance_node.emit_signal("AnimationCallMethod",args1)	
	charactor_scene.change_gear_state(args1)

#将动画resource取出缓存起来
func _cache_animations():
	
	var base_charactor = BaseStandarCharactorsDMG.get_by_id(charactor_scene.charactor_type)
	
	for wuxue in Glob.WuxueEnum:
		var animationplayer = _get_animationplayer_by_type(wuxue,base_charactor.skeletal_type)
		
		var _wuxue_id =Glob.WuxueEnum[wuxue]
		var anim_dict = {}
		for animation in animationplayer.get_animation_list():
			anim_dict[animation] = animationplayer.get_animation(animation)
		_wuxue_2_animations_map[_wuxue_id] = anim_dict
		
#将缓存的动画资源加载到  playeragent
func copy_2_animation_agent(wuxue):
	
	if !_wuxue_2_animations_map.has(wuxue):
		return
	
	for _animation in $AnimationPlayerAgent.get_animation_list():
		$AnimationPlayerAgent.remove_animation(_animation)
		
	var animation_dict = _wuxue_2_animations_map.get(wuxue)
	
	for animation in animation_dict:
		$AnimationPlayerAgent.add_animation(animation,animation_dict[animation].duplicate(true))

func _debug_animation_player(animationPlayer:AnimationPlayer):
	
	for anim in animationPlayer.get_animation_list():
		print("animation name"+anim+" ; animation node:"+ animationPlayer.get_animation(anim).resource_name)

#Glob.CharactorEnum
func choose_charactor(c,animation_node):
	
	if charactor_scene!= null :
		remove_child(charactor_scene)
		charactor_scene.queue_free()
	
	appearance_node = animation_node
	
	match c:
		Glob.CharactorEnum.Rusheng:
			charactor_scene = rusheng_scn.instance()
			charactor_scene.set("animation_node",animation_node)
			charactor_scene.charactor_type = c
			add_child(charactor_scene)
			
		Glob.CharactorEnum.Daoshi:
			charactor_scene = daoshi_scn.instance()
			charactor_scene.set("animation_node",animation_node)
			charactor_scene.charactor_type = c
			add_child(charactor_scene)
			
		Glob.CharactorEnum.Fatguy:
			charactor_scene = fatguy_scn.instance()
			charactor_scene.set("animation_node",animation_node)
			charactor_scene.charactor_type = c
			add_child(charactor_scene)
			
		Glob.CharactorEnum.NormalStandar:
			charactor_scene = normal_standar.instance()
			charactor_scene.set("animation_node",animation_node)
			charactor_scene.charactor_type = c
			add_child(charactor_scene)
	
	_check_dependency()

func _get_animationplayer_by_type(wuxue , skeletkal_type):
	
	for animation_player in $CharactorAnimationPlayers.get_children():
		
		if animation_player.wuxue_id == wuxue and animation_player.skelekal_type == skeletkal_type:
			return animation_player
			
	return $CharactorAnimationPlayers/AnimationPlayer

# 选择wuxue 对应的 animationplayer(charactor的）
func choose_coresponding_animation(wuxue:WuXue):
	
	$AnimationTree.active = false
	
	$AnimationTree.set_script(wuxue.animation_tree_script)
	$AnimationTree.tree_root = 	wuxue.animation_tree_root_node
	
	var base_charactor = BaseStandarCharactorsDMG.get_by_id(charactor_scene.charactor_type)
	if !base_charactor:
		return
	
	chosed_animation_player = _get_animationplayer_by_type(wuxue.get_wuxue_type(),base_charactor.skeletal_type)
	_check_dependency()
	chosed_animation_player.emit_signal("caches_cleared")
	
	$AnimationTree.set_deferred("active",true)
		
func get_coresponding_animation_tree():
	return $AnimationTree

func _check_dependency():
	chosed_animation_player.root_node = chosed_animation_player.get_path_to(charactor_scene.get_animation_root())
	$AnimationTree.anim_player = $AnimationTree.get_path_to(chosed_animation_player)

func set_state(s):
	charactor_scene.state =s

func get_standar_charactor()->StandarCharactor:
	return charactor_scene
