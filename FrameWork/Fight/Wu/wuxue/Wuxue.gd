class_name WuXue
extends Node2D

var fight_cpn setget set_fight_cpn

var behaviourTree:BehaviorTree
var blackboard:Blackboard

#重攻击时间阈值.ms
var heavyAttackThreshold = 300.0

var animation_tree_root_node=preload("res://resource/animation/tree/StandarCharactorTree.tres")
var animation_tree_script = preload("res://resource/animation/script/default_tree_handling_script.gd")

#武器动作类型
enum ActionForceType{
	CI, 	#刺
	GE, 	#格
	SAO, 	#扫
	LIAO,	#撩
}

func set_fight_cpn(cpn):
	fight_cpn= cpn
	
#在学会时候的回调
func on_learned():
	pass
	
#在使用的时候的回调
func on_switch_on():
	pass
#在忘记时候的回调
func on_forget():
	pass
#在不使用时候的回调
func on_switch_off():
	pass

#virtual method
# 用来获得对应的wuxue_type
static func get_wuxue_type()->int:
	push_warning("get_wuxue_type is virtual .need to be implemented")
	return -1
	pass

#virtual 
func on_action_event(event:NewActionEvent):
	push_warning("on_action_event is virtual .need to be implemented")
	pass
	
#virtual 	
func on_move_event(event:MoveEvent):
	push_warning("on_move_event is virtual .need to be implemented")
	pass
	
#virtual 	
func on_ai_event(event:AIEvent):
	push_warning("on_ai_event is virtual .need to be implemented")
	pass



#
func _create_attack_action(action_list):
		
	var param_dict ={}
	
	for i in range(action_list.size()):
		var k = action_list[i]
		var base = FightBaseActionDataSource.get_by_id(k) as BaseAction
		if i <2:
			
			param_dict[k]={create_time=OS.get_ticks_msec(),
								duration=base.duration*1000,
								exemod =ActionInfo.EXEMOD_SEQ}
		else:
			param_dict[k]={create_time=OS.get_ticks_msec(),
								duration=base.duration*1000,
								exemod =ActionInfo.EXEMOD_GENEROUS}
	
	return _create_group_actions(param_dict)

func _create_group_actions(action_dict:Dictionary):
	
	if action_dict==null||action_dict.size()<3:
		return
	
	var pool = Glob.PoolDict.get(ActionInfo) as ObjPool
	
	var result = []
	
	for k in action_dict:
		var item  = action_dict.get(k)
		if item:
			var act = GlobVar.getPollObject(ActionInfo,[k,item.get('create_time') if item.get('create_time') !=null else OS.get_ticks_msec() ,item.get('param'),item.get('duration'),item.get('exemod')])
			result.append(act)
		pass	
	return result

#virtual method
#在两者武器发生碰撞的时刻调用
#判定命中后的情况并且施加对应的惩罚或者奖励
func against_wuxue(otherWuxue:WuXue):
	push_warning("against_wuxue is virtual. need to be implemented")

