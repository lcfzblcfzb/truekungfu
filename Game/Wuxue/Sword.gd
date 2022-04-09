class_name Sword
extends WuXue

static func get_wuxue_type():
	return Glob.WuxueEnum.Taijijian

func _ready():
	behaviourTree =  $SwordBehaviorTree
	blackboard = $Blackboard
#	animation_player.root_node = animation_player.get_path_to(fight_cpn.sprite.get_parent())
#	$AnimationTree.active = true
	pass

func on_action_event(event:NewActionEvent):
	
	#是否是重攻击；若不是 ，则以最后的位置作为轻攻击的方向(攻击);
	var is_heavy = false if event.action_end_time-event.action_begin_time< heavyAttackThreshold else true
	
	WuxueEventHandlerTools.normal_on_action_event(event.wu_motion,is_heavy,fight_cpn)
	
func on_move_event(event:MoveEvent):
	
	WuxueEventHandlerTools.normal_on_moveevent(event,fight_cpn)
	
	
func on_ai_event(event:AIEvent):
	WuxueEventHandlerTools.normal_on_action_event(event.wu_motion,false,fight_cpn)

#与另一个wuxue 发生战斗
func against_wuxue(otherWuxue:WuXue):
	
	var fighter0 = fight_cpn
	var fighter1 = otherWuxue.fight_cpn
	
	var anim0 = fighter0.wu.get_current_animation_name()
	var anim1 = fighter1.wu.get_current_animation_name()
	
	var base_id_0 = FightBaseActionDataSource.get_by_anim_name(anim0)
	var base_id_1 = FightBaseActionDataSource.get_by_anim_name(anim1)
	
	var baseWuxueAction0 = BaseWuXueActionMng.get_by_wuxue_and_action(fighter0.wu.chosed_wuxue,  base_id_0.id) as BaseWuxueAction
	var baseWuxueAction1 = BaseWuXueActionMng.get_by_wuxue_and_action(fighter1.wu.chosed_wuxue,  base_id_1.id) as BaseWuxueAction
	if otherWuxue.is_class(get_class()):
		SwordCourt.sword_sword(fighter0,fighter1,baseWuxueAction0.action_force_type,baseWuxueAction1.action_force_type)
	elif otherWuxue is Fist:
		SwordCourt.sword_fist(fighter0,fighter1,baseWuxueAction0.action_force_type,baseWuxueAction1.action_force_type)
	pass

#战斗裁决--剑
class SwordCourt:
	extends FightCourt
	
	static func sword_sword(fighter0:FightComponent_human,fighter1:FightComponent_human,action_force_type0,action_force_type1):
		
#		normal_judge(fighter0,fighter1,action_force_type0,action_force_type1)
		
		pass
		
	static func sword_fist(fighter0:FightComponent_human,fighter1:FightComponent_human,action_force_type0,action_force_type1):
		
#		normal_judge(fighter0,fighter1,action_force_type0,action_force_type1)
		pass
	
		

func _on_Detector_body_entered(body):
	fight_cpn.is_engaged = true


#animation_player组件的回调
func animation_call_method(param):
	pass
