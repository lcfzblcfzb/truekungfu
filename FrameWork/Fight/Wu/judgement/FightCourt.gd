extends Node

#当 两个 武器发生碰撞的时候触发
func weapon_hitted(fighter0:FightComponent_human,fighter1:FightComponent_human):
	
	var anim0 = fighter0.wu.get_current_animation_name()
	var anim1 = fighter1.wu.get_current_animation_name()
	
	var base_id_0 = FightBaseActionMng.get_by_anim_name(anim0)
	var base_id_1 = FightBaseActionMng.get_by_anim_name(anim1)
	
	var baseWuxueAction0 = BaseWuXueActionMng.get_by_wuxue_and_action(fighter0.wu.chosed_wuxue,  base_id_0.id)
	var baseWuxueAction1 = BaseWuXueActionMng.get_by_wuxue_and_action(fighter1.wu.chosed_wuxue,  base_id_1.id)
	
	#TODO 根据不同 类型进行一个决策
