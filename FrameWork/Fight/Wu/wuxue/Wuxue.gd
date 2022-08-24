class_name WuXue
extends Node2D

const WuxueStateMachineScene = preload("res://FrameWork/Fight/Wu/wuxue/StateMachine/WuxueStateMachine.tscn")
var animation_tree_root_node=preload("res://resource/animation/tree/StandarCharactorTree.tres")
var animation_tree_script = preload("res://resource/animation/script/default_tree_handling_script.gd")

var fight_cpn setget set_fight_cpn

var behaviourTree:BehaviorTree
var blackboard:Blackboard

var wuxue_state_machine:StateMachine

#重攻击时间阈值.ms
var heavyAttackThreshold = 300.0
#处于激活状态
var active = false

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
	add_child( wuxue_state_machine)
	wuxue_state_machine.initialize(fight_cpn)
	
#在使用的时候的回调
func on_switch_on():
	wuxue_state_machine.state_start()
	active = true
	
#在忘记时候的回调
func on_forget():
	pass
#在不使用时候的回调
func on_switch_off():
	active = false
	pass

#virtual method
# 用来获得对应的wuxue_type
static func get_wuxue_type()->int:
	push_warning("get_wuxue_type is virtual .need to be implemented")
	return -1
	pass

#virtual 
func on_action_event(event:NewActionEvent):
	
	#是否是重攻击；若不是 ，则以最后的位置作为轻攻击的方向(攻击);
	var is_heavy = false if event.action_end_time-event.action_begin_time< heavyAttackThreshold else true
	wuxue_state_machine.normal_on_action_event(event.wu_motion,is_heavy)
	
#virtual 	
func on_move_event(event:MoveEvent):
	wuxue_state_machine.normal_on_move_event(event)
	pass
	
#virtual 	
func on_ai_event(event:AIEvent):
	wuxue_state_machine.normal_on_action_event(event.action_id)


func _physics_process(delta):
	
	if active:
		
		if wuxue_state_machine.get_current_status()==Glob.WuMotion.JumpFalling and fight_cpn.is_on_genelized_floor():
			
			if wuxue_state_machine.change_state(Glob.WuMotion.JumpDown):
				var base = FightBaseActionDataSource.get_by_id(Glob.FightMotion.JumpDown)
				var action = GlobVar.getPollObject(ActionInfo,[Glob.FightMotion.JumpDown, OS.get_ticks_msec(), [fight_cpn.fight_controller.get_moving_vector()], base.get_duration(), ActionInfo.EXEMOD_SEQ, false, true])

				var idle_base = FightBaseActionDataSource.get_by_id(Glob.FightMotion.Idle)
				var idle_action = GlobVar.getPollObject(ActionInfo,[Glob.FightMotion.Idle, OS.get_ticks_msec(), [fight_cpn.fight_controller.get_moving_vector()], base.get_duration(), ActionInfo.EXEMOD_GENEROUS, false, false])

				fight_cpn.actionMng.regist_group_actions([action,idle_action],ActionInfo.EXEMOD_GENEROUS)
		
		
		if fight_cpn.is_at_hanging_corner() and not fight_cpn.is_on_genelized_floor():
			
			if wuxue_state_machine.change_state(Glob.WuMotion.Hanging):
				var action = GlobVar.getPollObject(ActionInfo,[Glob.FightMotion.Hanging,OS.get_ticks_msec(),[Vector2.ZERO],-1,ActionInfo.EXEMOD_SEQ,false,true])
				fight_cpn.actionMng.regist_actioninfo(action)
					
		#若在空中的情况	
		if not fight_cpn.is_on_genelized_floor() :
			if wuxue_state_machine.get_current_status()==Glob.WuMotion.JumpRising :
				if fight_cpn.get_velocity().y ==0:
					#升至跳跃max,设置faceDirection 向下
					
					if wuxue_state_machine.change_state(Glob.WuMotion.JumpFalling):
						var base = FightBaseActionDataSource.get_by_id(Glob.FightMotion.JumpFalling)
						var action = GlobVar.getPollObject(ActionInfo,[Glob.FightMotion.JumpFalling, OS.get_ticks_msec(), [fight_cpn.fight_controller.get_moving_vector()], base.get_duration(), ActionInfo.EXEMOD_NEWEST, false, true])
						fight_cpn.actionMng.regist_actioninfo(action)
