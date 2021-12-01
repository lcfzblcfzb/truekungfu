extends Node2D
class_name BaseWu

var default_wuxue = WuxueMngClass.WuxueEnum.Fist

export( WuxueMngClass.WuxueEnum) var chosed_wuxue  = WuxueMngClass.WuxueEnum.Fist

var wuxue:BaseWuXue

export (NodePath) var FightComponentPath
var fight_component 

#测试时候使用
onready var debug_wuxue=$debug_wuxue

#缓存dict
var wuxue_cache_dict ={}

#获得当前正在运行中的动画名称
func get_current_animation_name():
	
	var current_node = get_animation_tree().get("parameters/sm/playback") as AnimationNodeStateMachinePlayback
	
	return current_node.get_current_node()

#通过type在 wuxue_cache_dict 中查找队应的wuxue
func get_or_create_wuxue(type):
	
	if wuxue_cache_dict.has(type):
		return wuxue_cache_dict.get(type)
	else:
		var newWuxue = WuxueMng.get_by_type(type);
		if wuxue !=null && !newWuxue.resource_path.empty() && newWuxue.resource_path == wuxue.filename:
			return null;
		
		var instance = newWuxue.instance()
		wuxue_cache_dict[type]=instance
		return instance

func _ready():
	fight_component = get_node(FightComponentPath)
	_init_wu(chosed_wuxue)
#	call_deferred("switch_wu",chosed_wuxue)


func get_fight_controller()->BaseFightActionController:
	
	return null
	pass

func get_texture():
	
	var texture = load(wuxue.wu_animation_res)
	return texture

func get_behavior_tree():
	return wuxue.behaviourTree

func get_animation_tree()->AnimationTree:
	
	return wuxue.animation_tree
	pass
	
# TODO 在ready的时候，设置wuxue 的fight_component
func _init_wu(type= WuxueMng.WuxueEnum.Fist):
	
	if wuxue:
		wuxue.animation_tree.active = false
	
	if debug_wuxue and debug_wuxue.visible == true:
		
		wuxue = debug_wuxue
#		fight_component.sprite.texture = get_texture()
		debug_wuxue.fight_cpn =fight_component
		pass
	else :
	
		var newwuxue = get_or_create_wuxue(type) 
		if newwuxue:
			
			newwuxue.fight_cpn = fight_component
			add_child(newwuxue)
			wuxue = newwuxue

func switch_wu(type= WuxueMng.WuxueEnum.Fist):
	if wuxue:
		wuxue.animation_tree.active = false
	
	if debug_wuxue and debug_wuxue.visible == true:
		
		wuxue = debug_wuxue
		fight_component.sprite.texture = get_texture()
		debug_wuxue.fight_cpn =fight_component
		pass
	else :
	
		var newwuxue = get_or_create_wuxue(type) 
		if newwuxue:
			
			newwuxue.fight_cpn = fight_component
			add_child(newwuxue)
			wuxue = newwuxue
			wuxue.animation_player.root_node = wuxue.animation_player.get_path_to(fight_component.sprite.get_parent())
			fight_component.sprite.texture = get_texture()
			wuxue.animation_tree.active = true
		
func on_player_event(new_motion:NewActionEvent):
	wuxue.on_action_event(new_motion)

func on_move_event(new_motion:MoveEvent):
	
	wuxue.on_move_event(new_motion)
	

func on_ai_event(new_motion:AIEvent):
	wuxue.on_ai_event(new_motion)
	pass

func _on_FightController_NewFightMotion(new_motion:BaseFightEvent):
	if new_motion is MoveEvent:
		on_move_event(new_motion)
	elif new_motion is NewActionEvent:
		on_player_event(new_motion)
	elif new_motion is AIEvent:
		on_ai_event(new_motion)
	pass

