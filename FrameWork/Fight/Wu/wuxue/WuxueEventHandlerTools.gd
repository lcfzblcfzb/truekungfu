class_name WuxueEventHandlerTools


#两个walk 动作转为run 的最小间隔/ms
const run_action_min_interval_ms =500

#检测之前的状态是否为hanging，如果是，检测是否需要中断HANGING，并返回true， 如果否返回false
static func _check_and_do_hangingclimb(event,fight_cpn)->bool:
	
	var action_mng = fight_cpn.actionMng
	var input_vector = event.move_direction
	var lastMotion =action_mng.nearest_executed_action(Glob.ActionHandlingType.Movement)
	
	if lastMotion and lastMotion.base_action == Glob.FightMotion.Hanging:
		
		if event.is_jump:
			var vec = Vector2(input_vector.x,-1)
				#do jump up
			var action = Glob.getPollObject(ActionInfo,[Glob.FightMotion.JumpUp,OS.get_ticks_msec(),[vec],-1,ActionInfo.EXEMOD_INTERUPT])
			action_mng.regist_actioninfo(action)
			return true
		
		if (input_vector.x<0 and fight_cpn.is_face_left() or input_vector.x>0 and not fight_cpn.is_face_left() )and !event.is_echo:
			
			var base = FightBaseActionDataSource.get_by_id(Glob.FightMotion.HangingClimb) as BaseAction
			var action = Glob.getPollObject(ActionInfo,[Glob.FightMotion.HangingClimb,OS.get_ticks_msec(),[input_vector],base.get_duration(),ActionInfo.EXEMOD_SEQ,false,true])
			action_mng.regist_actioninfo(action)
			return true
	elif lastMotion and lastMotion.base_action == Glob.FightMotion.HangingClimb and not event.is_echo:
		
		if event.is_jump:
			var vec = Vector2(input_vector.x,-1)
				#do jump up
			var action = Glob.getPollObject(ActionInfo,[Glob.FightMotion.JumpUp,OS.get_ticks_msec(),[vec],-1,ActionInfo.EXEMOD_INTERUPT])
			action_mng.regist_actioninfo(action)
			return true
	
	elif lastMotion and lastMotion.base_action == Glob.FightMotion.Walk and fight_cpn.is_at_hanging_corner() and event.is_jump:
		
		var base = FightBaseActionDataSource.get_by_id(Glob.FightMotion.HangingClimb) as BaseAction
		var action = Glob.getPollObject(ActionInfo,[Glob.FightMotion.HangingClimb,OS.get_ticks_msec(),[input_vector],base.get_duration(),ActionInfo.EXEMOD_SEQ,false,true])
		action_mng.regist_actioninfo(action)
		return true
		
	return false
	
#检测是否进入hanging状态
static func _check_and_do_hanging(event,fight_cpn)->bool:
	
	var action_mng = fight_cpn.actionMng
	var input_vector = event.move_direction
	var lastMotion =action_mng.nearest_executed_action(Glob.ActionHandlingType.Movement)
	
	if lastMotion and lastMotion.base_action != Glob.FightMotion.Hanging and lastMotion.base_action != Glob.FightMotion.HangingClimb and lastMotion.base_action != Glob.FightMotion.JumpUp and  fight_cpn.is_at_hanging_corner() and not fight_cpn.is_on_genelized_floor():
		
		var action = Glob.getPollObject(ActionInfo,[Glob.FightMotion.Hanging,OS.get_ticks_msec(),[input_vector],-1,ActionInfo.EXEMOD_SEQ,false,true])
		action_mng.regist_actioninfo(action)
		return true
		
	elif lastMotion and lastMotion.base_action == Glob.FightMotion.Hanging:
		#是HANGING 则进入下面的移动操作
		return true
		
	return false


#普通的 action 事件
#Glob.FightMotion
static func normal_on_ai_event(fight_motion ,fight_cpn):
	
	pass

