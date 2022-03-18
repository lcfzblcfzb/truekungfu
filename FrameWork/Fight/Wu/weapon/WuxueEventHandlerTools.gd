class_name WuxueEventHandlerTools


#两个walk 动作转为run 的最小间隔/ms
const run_action_min_interval_ms =500

#检测之前的状态是否为hanging，如果是，检测是否需要中断HANGING，并返回true， 如果否返回false
static func _check_and_do_hangingclimb(event,fight_cpn)->bool:
	
	var action_mng = fight_cpn.actionMng
	var input_vector = event.move_direction
	var lastMotion =action_mng.nearest_executed_action()
	
	if lastMotion and lastMotion.base_action == Tool.FightMotion.Hanging:
		
		if event.is_jump:
			var vec = Vector2(input_vector.x,-1)
				#do jump up
			var action = Tool.getPollObject(ActionInfo,[Tool.FightMotion.JumpUp,OS.get_ticks_msec(),[vec],-1,ActionInfo.EXEMOD_INTERUPT])
			action_mng.regist_actioninfo(action)
			return true
		
		if (input_vector.x<0 and fight_cpn.is_face_left() or input_vector.x>0 and not fight_cpn.is_face_left() )and !event.is_echo:
			
			var base = FightBaseActionDataSource.get_by_base_id(Tool.FightMotion.HangingClimb) as BaseAction
			var action = Tool.getPollObject(ActionInfo,[Tool.FightMotion.HangingClimb,OS.get_ticks_msec(),[input_vector],base.get_duration(),ActionInfo.EXEMOD_SEQ,false,true])
			action_mng.regist_actioninfo(action)
			return true
	elif lastMotion and lastMotion.base_action == Tool.FightMotion.HangingClimb and not event.is_echo:
		
		if event.is_jump:
			var vec = Vector2(input_vector.x,-1)
				#do jump up
			var action = Tool.getPollObject(ActionInfo,[Tool.FightMotion.JumpUp,OS.get_ticks_msec(),[vec],-1,ActionInfo.EXEMOD_INTERUPT])
			action_mng.regist_actioninfo(action)
			return true
		pass 
	
	elif lastMotion and lastMotion.base_action == Tool.FightMotion.Walk and fight_cpn.is_at_hanging_corner() and event.is_jump:
		
		var base = FightBaseActionDataSource.get_by_base_id(Tool.FightMotion.HangingClimb) as BaseAction
		var action = Tool.getPollObject(ActionInfo,[Tool.FightMotion.HangingClimb,OS.get_ticks_msec(),[input_vector],base.get_duration(),ActionInfo.EXEMOD_SEQ,false,true])
		action_mng.regist_actioninfo(action)
		return true
		
		pass
	return false
	pass
	
#检测是否进入hanging状态
static func _check_and_do_hanging(event,fight_cpn)->bool:
	
	var action_mng = fight_cpn.actionMng
	var input_vector = event.move_direction
	var lastMotion =action_mng.nearest_executed_action()
	
	if lastMotion and lastMotion.base_action != Tool.FightMotion.Hanging and lastMotion.base_action != Tool.FightMotion.HangingClimb and lastMotion.base_action != Tool.FightMotion.JumpUp and  fight_cpn.is_at_hanging_corner() and not fight_cpn.is_on_genelized_floor():
		
		var action = Tool.getPollObject(ActionInfo,[Tool.FightMotion.Hanging,OS.get_ticks_msec(),[input_vector],-1,ActionInfo.EXEMOD_SEQ,false,true])
		action_mng.regist_actioninfo(action)
		return true
		
	elif lastMotion and lastMotion.base_action == Tool.FightMotion.Hanging:
		#是HANGING 则进入下面的移动操作
		return true
		
	return false
	pass

