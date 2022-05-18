extends Panel

onready var tween= $Tween
onready var label_action = $Action

func UI_action_start(action_info:ActionInfo):
	label_action.rect_position.x= 0
	label_action.text = action_info.base_action as String
	tween.interpolate_property(label_action,"rect_position",Vector2.ZERO,Vector2(rect_size.x ,0),action_info.action_duration_ms/1000)
	tween.start()
	pass

func UI_action_end(action_info:ActionInfo):
	label_action.rect_position.x= rect_size.x 
	pass

func _on_FightActionMng_ActionStart(action_info):
	
	UI_action_start(action_info)
	pass # Replace with function body.


func _on_FightActionMng_ActionFinish(action_info):
	
	UI_action_end(action_info)
	pass # Replace with function body.
