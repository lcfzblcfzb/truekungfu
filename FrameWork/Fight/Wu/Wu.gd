extends Node2D
class_name BaseWu

var default_wuxue = WuxueMng.WuxueEnum.Fist

export( WuxueMngClass.WuxueEnum) var chosed_wuxue  = WuxueMng.WuxueEnum.Fist

var wuxue:BaseWuXue

export (NodePath) var FightComponentPath
var fight_component :FightComponent_human

#缓存dict
var wuxue_cache_dict ={}

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
	
	call_deferred("switch_wu",chosed_wuxue)
	
func get_texture():
	
	var texture = load(wuxue.wu_animation_res)
	return texture

func get_animation_tree():
	
	return wuxue.animation_tree
	pass
	
func switch_wu(type= WuxueMng.WuxueEnum.Fist):
	if wuxue:
		wuxue.animation_tree.active = false
		
	var newwuxue = get_or_create_wuxue(type)
	
	if newwuxue:
		newwuxue.fight_cpn = fight_component
		add_child(newwuxue)
		wuxue = newwuxue
		wuxue.animation_player.root_node = wuxue.animation_player.get_path_to(fight_component.sprite.get_parent())
		fight_component.sprite.texture = get_texture()
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

