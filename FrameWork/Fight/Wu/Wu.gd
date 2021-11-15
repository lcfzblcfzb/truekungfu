extends Node2D
class_name BaseWu

export(GDScript) var WuXueClass
var wuxue:BaseWuXue

export (NodePath) var FightComponentPath
var fight_component :FightComponent_human


func _ready():
	fight_component = get_node(FightComponentPath)
	
	if WuXueClass:
		wuxue = WuXueClass.new(fight_component)
	else:
		wuxue = load("res://FrameWork/Fight/Wu/weapon/Sword.gd").new(fight_component)

func switch_wu(type):
	
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

