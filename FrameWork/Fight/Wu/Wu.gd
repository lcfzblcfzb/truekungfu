extends Node2D
class_name BaseWu

#var default_wuxue = preload("res://FrameWork/Fight/Wu/weapon/WU_Sword.tscn")

var default_wuxue = preload("res://FrameWork/Fight/Wu/weapon/WU_Fist.tscn")

export(NodePath) var WuXuePath
var wuxue:BaseWuXue

export (NodePath) var FightComponentPath
var fight_component :FightComponent_human


func _ready():
	fight_component = get_node(FightComponentPath)
	
	if WuXuePath:
		wuxue = get_node(WuXuePath)
	else:
		wuxue= default_wuxue.instance()
	
	wuxue.fight_cpn = fight_component
	add_child(wuxue)

func get_texture():
	
	var texture = load(wuxue.wu_animation_res)
	return texture

func get_animation_tree():
	
	return wuxue.animation_tree
	pass
	
func switch_wu(type=1):
	match type:
		1:
			wuxue.animation_tree.active = false
			var scene = load("res://FrameWork/Fight/Wu/weapon/WU_Sword.tscn")
			var newwuxue = scene.instance()
			newwuxue.fight_cpn = fight_component
			add_child(newwuxue)
			wuxue = newwuxue
			wuxue.animation_player.root_node = wuxue.animation_player.get_path_to(fight_component.sprite.get_parent())
			wuxue.animation_tree.active = true
		2:
			wuxue.animation_tree.active = false
			var scene = load("res://FrameWork/Fight/Wu/weapon/WU_Fist.tscn")
			var newwuxue = scene.instance()
			newwuxue.fight_cpn = fight_component
			add_child(newwuxue)
			wuxue = newwuxue
			wuxue.animation_player.root_node = wuxue.animation_player.get_path_to(fight_component.sprite.get_parent())
			wuxue.animation_tree.active = true

pass

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

