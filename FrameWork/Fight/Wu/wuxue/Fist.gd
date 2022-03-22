class_name Fist
extends WuXue

static func get_wuxue_type():
	return Glob.WuxueEnum.Fist

func _ready():
	wu_animation_res = "res://texture/animation/demo_motion_fist-Sheet.png"
	
	animation_tree = $AnimationTree
	behaviourTree =  $FistBehaviorTree
	blackboard = $Blackboard
	behaviourTree.blackboard = blackboard
	
	weapon_box_path =load("res://resource/shape/weapon_shape_fist.tres")
#	yield(get_tree().create_timer(3),"timeout")
#	var animationPlayer = preload("res://FightAnimationPlayer.tscn").instance() as AnimationPlayer
#	add_child(animationPlayer)
#	animationPlayer.root_node = animationPlayer.get_path_to(sprite)
#	animationPlayer.play("idle")

func on_action_event(event:NewActionEvent):
	
	#是否是重攻击；若不是 ，则以最后的位置作为轻攻击的方向(攻击);
	var is_heavy = false if event.action_end_time-event.action_begin_time< heavyAttackThreshold else true
	var global_id = fight_cpn.actionMng.next_group_id()
	match( event.wu_motion):
		
		Glob.WuMotion.Stunned:
			var base = FightBaseActionDataSource.get_by_id(Glob.FightMotion.Stunned) as BaseAction
			fight_cpn.actionMng.regist_action(Glob.FightMotion.Stunned,base.duration,ActionInfo.EXEMOD_INTERUPT)
			pass
				
		Glob.WuMotion.Switch:
			fight_cpn.switch_weapon(1,Glob.WuxueEnum.Sword)
				
		Glob.WuMotion.Prepared:
			fight_cpn.is_prepared = true
		
		Glob.WuMotion.Unprepared:
			fight_cpn.is_prepared = false
			
		Glob.WuMotion.Hanging:
			var base = FightBaseActionDataSource.get_by_id(Glob.FightMotion.Hanging) as BaseAction
			fight_cpn.actionMng.regist_action(event.wu_motion,base.duration,ActionInfo.EXEMOD_INTERUPT)
			pass
		
		Glob.WuMotion.HangingClimb:
			var base = FightBaseActionDataSource.get_by_id(Glob.FightMotion.HangingClimb) as BaseAction
			fight_cpn.actionMng.regist_action(event.wu_motion,base.duration,ActionInfo.EXEMOD_INTERUPT)
			pass
		
		Glob.WuMotion.Attack:
			if fight_cpn.is_prepared == false:
				fight_cpn.is_prepared = true
			var base = FightBaseActionDataSource.get_by_id(Glob.FightMotion.Attack) as BaseAction
			fight_cpn.actionMng.regist_action(Glob.FightMotion.Attack,base.duration,ActionInfo.EXEMOD_INTERUPT)
		
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
	
func on_move_event(event:MoveEvent):
	WuxueEventHandlerTools.normal_on_moveevent(event,fight_cpn)
	
#animation_player组件的回调
func animation_call_method(param):
	pass
