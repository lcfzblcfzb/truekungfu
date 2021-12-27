class_name Sword
extends BaseWuXue

static func get_wuxue_type():
	return WuxueMng.WuxueEnum.Fist

func _ready():
	wu_animation_res = "res://texture/animation/demo_motion_template-Sheet_def.png"
	animation_player = $sword_animation
	animation_tree = $AnimationTree
	behaviourTree =  $SwordBehaviorTree
#	animation_player.root_node = animation_player.get_path_to(fight_cpn.sprite.get_parent())
#	$AnimationTree.active = true
	pass

func _do_wu_motion(wu_motion,is_heavy):
	var global_id = fight_cpn.actionMng.next_group_id()
	
	match( wu_motion):
		
		Tool.WuMotion.Stunned:
			var base = FightBaseActionDataSource.get_by_base_id(Tool.FightMotion.Stunned) as BaseAction
			fight_cpn.actionMng.regist_action(Tool.FightMotion.Stunned,base.duration,ActionInfo.EXEMOD_INTERUPT)
			pass
		
		Tool.WuMotion.Attack_Up:
			if is_heavy:
				var a_list =_create_attack_action([Tool.FightMotion.HeavyAttack_U_Pre,Tool.FightMotion.HeavyAttack_U_In,Tool.FightMotion.HeavyAttack_U_After])
				fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
			else:
				var a_list =_create_attack_action([Tool.FightMotion.Attack_Up_Pre,Tool.FightMotion.Attack_Up_In,Tool.FightMotion.Attack_Up_After])
				fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
		Tool.WuMotion.Attack_Mid:
			if is_heavy:
				var a_list =_create_attack_action([Tool.FightMotion.HeavyAttack_M_Pre,Tool.FightMotion.HeavyAttack_M_In,Tool.FightMotion.HeavyAttack_M_After])
				fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
			else:
				var a_list =_create_attack_action([Tool.FightMotion.Attack_Mid_Pre,Tool.FightMotion.Attack_Mid_In,Tool.FightMotion.Attack_Mid_After])
				fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
		Tool.WuMotion.Attack_Bot:
			if is_heavy:
				var a_list =_create_attack_action([Tool.FightMotion.HeavyAttack_B_Pre,Tool.FightMotion.HeavyAttack_B_In,Tool.FightMotion.HeavyAttack_B_After])
				fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
			else:
				var a_list =_create_attack_action([Tool.FightMotion.Attack_Bot_Pre,Tool.FightMotion.Attack_Bot_In,Tool.FightMotion.Attack_Bot_After])
				fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
		Tool.WuMotion.Defend_Up:
			var a_list =_create_attack_action([Tool.FightMotion.Def_Up_Pre,Tool.FightMotion.Def_Up_In,Tool.FightMotion.Def_Up_After])
			fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
		Tool.WuMotion.Defend_Mid:
			var a_list =_create_attack_action([Tool.FightMotion.Def_Mid_Pre,Tool.FightMotion.Def_Mid_In,Tool.FightMotion.Def_Mid_After])
			fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
		Tool.WuMotion.Defend_Bot:
			var a_list =_create_attack_action([Tool.FightMotion.Def_Bot_Pre,Tool.FightMotion.Def_Bot_In,Tool.FightMotion.Def_Bot_After])
			fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
		Tool.WuMotion.Attack_U2M:
			if is_heavy:
				var a_list =_create_attack_action([Tool.FightMotion.HeavyAttack_U2M_Pre,Tool.FightMotion.HeavyAttack_U2M_In,Tool.FightMotion.HeavyAttack_U2M_After])
				fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
			else:
				var a_list =_create_attack_action([Tool.FightMotion.HeavyAttack_M_Pre,Tool.FightMotion.HeavyAttack_M_In,Tool.FightMotion.HeavyAttack_M_After])
				fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
		Tool.WuMotion.Attack_U2B:
			if is_heavy:
				var a_list =_create_attack_action([Tool.FightMotion.HeavyAttack_U2B_Pre,Tool.FightMotion.HeavyAttack_U2B_In,Tool.FightMotion.HeavyAttack_U2B_After])
				fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
			else:
				var a_list =_create_attack_action([Tool.FightMotion.Attack_Bot_Pre,Tool.FightMotion.Attack_Bot_In,Tool.FightMotion.Attack_Bot_After])
				fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
		Tool.WuMotion.Attack_M2U:
			if is_heavy:
				var a_list =_create_attack_action([Tool.FightMotion.HeavyAttack_M2U_Pre,Tool.FightMotion.HeavyAttack_M2U_In,Tool.FightMotion.HeavyAttack_M2U_After])
				fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
			else:
				var a_list =_create_attack_action([Tool.FightMotion.Attack_Up_Pre,Tool.FightMotion.Attack_Up_In,Tool.FightMotion.Attack_Up_After])
				fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
		Tool.WuMotion.Attack_M2B:
			if is_heavy:
				var a_list =_create_attack_action([Tool.FightMotion.HeavyAttack_M2B_Pre,Tool.FightMotion.HeavyAttack_M2B_In,Tool.FightMotion.HeavyAttack_M2B_After])
				fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
			else:
				var a_list =_create_attack_action([Tool.FightMotion.Attack_Bot_Pre,Tool.FightMotion.Attack_Bot_In,Tool.FightMotion.Attack_Bot_After])
				fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
		Tool.WuMotion.Attack_B2U:
			if is_heavy:
				var a_list =_create_attack_action([Tool.FightMotion.HeavyAttack_B2U_Pre,Tool.FightMotion.HeavyAttack_B2U_In,Tool.FightMotion.HeavyAttack_B2U_After])
				fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
			else:
				var a_list =_create_attack_action([Tool.FightMotion.Attack_Up_Pre,Tool.FightMotion.Attack_Up_In,Tool.FightMotion.Attack_Up_After])
				fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
		Tool.WuMotion.Attack_B2M:
			if is_heavy:
				var a_list =_create_attack_action([Tool.FightMotion.HeavyAttack_B2M_Pre,Tool.FightMotion.HeavyAttack_B2M_In,Tool.FightMotion.HeavyAttack_B2M_After])
				fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
			else:
				var a_list =_create_attack_action([Tool.FightMotion.HeavyAttack_M_Pre,Tool.FightMotion.HeavyAttack_M_In,Tool.FightMotion.HeavyAttack_M_After])
				fight_cpn.actionMng.regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_NEWEST)
	


