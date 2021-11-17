class_name BaseWuXue
extends Node2D

var fight_cpn :FightComponent_human

var wu_animation_res;
#两个walk 动作转为run 的最小间隔/ms
var run_action_min_interval_ms =500
#重攻击时间阈值.ms
var heavyAttackThreshold = 300.0

func _init(fight_component):
	
	fight_cpn = fight_component
	
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


#判定是否是run
#进行一个run 判定
#两个间隔时间在 run_action_min_interval  的walk 指令触发成run
func is_trigger_run(input_vector)->bool:
	var action_mng = fight_cpn.actionMng
	var action_array =action_mng.action_array
	var index =action_array.size()
	
	while true:
		index=index-1
		if index<0:
			break
		var tmp = action_array[index] as ActionInfo
		#在极短时间内的几个run或者walk 都视为触发了run
		if  tmp.action_create_time+run_action_min_interval_ms >= OS.get_ticks_msec():
			if (tmp.base_action ==Tool.FightMotion.Walk ||tmp.base_action ==Tool.FightMotion.Run) && tmp.param[0] == input_vector:
				return true
		else:
			return false;
		pass
	return false
	pass

#
func _create_attack_action(action_list):
		
	var param_dict ={}
	
	for i in range(action_list.size()):
		var k = action_list[i]
		var base = FightBaseActionMng.get_by_base_id(k) as BaseAction
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