#					self.state = ActionState.JumpFalling
	#				var base = FightBaseActionDataSource.get_by_id(Glob.FightMotion.JumpFalling)
	#				var action = GlobVar.getPollObject(ActionInfo,[Glob.FightMotion.JumpFalling, OS.get_ticks_msec(), [body.fight_controller.get_moving_vector()], base.get_duration(), ActionInfo.EXEMOD_SEQ, false, true])
	#				body.actionMng.regist_actioninfo(action)
	#				emit_signal("Active_State_Changed",Glob.FightMotion.JumpFalling)
	#				self.state = ActionState.JumpDown
	#			elif (state != ActionState.HangingClimb and state != ActionState.Hanging )and body.is_at_hanging_corner() : #优先设置成hanging
	#				change_movable_state(Vector2.ZERO , ActionState.Hanging)
				
			elif not wuxue_state_machine.get_current_status() in [Glob.WuMotion.Hanging,Glob.WuMotion.HangingClimb] :
				
				if wuxue_state_machine.change_state(Glob.WuMotion.JumpFalling):
					#最基础的判定下落的地方
					var base = FightBaseActionDataSource.get_by_id(Glob.FightMotion.JumpFalling)
					var action = GlobVar.getPollObject(ActionInfo,[Glob.FightMotion.JumpFalling, OS.get_ticks_msec(), [fight_cpn.fight_controller.get_moving_vector()], base.get_duration(), ActionInfo.EXEMOD_NEWEST, false, true])
					fight_cpn.actionMng.regist_actioninfo(action)
		

func _on_FightActionMng_ActionStart(action:ActionInfo):

	match action.base_action:
		Glob.FightMotion.JumpRising:
			wuxue_state_machine.change_state(Glob.WuMotion.JumpRising)
#		Glob.FightMotion.JumpFalling:
#			wuxue_state_machine.change_state(Glob.WuMotion.JumpFalling)
#		Glob.FightMotion.JumpDown:
#			wuxue_state_machine.change_state(Glob.WuMotion.JumpDown)
			
func _on_FightActionMng_ActionFinish(action:ActionInfo):
	
	match action.base_action:
		Glob.FightMotion.JumpDown:
			wuxue_state_machine.change_state(Glob.WuMotion.Idle)
		Glob.FightMotion.HangingClimb:
			wuxue_state_machine.change_state(Glob.WuMotion.Idle)
		Glob.FightMotion.Attack_Ci:
			wuxue_state_machine.change_state(Glob.WuMotion.Idle)
			
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

#由MovableObje 主动触发的action
func _on_FightKinematicMovableObj_State_Changed(state):
	pass
#	match state:
#		FightKinematicMovableObj.ActionState.JumpDown:
#			var base = FightBaseActionDataSource.get_by_id(Glob.FightMotion.JumpDown)
#			var action = GlobVar.getPollObject(ActionInfo,[Glob.FightMotion.JumpDown, OS.get_ticks_msec(), [fight_cpn.fight_controller.get_moving_vector()], base.get_duration(), ActionInfo.EXEMOD_SEQ, false, true])
#
#			var idle_base = FightBaseActionDataSource.get_by_id(Glob.FightMotion.Idle)
#			var idle_action = GlobVar.getPollObject(ActionInfo,[Glob.FightMotion.Idle, OS.get_ticks_msec(), [fight_cpn.fight_controller.get_moving_vector()], base.get_duration(), ActionInfo.EXEMOD_GENEROUS, false, false])
#
#			fight_cpn.actionMng.regist_group_actions([action,idle_action],ActionInfo.EXEMOD_GENEROUS)
#
#		FightKinematicMovableObj.ActionState.JumpFalling:
#
#			var base = FightBaseActionDataSource.get_by_id(Glob.FightMotion.JumpFalling)
#			var action = GlobVar.getPollObject(ActionInfo,[Glob.FightMotion.JumpFalling, OS.get_ticks_msec(), [fight_cpn.fight_controller.get_moving_vector()], base.get_duration(), ActionInfo.EXEMOD_NEWEST, false, true])
#			fight_cpn.actionMng.regist_actioninfo(action)

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

