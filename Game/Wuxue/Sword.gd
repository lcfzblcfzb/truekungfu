class_name Sword
extends WuXue

static func get_wuxue_type():
	return Glob.WuxueEnum.Sword

func _init():
	weapon_path = "res://FrameWork/Gear/Weapon/SwordPrototype.tscn"

func _ready():
	wu_animation_res = "res://texture/animation/demo_motion_template-Sheet_def.png"
	animation_tree = $AnimationTree
	behaviourTree =  $SwordBehaviorTree
	blackboard = $Blackboard
#	animation_player.root_node = animation_player.get_path_to(fight_cpn.sprite.get_parent())
#	$AnimationTree.active = true
	pass

func _do_wu_motion(wu_motion,is_heavy):
	var global_id = fight_cpn.actionMng.next_group_id()
	
	match( wu_motion):
		
		Glob.WuMotion.Stunned:
			var base = FightBaseActionDataSource.get_by_id(Glob.FightMotion.Stunned) as BaseAction
			fight_cpn.actionMng.regist_action(Glob.FightMotion.Stunned,base.duration,ActionInfo.EXEMOD_INTERUPT)
			pass
			
		Glob.WuMotion.Prepared:
			fight_cpn.is_prepared = true
		
		Glob.WuMotion.Unprepared:
			fight_cpn.is_prepared = false
		
		Glob.WuMotion.Hanging:
			var base = FightBaseActionDataSource.get_by_id(Glob.FightMotion.Hanging) as BaseAction
			fight_cpn.actionMng.regist_action(wu_motion,base.duration,ActionInfo.EXEMOD_INTERUPT)
			pass
		
		Glob.WuMotion.HangingClimb:
			var base = FightBaseActionDataSource.get_by_id(Glob.FightMotion.HangingClimb) as BaseAction
			fight_cpn.actionMng.regist_action(wu_motion,base.duration,ActionInfo.EXEMOD_INTERUPT)
			pass
		
		Glob.WuMotion.Attack:
			if fight_cpn.is_prepared == false:
				fight_cpn.is_prepared = true
			var base = FightBaseActionDataSource.get_by_id(Glob.FightMotion.Attack) as BaseAction
			fight_cpn.actionMng.regist_action(Glob.FightMotion.Attack,base.duration,ActionInfo.EXEMOD_INTERUPT)
		
		Glob.WuMotion.Switch:
			
			fight_cpn.switch_weapon(0,Glob.WuxueEnum.Fist)
			pass
		Glob.WuMotion.Attack_Up:
			if is_heavy:
				var a_list =_create_attack_action([Glob.FightMotion.HeavyAttack_U_Pre,Glob.FightMotion.HeavyAttack_U_In,Glob.FightMotion.HeavyAttack_U_After])
				fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
			else:
				var a_list =_create_attack_action([Glob.FightMotion.Attack_Up_Pre,Glob.FightMotion.Attack_Up_In,Glob.FightMotion.Attack_Up_After])
				fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
		Glob.WuMotion.Attack_Mid:
			if is_heavy:
				var a_list =_create_attack_action([Glob.FightMotion.HeavyAttack_M_Pre,Glob.FightMotion.HeavyAttack_M_In,Glob.FightMotion.HeavyAttack_M_After])
				fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
			else:
				var a_list =_create_attack_action([Glob.FightMotion.Attack_Mid_Pre,Glob.FightMotion.Attack_Mid_In,Glob.FightMotion.Attack_Mid_After])
				fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
		Glob.WuMotion.Attack_Bot:
			if is_heavy:
				var a_list =_create_attack_action([Glob.FightMotion.HeavyAttack_B_Pre,Glob.FightMotion.HeavyAttack_B_In,Glob.FightMotion.HeavyAttack_B_After])
				fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
			else:
				var a_list =_create_attack_action([Glob.FightMotion.Attack_Bot_Pre,Glob.FightMotion.Attack_Bot_In,Glob.FightMotion.Attack_Bot_After])
				fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
		Glob.WuMotion.Defend_Up:
			var a_list =_create_attack_action([Glob.FightMotion.Def_Up_Pre,Glob.FightMotion.Def_Up_In,Glob.FightMotion.Def_Up_After])
			fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
		Glob.WuMotion.Defend_Mid:
			var a_list =_create_attack_action([Glob.FightMotion.Def_Mid_Pre,Glob.FightMotion.Def_Mid_In,Glob.FightMotion.Def_Mid_After])
			fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
		Glob.WuMotion.Defend_Bot:
			var a_list =_create_attack_action([Glob.FightMotion.Def_Bot_Pre,Glob.FightMotion.Def_Bot_In,Glob.FightMotion.Def_Bot_After])
			fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
		Glob.WuMotion.Attack_U2M:
			if is_heavy:
				var a_list =_create_attack_action([Glob.FightMotion.HeavyAttack_U2M_Pre,Glob.FightMotion.HeavyAttack_U2M_In,Glob.FightMotion.HeavyAttack_U2M_After])
				fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
			else:
				var a_list =_create_attack_action([Glob.FightMotion.HeavyAttack_M_Pre,Glob.FightMotion.HeavyAttack_M_In,Glob.FightMotion.HeavyAttack_M_After])
				fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
		Glob.WuMotion.Attack_U2B:
			if is_heavy:
				var a_list =_create_attack_action([Glob.FightMotion.HeavyAttack_U2B_Pre,Glob.FightMotion.HeavyAttack_U2B_In,Glob.FightMotion.HeavyAttack_U2B_After])
				fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
			else:
				var a_list =_create_attack_action([Glob.FightMotion.Attack_Bot_Pre,Glob.FightMotion.Attack_Bot_In,Glob.FightMotion.Attack_Bot_After])
				fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
		Glob.WuMotion.Attack_M2U:
			if is_heavy:
				var a_list =_create_attack_action([Glob.FightMotion.HeavyAttack_M2U_Pre,Glob.FightMotion.HeavyAttack_M2U_In,Glob.FightMotion.HeavyAttack_M2U_After])
				fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
			else:
				var a_list =_create_attack_action([Glob.FightMotion.Attack_Up_Pre,Glob.FightMotion.Attack_Up_In,Glob.FightMotion.Attack_Up_After])
				fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
		Glob.WuMotion.Attack_M2B:
			if is_heavy:
				var a_list =_create_attack_action([Glob.FightMotion.HeavyAttack_M2B_Pre,Glob.FightMotion.HeavyAttack_M2B_In,Glob.FightMotion.HeavyAttack_M2B_After])
				fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
			else:
				var a_list =_create_attack_action([Glob.FightMotion.Attack_Bot_Pre,Glob.FightMotion.Attack_Bot_In,Glob.FightMotion.Attack_Bot_After])
				fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
		Glob.WuMotion.Attack_B2U:
			if is_heavy:
				var a_list =_create_attack_action([Glob.FightMotion.HeavyAttack_B2U_Pre,Glob.FightMotion.HeavyAttack_B2U_In,Glob.FightMotion.HeavyAttack_B2U_After])
				fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
			else:
				var a_list =_create_attack_action([Glob.FightMotion.Attack_Up_Pre,Glob.FightMotion.Attack_Up_In,Glob.FightMotion.Attack_Up_After])
				fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
		Glob.WuMotion.Attack_B2M:
			if is_heavy:
				var a_list =_create_attack_action([Glob.FightMotion.HeavyAttack_B2M_Pre,Glob.FightMotion.HeavyAttack_B2M_In,Glob.FightMotion.HeavyAttack_B2M_After])
				fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
			else:
				var a_list =_create_attack_action([Glob.FightMotion.HeavyAttack_M_Pre,Glob.FightMotion.HeavyAttack_M_In,Glob.FightMotion.HeavyAttack_M_After])
				fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
	


func on_action_event(event:NewActionEvent):
	
	#是否是重攻击；若不是 ，则以最后的位置作为轻攻击的方向(攻击);
	var is_heavy = false if event.action_end_time-event.action_begin_time< heavyAttackThreshold else true
	
	_do_wu_motion(event.wu_motion,is_heavy)
	
func on_move_event(event:MoveEvent):
	
	WuxueEventHandlerTools.normal_on_moveevent(event,fight_cpn)
	
	
func on_ai_event(event:AIEvent):
	_do_wu_motion(event.action_id,false)


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
		
		normal_judge(fighter0,fighter1,action_force_type0,action_force_type1)
		
		pass
		
	static func sword_fist(fighter0:FightComponent_human,fighter1:FightComponent_human,action_force_type0,action_force_type1):
		
		normal_judge(fighter0,fighter1,action_force_type0,action_force_type1)
		pass
	
		

func _on_Detector_body_entered(body):
	fight_cpn.is_engaged = true


#animation_player组件的回调
func animation_call_method(param):
	pass
