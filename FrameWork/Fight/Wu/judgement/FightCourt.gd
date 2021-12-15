class_name FightCourt
extends Object

static func normal_judge(fighter0:FightComponent_human,fighter1:FightComponent_human,action_force_type0,action_force_type1):
	
	#TODO 根据不同 类型进行一个决策
	match action_force_type0:
		BaseWuXue.ActionForceType.CI:
			
			match action_force_type1:
				BaseWuXue.ActionForceType.CI:
					#无事发生
					_normal_ci_ci(fighter0,fighter1,action_force_type0,action_force_type1)
					pass
				BaseWuXue.ActionForceType.SAO:
					#给0 减益
					#或者给1 增益
					
					_normal_ci_sao(fighter0,fighter1,action_force_type0,action_force_type1)
					pass
				BaseWuXue.ActionForceType.GE:
					#给1 减益	
					
					_normal_ci_ge(fighter0,fighter1,action_force_type0,action_force_type1)
					pass
				BaseWuXue.ActionForceType.LIAO:
					#给0 减益
					
					_normal_ci_liao(fighter0,fighter1,action_force_type0,action_force_type1)
					pass
		BaseWuXue.ActionForceType.SAO:
			match action_force_type1:
				BaseWuXue.ActionForceType.CI:
					
					_normal_ci_sao(fighter1,fighter0,action_force_type1,action_force_type0)
					
					
					pass
				BaseWuXue.ActionForceType.SAO:
					_normal_sao_sao(fighter0,fighter1,action_force_type0,action_force_type1)
					
					pass
				BaseWuXue.ActionForceType.GE:	
					
					_normal_sao_ge(fighter0,fighter1,action_force_type0,action_force_type1)
					
					pass
				BaseWuXue.ActionForceType.LIAO:
					
					_normal_sao_liao(fighter0,fighter1,action_force_type0,action_force_type1)
					
					pass
		BaseWuXue.ActionForceType.GE:	
			match action_force_type1:
				BaseWuXue.ActionForceType.CI:
					_normal_ci_ge(fighter1,fighter0,action_force_type1,action_force_type0)
					
					pass
				BaseWuXue.ActionForceType.SAO:
					_normal_sao_ge(fighter1,fighter0,action_force_type1,action_force_type0)
					
					pass
				BaseWuXue.ActionForceType.GE:	
					
					_normal_ge_ge(fighter1,fighter0,action_force_type1,action_force_type0)
					
					pass
				BaseWuXue.ActionForceType.LIAO:
					
					_normal_ge_liao(fighter0,fighter1,action_force_type0,action_force_type1)
					
					pass
		BaseWuXue.ActionForceType.LIAO:
			match action_force_type1:
				BaseWuXue.ActionForceType.CI:
					_normal_ci_liao(fighter1,fighter0,action_force_type1,action_force_type0)
					
					pass
				BaseWuXue.ActionForceType.SAO:
					
					_normal_sao_liao(fighter1,fighter0,action_force_type1,action_force_type0)
					
					pass
				BaseWuXue.ActionForceType.GE:	
					
					_normal_ge_liao(fighter1,fighter0,action_force_type1,action_force_type0)
					
					pass
				BaseWuXue.ActionForceType.LIAO:
					
					_normal_liao_liao(fighter0,fighter1,action_force_type0,action_force_type1)
					
					pass

#常规情况 刺对上刺
static func _normal_ci_ci(f0:FightComponent_human,f1:FightComponent_human,a0,a1):
	return

static func _normal_ci_sao(f0:FightComponent_human,f1:FightComponent_human,a0,a1):
	return

static func _normal_ci_ge(f0:FightComponent_human,f1:FightComponent_human,a0,a1):
	return

static func _normal_ci_liao(f0:FightComponent_human,f1:FightComponent_human,a0,a1):
	return
		
static func _normal_sao_sao(f0:FightComponent_human,f1:FightComponent_human,a0,a1):
	return

static func _normal_sao_ge(f0:FightComponent_human,f1:FightComponent_human,a0,a1):
	return

static func _normal_sao_liao(f0:FightComponent_human,f1:FightComponent_human,a0,a1):
	return	

static func _normal_ge_ge(f0:FightComponent_human,f1:FightComponent_human,a0,a1):
	return	

static func _normal_ge_liao(f0:FightComponent_human,f1:FightComponent_human,a0,a1):
	return		

static func _normal_liao_liao(f0:FightComponent_human,f1:FightComponent_human,a0,a1):
	return		

	
#当 两个 武器发生碰撞的时候触发
static func weapon_hitted(fighter0:FightComponent_human,fighter1:FightComponent_human):
	
	var anim0 = fighter0.wu.get_current_animation_name()
	var anim1 = fighter1.wu.get_current_animation_name()
	
	var base_id_0 = FightBaseActionDataSource.get_by_anim_name(anim0)
	var base_id_1 = FightBaseActionDataSource.get_by_anim_name(anim1)
	
	var baseWuxueAction0 = BaseWuXueActionMng.get_by_wuxue_and_action(fighter0.wu.chosed_wuxue,  base_id_0.id) as BaseWuxueAction
	var baseWuxueAction1 = BaseWuXueActionMng.get_by_wuxue_and_action(fighter1.wu.chosed_wuxue,  base_id_1.id) as BaseWuxueAction
	
	
					