#普通的 action 事件
# Glob.WuMotion
static func normal_on_action_event(wu_motion,is_heavy ,fight_cpn):
	var attribute_mng = fight_cpn.attribute_mng as AttribugeMng
	var actoin_mng = fight_cpn.actionMng as FightActionMng
	match( wu_motion):
		Glob.WuMotion.Cancel:
			var base = FightBaseActionDataSource.get_by_id(Glob.FightMotion.Canceled) as BaseAction
			fight_cpn.actionMng.regist_action(base.id,attribute_mng.get_value(Glob.CharactorAttribute.CancelDuration),ActionInfo.EXEMOD_INTERUPT)
		
		Glob.WuMotion.Block:
			
			if not fight_cpn.cost_stamina(fight_cpn.attribute_mng.get_value(Glob.CharactorAttribute.BlockStamina)):
				return
				
			fight_cpn.is_prepared = true			
#			var base = FightBaseActionDataSource.get_by_id(Glob.FightMotion.Blocking) as BaseAction
#			actoin_mng.regist_action(Glob.FightMotion.Blocking,attribute_mng.get_value(Glob.CharactorAttribute.BlockDuration),ActionInfo.EXEMOD_INTERUPT)
			
			var dodge_base = FightBaseActionDataSource.get_by_id(Glob.FightMotion.Pre_Block)
			var dodge = ActionInfo.create_by_base(dodge_base,attribute_mng.get_value(Glob.CharactorAttribute.PreBlockDuration),ActionInfo.EXEMOD_SEQ,false,false)
			
			var block_base = FightBaseActionDataSource.get_by_id(Glob.FightMotion.Blocking)
			var block =  ActionInfo.create_by_base(block_base,block_base.get_duration(),ActionInfo.EXEMOD_SEQ,false,false)
			
			actoin_mng.regist_group_actions([dodge,block],actoin_mng.next_group_id(dodge_base.handle_type),ActionInfo.EXEMOD_GENEROUS)
		Glob.WuMotion.PostBlock:
			var post_block_base = FightBaseActionDataSource.get_by_id(Glob.FightMotion.Post_Block)
			var pose_block_action =  ActionInfo.create_by_base(post_block_base,attribute_mng.get_value(Glob.CharactorAttribute.PostBlockDuration),ActionInfo.EXEMOD_GENEROUS,false,true)
			actoin_mng.regist_actioninfo(pose_block_action)
		
		Glob.WuMotion.Attack_Pi:
			
			if not fight_cpn.cost_stamina(fight_cpn.attribute_mng.get_value(Glob.CharactorAttribute.AttackPiStamina)):
				return
			
			fight_cpn.is_prepared = true			
			var base = FightBaseActionDataSource.get_by_id(Glob.FightMotion.Attack_Pi) as BaseAction
			fight_cpn.actionMng.regist_action(Glob.FightMotion.Attack_Pi,attribute_mng.get_value(Glob.CharactorAttribute.AttackPiDuration),ActionInfo.EXEMOD_GENEROUS)
			pass
		
		Glob.WuMotion.Rolling:
			var base = FightBaseActionDataSource.get_by_id(Glob.FightMotion.Rolling) as BaseAction
			
			var current_action = fight_cpn.actionMng.get_current_action(base.handle_type) as ActionInfo
			
			if current_action.base_action == Glob.FightMotion.Rolling:
				return
			
			if not fight_cpn.cost_stamina(fight_cpn.attribute_mng.get_value(Glob.CharactorAttribute.RollStamina)):
				return
			
			fight_cpn.actionMng.regist_action(base.id,attribute_mng.get_value(Glob.CharactorAttribute.RollingDuration),ActionInfo.EXEMOD_NEWEST)
			pass
		
		Glob.WuMotion.Stunned:
			var base = FightBaseActionDataSource.get_by_id(Glob.FightMotion.Stunned) as BaseAction
			fight_cpn.actionMng.regist_action(Glob.FightMotion.Stunned,base.duration,ActionInfo.EXEMOD_INTERUPT)
			pass
			
		Glob.WuMotion.Prepared:
			
			var base = FightBaseActionDataSource.get_by_id(Glob.FightMotion.Prepared) as BaseAction
			if base != null :
				var action = Glob.getPollObject(ActionInfo,[base.id, OS.get_ticks_msec(), [Vector2.ZERO], attribute_mng.get_value(Glob.CharactorAttribute.PrepareDuration), ActionInfo.EXEMOD_GENEROUS, false, true])
				fight_cpn.actionMng.regist_actioninfo(action)
			
		Glob.WuMotion.Unprepared:
			
			var base = FightBaseActionDataSource.get_by_id(Glob.FightMotion.Unprepared) as BaseAction
			if base != null :
				var action = Glob.getPollObject(ActionInfo,[base.id, OS.get_ticks_msec(), [Vector2.ZERO], attribute_mng.get_value(Glob.CharactorAttribute.UnPrepareDuration), ActionInfo.EXEMOD_GENEROUS, false, true])
				fight_cpn.actionMng.regist_actioninfo(action)
		
		Glob.WuMotion.Attack:
			
			fight_cpn.is_prepared = true
			fight_cpn.set_paused_unpreparing_timer(false)
			var _a 
			var _duration
			var _cost_stamina
			if is_heavy:
				_a = Glob.FightMotion.Attack_Sao
				_duration = attribute_mng.get_value(Glob.CharactorAttribute.AttackSaoDuration)
				_cost_stamina =fight_cpn.attribute_mng.get_value(Glob.CharactorAttribute.AttackSaoStamina)
			else:
				_a = Glob.FightMotion.Attack_Ci
				_duration = attribute_mng.get_value(Glob.CharactorAttribute.AttackCiDuration)
				_cost_stamina =fight_cpn.attribute_mng.get_value(Glob.CharactorAttribute.AttackCiStamina)
			
			if not fight_cpn.cost_stamina(_cost_stamina):
				#耐力不足的时候 返回IDLE
				var action = Glob.getPollObject(ActionInfo,[Glob.FightMotion.Canceled,OS.get_ticks_msec(),[],-1,ActionInfo.EXEMOD_GENEROUS,true,true])
				fight_cpn.actionMng.regist_actioninfo(action)
				
				return
			var base = FightBaseActionDataSource.get_by_id(_a) as BaseAction
			fight_cpn.actionMng.regist_action(_a , _duration,ActionInfo.EXEMOD_INTERUPT)
		
		
		Glob.WuMotion.Holding:
			
			fight_cpn.is_prepared = true
			fight_cpn.set_paused_unpreparing_timer()
			var base = FightBaseActionDataSource.get_by_id(Glob.FightMotion.Holding) as BaseAction
			fight_cpn.actionMng.regist_action(base.id,attribute_mng.get_value(Glob.CharactorAttribute.HoldingDuration),ActionInfo.EXEMOD_GENEROUS)
		
		Glob.WuMotion.Switch:
			
			fight_cpn.switch_weapon(0,Glob.WuxueEnum.Sanjiaomao)
			pass