func on_action_event(event:NewActionEvent):
	
	#是否是重攻击；若不是 ，则以最后的位置作为轻攻击的方向(攻击);
	var is_heavy = false if event.action_end_time-event.action_begin_time< heavyAttackThreshold else true
	
	_do_wu_motion(event.wu_motion,is_heavy)
	
func on_move_event(event:MoveEvent):
	
	var action_mng = fight_cpn.actionMng
	var input_vector = event.move_direction
	var wu_motion = Tool.WuMotion.Idle
	if  !event.is_echo:
		
		if event.is_jump:
			#do jump
			var action = Tool.getPollObject(ActionInfo,[Tool.FightMotion.JumpUp,OS.get_ticks_msec(),[input_vector],-1,ActionInfo.EXEMOD_GENEROUS,-1])
			action_mng.regist_actioninfo(action)
		else:
			if input_vector != Vector2.ZERO:
				
				if input_vector.y !=0:
					
					if fight_cpn.get("is_climbing") == true:
						#do climb
						var action = Tool.getPollObject(ActionInfo,[Tool.FightMotion.Climb,OS.get_ticks_msec(),[input_vector],-1,ActionInfo.EXEMOD_GENEROUS,-1])
						action_mng.regist_actioninfo(action)
					
				else:
				
					var is_run = is_trigger_run(input_vector)

					if is_run :
						var action = Tool.getPollObject(ActionInfo,[Tool.FightMotion.Run,OS.get_ticks_msec(),[input_vector],-1,ActionInfo.EXEMOD_GENEROUS,-1])
						action_mng.regist_actioninfo(action)
		#				jisu.change_movable_state(input_vector,FightKinematicMovableObj.ActionState.Run)
					else:

						var action = Tool.getPollObject(ActionInfo,[Tool.FightMotion.Walk,OS.get_ticks_msec(),[input_vector],-1,ActionInfo.EXEMOD_GENEROUS,-1])
						action_mng.regist_actioninfo(action)
		#				jisu.change_movable_state(input_vector,FightKinematicMovableObj.ActionState.Walk)
			else:

				var lastMotion =action_mng.action_array.back()

				if lastMotion and lastMotion.base_action != Tool.FightMotion.Run:

					var action = Tool.getPollObject(ActionInfo,[Tool.FightMotion.Idle,OS.get_ticks_msec(),[input_vector],-1,ActionInfo.EXEMOD_GENEROUS,-1])
					action_mng.regist_actioninfo(action)
		#				jisu.change_movable_state(input_vector,FightKinematicMovableObj.ActionState.Idle)
	else:
		var lastMotion =action_mng.action_array.back()
		#这里是 攻击结束后，已经按下移动中的情况
		if lastMotion and (lastMotion.base_action != Tool.FightMotion.Run):

			var action = Tool.getPollObject(ActionInfo,[Tool.FightMotion.Walk,OS.get_ticks_msec(),[input_vector],-1,ActionInfo.EXEMOD_GENEROUS,-1])
			action_mng.regist_actioninfo(action)
			pass
	pass
	
func on_ai_event(event:AIEvent):
	_do_wu_motion(event.action_id,false)


#与另一个wuxue 发生战斗
func against_wuxue(otherWuxue:BaseWuXue):
	
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
	
		
