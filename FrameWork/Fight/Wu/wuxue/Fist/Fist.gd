class_name Fist
extends WuXue

const FistBehaviorTree =preload("res://FrameWork/Fight/Wu/wuxue/behavior_tree/fist/FistNormalBehaveTree.tscn")

static func get_wuxue_type():
	return Glob.WuxueEnum.Sanjiaomao

func _ready():
	
	wuxue_state_machine = WuxueStateMachineScene.instance()
	behaviourTree =  FistBehaviorTree.instance()
	behaviourTree._agent = fight_cpn.get_path()
	blackboard = $Blackboard
	behaviourTree._blackboard = blackboard.get_path()
	
	add_child(behaviourTree)
#	yield(get_tree().create_timer(3),"timeout")
#	var animationPlayer = preload("res://FightAnimationPlayer.tscn").instance() as AnimationPlayer
#	add_child(animationPlayer)
#	animationPlayer.root_node = animationPlayer.get_path_to(sprite)
#	animationPlayer.play("idle")

#func on_action_event(event:NewActionEvent):
#
#	#是否是重攻击；若不是 ，则以最后的位置作为轻攻击的方向(攻击);
#	var is_heavy = false if event.action_end_time-event.action_begin_time< heavyAttackThreshold else true
#
#	if wuxue_state_machine.check_state_can_go(event.wu_motion,event):
#		WuxueEventHandlerTools.normal_on_action_event(event.wu_motion,is_heavy,fight_cpn)
#
#func on_move_event(event:MoveEvent):
#	WuxueEventHandlerTools.normal_on_moveevent(event,fight_cpn)
#
#
#func on_ai_event(event:AIEvent):
#	WuxueEventHandlerTools.normal_on_action_event(event.action_id,false,fight_cpn)


#animation_player组件的回调
func animation_call_method(param):
	pass
