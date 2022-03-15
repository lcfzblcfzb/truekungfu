class_name StandarAnimatedCharactor
extends Node2D

var daoshi_scn = preload("res://FrameWork/Charactor/standar_charactors/DaoshiStandar.tscn")
var rusheng_scn = preload("res://FrameWork/Charactor/standar_charactors/RushengStandar.tscn")
var fatguy_scn = preload("res://FrameWork/Charactor/standar_charactors/FatGuy.tscn")

onready var charactor_scene:StandarCharactor = $hip

var chosed_animation_player:AnimationPlayer 

# wuxue -> { animation_name-> Animation }
var _wuxue_2_animations_map={}

var fight_cpn

func _ready():
	chosed_animation_player= $AnimationPlayers/AnimationPlayer
#	_cache_animations()
	_check_dependency()
	$AnimationTree.active = true
#将动画resource取出缓存起来
func _cache_animations():
	
	var base_charactor = BaseStandarCharactorsDMG.get_by_id(charactor_scene.charactor_type)
	
	for wuxue in WuxueMng.WuxueEnum:
		var animationplayer = _get_animationplayer_by_type(wuxue,base_charactor.skeletal_type)
		
		var _wuxue_id =WuxueMng.WuxueEnum[wuxue]
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

func choose_charactor(c,animation_node):
	
	if charactor_scene!= null :
		remove_child(charactor_scene)
		charactor_scene.queue_free()
	
	match c:
		Tool.CharactorEnum.Rusheng:
			charactor_scene = rusheng_scn.instance()
			charactor_scene.set("animation_node",animation_node)
			charactor_scene.charactor_type = c
			add_child(charactor_scene)
			
		Tool.CharactorEnum.Daoshi:
			charactor_scene = daoshi_scn.instance()
			charactor_scene.set("animation_node",animation_node)
			charactor_scene.charactor_type = c
			add_child(charactor_scene)
			
		Tool.CharactorEnum.Fatguy:
			charactor_scene = fatguy_scn.instance()
			charactor_scene.set("animation_node",animation_node)
			charactor_scene.charactor_type = c
			add_child(charactor_scene)
	
	_check_dependency()

func _get_animationplayer_by_type(wuxue , skeletkal_type):
	
	for animation_player in $AnimationPlayers.get_children():
		
		if animation_player.wuxue_id == wuxue and animation_player.skelekal_type == skeletkal_type:
			return animation_player
			
	return $AnimationPlayers/AnimationPlayer

# 1选择wuxue 对应的 animationplayer(charactor的）
# 2选择wuxue 对应的装备（武器) 装备到charactor 身上
func choose_coresponding_wuxue(wuxue:BaseWuXue):
	
	$AnimationTree.active = false
	
	var base_charactor = BaseStandarCharactorsDMG.get_by_id(charactor_scene.charactor_type)
	if !base_charactor:
		return
	
	#失效的方法： 在切换wuxue 的时候 会报错，动画不能准确切换
	chosed_animation_player = _get_animationplayer_by_type(wuxue.get_wuxue_type(),base_charactor.skeletal_type)
#	copy_2_animation_agent(wuxue.get_wuxue_type())
	_check_dependency()
	chosed_animation_player.emit_signal("caches_cleared")
	
	#武器 的 外形 在此初始化
	if wuxue.weapon_path:
		var weapon = load(wuxue.weapon_path).instance() as Weapon
		weapon.fight_cpn = fight_cpn
		
		wuxue._gear_cache.append(weapon)
		charactor_scene.add_gear(weapon)
		
		charactor_scene.state = StandarCharactor.CharactorState.Peace
#		weapon.repath_to_animation_charactor(self)
	$AnimationTree.set_deferred("active",true)
		
func get_coresponding_animation_tree():
	return $AnimationTree

func _check_dependency():
	chosed_animation_player.root_node = chosed_animation_player.get_path_to(charactor_scene)
	$AnimationTree.anim_player = $AnimationTree.get_path_to(chosed_animation_player)

func set_state(s):
	charactor_scene.state =s

func get_standar_charactor()->StandarCharactor:
	return charactor_scene