static func normal_on_moveevent(event,fight_cpn):
	
	var action_mng = fight_cpn.actionMng
	var input_vector = event.move_direction
	var wu_motion = Tool.WuMotion.Idle
	var movable = fight_cpn.fightKinematicMovableObj as FightKinematicMovableObj
	
	if _check_and_do_hangingclimb(event,fight_cpn):
		return
		
	if _check_and_do_hanging(event,fight_cpn):
		return	
	
	if  !event.is_echo:
		
		if event.is_jump:
			
			if fight_cpn.get("is_on_platform") ==true and input_vector.y>0:
				
				#jump down platform
				fight_cpn.set("is_on_platform",false)
				pass
			
			else:
				#确保跳跃的时候可以控制方向
				#如果只是平地起跳 input_vector=Vector2.ZERO的时候，也要保证 y=1；否则会被移动控制器忽略，使用上一个动作保存的方向
				var vec = Vector2(input_vector.x,-1)
				#do jump up
				var action = Tool.getPollObject(ActionInfo,[Tool.FightMotion.JumpUp,OS.get_ticks_msec(),[vec],-1,ActionInfo.EXEMOD_SEQ])
				action_mng.regist_actioninfo(action)
				
			
		else:
			if input_vector != Vector2.ZERO:
				
				if input_vector.y !=0 and fight_cpn.get("is_climbing") == true:
					
					#do climb
					var action = Tool.getPollObject(ActionInfo,[Tool.FightMotion.Climb,OS.get_ticks_msec(),[input_vector],-1,ActionInfo.EXEMOD_GENEROUS])
					action_mng.regist_actioninfo(action)
				else:
					
					var is_run = is_trigger_run(input_vector,fight_cpn)

					if is_run :
						
						var motion = Tool.FightMotion.Run
						
						if movable.state == FightKinematicMovableObj.ActionState.JumpUp:
							motion = Tool.FightMotion.JumpUp
						elif movable.state == FightKinematicMovableObj.ActionState.JumpDown:
							motion = Tool.FightMotion.JumpDown
						
						var action = Tool.getPollObject(ActionInfo,[motion,OS.get_ticks_msec(),[input_vector],-1,ActionInfo.EXEMOD_GENEROUS,true,true])
						action_mng.regist_actioninfo(action)
						
		#				jisu.change_movable_state(input_vector,FightKinematicMovableObj.ActionState.Run)
					else:
						var motion = Tool.FightMotion.Walk
						push_warning("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
						if movable.state == FightKinematicMovableObj.ActionState.JumpUp:
							motion = Tool.FightMotion.JumpUp
						elif movable.state == FightKinematicMovableObj.ActionState.JumpDown:
							motion = Tool.FightMotion.JumpDown
						
						var action = Tool.getPollObject(ActionInfo,[motion,OS.get_ticks_msec(),[input_vector],-1,ActionInfo.EXEMOD_GENEROUS,true,true])
						action_mng.regist_actioninfo(action)
						
		#				jisu.change_movable_state(input_vector,FightKinematicMovableObj.ActionState.Walk)
			else:


				if action_mng.action_array.size()>0:
					
					var lastMotion =action_mng.action_array.back()
					var motion = Tool.FightMotion.Idle
					if movable.state == FightKinematicMovableObj.ActionState.JumpUp:
						motion = Tool.FightMotion.JumpUp
					elif movable.state == FightKinematicMovableObj.ActionState.JumpDown:
						motion = Tool.FightMotion.JumpDown
					var action = Tool.getPollObject(ActionInfo,[motion,OS.get_ticks_msec(),[input_vector],-1,ActionInfo.EXEMOD_GENEROUS,true,true])
					action_mng.regist_actioninfo(action)
				else:
					var action = Tool.getPollObject(ActionInfo,[Tool.FightMotion.Idle,OS.get_ticks_msec(),[input_vector],-1,ActionInfo.EXEMOD_GENEROUS,true,true])
					action_mng.regist_actioninfo(action)
		#				jisu.change_movable_state(input_vector,FightKinematicMovableObj.ActionState.Idle)
	else:
		var lastMotion =action_mng.last_action()
		#这里是 攻击结束后，已经按下移动中的情况
		#climb 是因为如果之前是climb ，而这里没有包括，则climb的动作会被walk替换
		if lastMotion and (lastMotion.base_action != Tool.FightMotion.Run && lastMotion.base_action != Tool.FightMotion.Climb):
			var motion = Tool.FightMotion.Walk
			if movable.state == FightKinematicMovableObj.ActionState.JumpUp or movable.state == FightKinematicMovableObj.ActionState.JumpDown or movable.state == FightKinematicMovableObj.ActionState.Attack:
				return
			var action = Tool.getPollObject(ActionInfo,[motion, OS.get_ticks_msec(), [input_vector], -1, ActionInfo.EXEMOD_GENEROUS, false, true])
			action_mng.regist_actioninfo(action)
			pass
	pass


#判定是否是run
#进行一个run 判定
#两个间隔时间在 run_action_min_interval  的walk 指令触发成run
static func is_trigger_run(input_vector,fight_cpn)->bool:
	 
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
