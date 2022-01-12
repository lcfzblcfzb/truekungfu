class_name Fist
extends BaseWuXue

static func get_wuxue_type():
	return WuxueMng.WuxueEnum.Fist

func _ready():
	wu_animation_res = "res://texture/animation/demo_motion_fist-Sheet.png"
	
	
	animation_player = $fist_animation
	animation_tree = $AnimationTree
	
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
	
	
func on_move_event(event:MoveEvent):
	
	WuxueEventHandlerTools.normal_on_moveevent(event,fight_cpn)
	
	