static func normal_on_moveevent(event,fight_cpn):
	
	var action_mng = fight_cpn.actionMng
	var input_vector = event.move_direction
	var wu_motion = Glob.WuMotion.Idle
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
				var action = Glob.getPollObject(ActionInfo,[Glob.FightMotion.JumpUp,OS.get_ticks_msec(),[vec],-1,ActionInfo.EXEMOD_SEQ,false,true])
				action_mng.regist_actioninfo(action)

			
		else:
			if input_vector != Vector2.ZERO:
				
				if input_vector.y !=0 and fight_cpn.get("is_climbing") == true:
					
					#do climb
					var action = Glob.getPollObject(ActionInfo,[Glob.FightMotion.Climb,OS.get_ticks_msec(),[input_vector],-1,ActionInfo.EXEMOD_GENEROUS])
					action_mng.regist_actioninfo(action)
				else:
					
					var is_run = is_trigger_run(input_vector,fight_cpn)

					if is_run :
						
						var motion = Glob.FightMotion.Run
						
						if movable.state == FightKinematicMovableObj.ActionState.JumpUp:
							motion = Glob.FightMotion.JumpUp
						elif movable.state == FightKinematicMovableObj.ActionState.JumpDown:
							motion = Glob.FightMotion.JumpDown
						
						var action = Glob.getPollObject(ActionInfo,[motion,OS.get_ticks_msec(),[input_vector],-1,ActionInfo.EXEMOD_GENEROUS,true,true])
						action_mng.regist_actioninfo(action)
						
		#				jisu.change_movable_state(input_vector,FightKinematicMovableObj.ActionState.Run)
					else:
						var motion = Glob.FightMotion.Walk
						if movable.state == FightKinematicMovableObj.ActionState.JumpUp:
							motion = Glob.FightMotion.JumpUp
						elif movable.state == FightKinematicMovableObj.ActionState.JumpDown:
							motion = Glob.FightMotion.JumpDown
						
						var action = Glob.getPollObject(ActionInfo,[motion,OS.get_ticks_msec(),[input_vector],-1,ActionInfo.EXEMOD_GENEROUS,true,true])
						action_mng.regist_actioninfo(action)
						
		#				jisu.change_movable_state(input_vector,FightKinematicMovableObj.ActionState.Walk)
			else:
				var lastMotion =action_mng.last_action(Glob.ActionHandlingType.Movement)
				if lastMotion:
					var motion = Glob.FightMotion.Idle
					if movable.state == FightKinematicMovableObj.ActionState.JumpUp:
						motion = Glob.FightMotion.JumpUp
					elif movable.state == FightKinematicMovableObj.ActionState.JumpDown:
						motion = Glob.FightMotion.JumpDown
					var action = Glob.getPollObject(ActionInfo,[motion,OS.get_ticks_msec(),[input_vector],-1,ActionInfo.EXEMOD_GENEROUS,true,true])
					action_mng.regist_actioninfo(action)
				else:
					var action = Glob.getPollObject(ActionInfo,[Glob.FightMotion.Idle,OS.get_ticks_msec(),[input_vector],-1,ActionInfo.EXEMOD_GENEROUS,true,true])
					action_mng.regist_actioninfo(action)
		#				jisu.change_movable_state(input_vector,FightKinematicMovableObj.ActionState.Idle)
	else:
		var lastMotion =action_mng.last_action(Glob.ActionHandlingType.Movement)
		#这里是 攻击结束后，已经按下移动中的情况
		#climb 是因为如果之前是climb ，而这里没有包括，则climb的动作会被walk替换
		if lastMotion and (lastMotion.base_action != Glob.FightMotion.Run && lastMotion.base_action != Glob.FightMotion.Climb):
			var motion = Glob.FightMotion.Walk
			if movable.state == FightKinematicMovableObj.ActionState.JumpUp or movable.state == FightKinematicMovableObj.ActionState.JumpDown or movable.state == FightKinematicMovableObj.ActionState.Attack:
				return
			var action = Glob.getPollObject(ActionInfo,[motion, OS.get_ticks_msec(), [input_vector], -1, ActionInfo.EXEMOD_GENEROUS, false, false])
			action_mng.regist_actioninfo(action)

#判定是否是run
#进行一个run 判定
#两个间隔时间在 run_action_min_interval  的walk 指令触发成run
static func is_trigger_run(input_vector,fight_cpn)->bool:
	 
	var action_mng = fight_cpn.actionMng
	var action_array =action_mng.get_action_array(Glob.ActionHandlingType.Movement)
	var index =action_array.size()
	
	while true:
		index=index-1
		if index<0:
			break
		var tmp = action_array[index] as ActionInfo
		#在极短时间内的几个run或者walk 都视为触发了run
		if  tmp.action_create_time+run_action_min_interval_ms >= OS.get_ticks_msec():
			if (tmp.base_action ==Glob.FightMotion.Walk ||tmp.base_action ==Glob.FightMotion.Run) && tmp.param[0] == input_vector:
				return true
		else:
			return false;
		pass
	return false
	pass
