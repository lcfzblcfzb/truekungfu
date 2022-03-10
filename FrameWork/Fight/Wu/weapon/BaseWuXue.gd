class_name BaseWuXue
extends Node2D

var fight_cpn

var animation_tree:AnimationTree
var behaviourTree:BehaviorTree
var blackboard:Blackboard
var weapon_box_path:Shape2D
#用来保存 该武学 生成 的装备
var _gear_cache:Array =[]

#指向类型是一个Weapon 类
var weapon_path

var wu_animation_res;
#重攻击时间阈值.ms
var heavyAttackThreshold = 300.0

#武器动作类型
enum ActionForceType{
	CI, 	#刺
	GE, 	#格
	SAO, 	#扫
	LIAO,	#撩
}

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
		var base = FightBaseActionDataSource.get_by_base_id(k) as BaseAction
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
	
	var pool = Tool.PoolDict.get(ActionInfo) as ObjPool
	
	var result = []
	
	for k in action_dict:
		var item  = action_dict.get(k)
		if item:
			var act = Tool.getPollObject(ActionInfo,[k,item.get('create_time') if item.get('create_time') !=null else OS.get_ticks_msec() ,item.get('param'),item.get('duration'),item.get('exemod')])
			result.append(act)
		pass	
	return result

#virtual method
#在两者武器发生碰撞的时刻调用
#判定命中后的情况并且施加对应的惩罚或者奖励
func against_wuxue(otherWuxue:BaseWuXue):
	push_warning("against_wuxue is virtual. need to be implemented")

