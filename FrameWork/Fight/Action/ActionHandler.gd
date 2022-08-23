class_name ActionHandler

#Glob.ActionHandlingType
var handling_type

var action_mng

var global_group_id = 100

export var MAX_ACTION_ARRAY_SIZE =20
#动作历史记录
var action_array = []

var current_index = 0 setget set_current_index

var _current_action:ActionInfo = null
#旧数组数据
var old_array =[]

func _init(_handling_type,_action_mng):
	handling_type = _handling_type
	action_mng = _action_mng
	
#获得 最后一个执行的action；如果没有返回null
func nearest_executed_action()->ActionInfo:
	
	if _current_action !=null:
		return _current_action
	
	elif action_array.size()>0:
		return action_array.back()
	
	return null

func get_action_array():
	return action_array

func last_action():
	
	if action_array.size()>0:
		return action_array.back()
	else:
		return null

func next_group_id():
	global_group_id = global_group_id+1
	return global_group_id


func set_current_index(idx):
	current_index = idx
	_updateCurrentAction()

#set 当前索引的时候，更新下当前action
func _updateCurrentAction():

	if current_index < action_array.size():
		_current_action = action_array[current_index]

	elif current_index== action_array.size():
		_current_action =null
	else:
		#不存在的情况
		push_warning("current_index is somehow over the action_array size.")
		self.current_index =action_array.size()
		_current_action = null
	pass


#保持数组长度不超过 MAX_ACTION_ARRAY_SIZE 的长度
#缓存上一个数组的数据
# Deprecated
func regist_action(a, duration=1, exemod=ActionInfo.EXEMOD_NEWEST,groupId =-1,param:Array=[] ):
	#var action =ActionInfo.new(a,OS.get_ticks_msec(),param)
	var input_array = [a ,OS.get_ticks_msec(),param,duration*1000,exemod,groupId]
	var action =GlobVar.getPollObject(ActionInfo,input_array)
	regist_actioninfo (action)

func debug_print():
	
	#打印一些数据
	var n =  10  if  action_array.size()>10 else action_array.size()
	
	if n < action_array.size()-current_index:
		n= action_array.size()-current_index+1
	var s =''
	for i in n:
		var a = action_array[-(i+1)] as ActionInfo
		var baseAction =FightBaseActionDataSource.dict.get(a.base_action)
		if baseAction:
			if a.state ==ActionInfo.STATE_ING :
				s = s+"[current -> :" +baseAction.animation_name+"]"
				pass
			else:
				s = s+"["+a.state as String +baseAction.animation_name+"]"
		pass
#	print(s)
	
#注册整个action
func regist_actioninfo(action:ActionInfo):
	#检查是否是重复的持久型action
	if action_array.size()>0:
		var nearest_action = action_array.back()
		if nearest_action and (not action.repeatation_allowed) and action.is_bussiness_equal(nearest_action):
			return
	LogTool.info("[ActionHandler] action added success. action:[%s]" % CommonTools.get_enum_key_name(Glob.FightMotion,action.base_action))
	_resize_action_array()
	
	_check_execution_prority_and_add(action)
	
	_updateCurrentAction()
	
	_check_break_loop(action)
#	debug_print()
	
	return action

#检测break_loop类型的操作
func _check_break_loop(action:ActionInfo):

	if _current_action and _current_action.is_loop and _current_action.state == ActionInfo.STATE_ING and action.loop_break:
		
		_current_action.state = ActionInfo.STATE_ENDED
		var finished_Action =_current_action
		self.current_index=current_index+1
		#为了让 使用 current_index 取到的 都是 inited/ing 状态的action
		action_mng.action_finish(finished_Action)
#添加一个组的动作
func regist_group_actions(actions:Array,groupId,group_exe_mod=ActionInfo.EXEMOD_NEWEST):
	for act in actions:
		var action = act as ActionInfo
		action.group_id = groupId
		action.group_exe_mod = group_exe_mod
		regist_actioninfo(action)
		pass
	pass

#判断是否是 抢占式执行
func _is_interrupt_mod(action:ActionInfo,prvAction:ActionInfo):
	
	if action.group_id<0&&action.execution_mod==ActionInfo.EXEMOD_INTERUPT:
		return true
	#检测group 的 exemod
	if action.group_id>0 && action.group_exe_mod==ActionInfo.EXEMOD_INTERUPT && prvAction.group_id!=action.group_id:
		return true
	#检测 个体 的 exemod
	#若这个action 的 group_exe_mod 不是interupt 但是 个体的 mod 是 interupt 且处于group 的第一个时候，这个组在插入的时候被当作 interrupt 使用
	if action.group_id>0 && action.execution_mod==ActionInfo.EXEMOD_INTERUPT && prvAction.group_id!=action.group_id:
		return true
		
	#ATTENTION: 有一种特殊情况是 interrupt出现在 组合的中间的时候，是被当作SEQ 类型一样的处理的
	return false


#检测执行顺序如果有STATE_INTERUPTED 类型的就直接执行
func _check_execution_prority_and_add(action):

	if current_index <action_array.size():
		
		var prv_action = action_array.back() as ActionInfo
		
		if _is_interrupt_mod(action,prv_action):
			#抢占式
			_blind_append_interupt(action)
			pass
		else:
			_check_newest_on_add(action,prv_action)
			#检测是否当前的action是generous
			_check_generous_on_add(action)
	else:
		action_array.append(action)

#某个action group 是否处于 STATE_ING
func _is_action_group_playing(action:ActionInfo)->bool:
	
	if _current_action ==null:
		return false
	if _current_action.group_id !=action.group_id:
		return false
	if _current_action.state != ActionInfo.STATE_ING:
		return false
		
	return true
	pass

func _check_newest_on_add(action,prv_action):
	if prv_action.group_id>0:
		_add_to_group(action,prv_action)
	else:
		_add_to_action_array(action)
	pass	

#新的action加入到action_array，且前一个action 是 group类型
func _add_to_group(action:ActionInfo,prvAction):
	
	if prvAction==null:
		push_error("prv action is null inside add_to_group()")
		return

	#根据前一个的group类型 分别处理
	if prvAction.group_exe_mod == ActionInfo.EXEMOD_NEWEST:
		var prv_group_id = prvAction.group_id

		if _is_action_group_playing(prvAction) or prv_group_id == action.group_id:
			#前一个group 已经正在执行中了。
			_add_to_action_array(action)
		else:
			#前一个group 还没有执行。 进行替换工作
			_blind_replace_newest(action,prv_group_id)
		
	else:
		_add_to_action_array(action)
  
#替换newest
#blind 函数：默认 prv_action.group_id>0; prv_action.group_exe_mod = NEWEST
#action 是新增的参数；且紧接的是exemod==newest 模式的动作
func _blind_replace_newest(action,prv_group_id):
	
	action_array.append(action)
	
	#从后往前 遍历 找到最后一个 该group_id的action 并且设置状态 passed
	var i = self.current_index-1
	while true:
		var prv_action = action_array[i] as ActionInfo
		if prv_action ==null:
			break
		if prv_action.group_id != prv_group_id:
			break
			
		prv_action.state = ActionInfo.STATE_PASSED
		action_mng.action_finish(prv_action)
		i=i-1


#新的action输入
# ATTENTION:若是在add_to_group 中调用，则是表示已经处理完group_exe_mod 优先级，现在开始处理group内 的单个action 的优先级
func _add_to_action_array(action:ActionInfo):

	var back_action = action_array.back() as ActionInfo
	
	action_array.append(action)
	
	#这里 的第二个判断是因为generous类型的在下一个步骤处理
	if back_action.execution_mod == ActionInfo.EXEMOD_NEWEST and action.execution_mod != ActionInfo.EXEMOD_GENEROUS:
		
		if back_action.state == ActionInfo.STATE_INITED:
			back_action.state =ActionInfo.STATE_PASSED
			action_mng.action_finish(back_action)
			

#检测下action_array 是否太大，并进行处理
func _resize_action_array():
	if current_index >= MAX_ACTION_ARRAY_SIZE:
		if old_array.size()>0:
			for o in old_array:
				o.dead()
		#current_index 永远指向 正在运行中的action，或者已经全部运行结束的下一个index ;
		#old_array 少加了一个末尾action 是为了在新的action_array中保留一个最后完成的action 方便查询,因此这里使用 current_index-2
		old_array = action_array.slice(0,current_index-2)
		action_array  = action_array.slice(current_index-1,action_array.size())
		#设置index为1，而不是0 ；因为在重组后数组的第1个是上一个状态为完成的;
		self.current_index = 1

#当前是正在执行中的循环的action
func is_playing_loop():
	if _current_action!=null && _current_action.state ==ActionInfo.STATE_ING && _current_action.is_loop:
		return true

	return false;
	
#当前是GENEROUS类型
func is_generous_type(action:ActionInfo):
	if  action.execution_mod ==ActionInfo.EXEMOD_GENEROUS:
		return true
	if action.group_id>0 && action.group_exe_mod ==ActionInfo.EXEMOD_GENEROUS:
		return true
	return false

#分别在进入运行态（STATE_ING） 的时候 和 有新动作添加的时候做一个检测
func _check_generous_on_add(action :ActionInfo):
	
	#group_exe_mod = generous类型
	if _current_action.group_id>0 && _current_action.group_exe_mod ==ActionInfo.EXEMOD_GENEROUS:
						
		var next_group_action =null
		#暂存一下，当前进行中的group_id
		var current_group_id = _current_action.group_id
		#找到下一个 不同group 的对象
		for i in range(current_index+1, action_array.size()):
			
			var tmp_action = action_array[i] as ActionInfo
			
			if tmp_action.group_id!= current_group_id:
				
				if  !tmp_action.base_action in _current_action.not_generous_type:
					next_group_action = tmp_action
					
				break
						
		if next_group_action!=null:
			#找到下一个 不同group 的对象
			for i in range(current_index, action_array.size()):
				var tmp_action = action_array[i] as ActionInfo
				if tmp_action.group_id== current_group_id:
					#若标记为真且 	
					tmp_action.state =ActionInfo.STATE_PASSED
					self.current_index = current_index+1
					action_mng.action_finish(tmp_action)
					pass
				else:
					break
	#exemod = generous类型的判断
	elif _current_action.execution_mod == ActionInfo.EXEMOD_GENEROUS:
		if current_index< (action_array.size()-1):
			var next_action = action_array[current_index+1] as ActionInfo
			if ! next_action.base_action in _current_action.not_generous_type:

				_current_action.state = ActionInfo.STATE_PASSED
				var passed_action = _current_action
				self.current_index = current_index+1
				action_mng.action_finish(passed_action)
				pass
			pass
		pass
	
	elif action.execution_mod == ActionInfo.EXEMOD_GENEROUS:
		
		if action_array.size()>=2:
			
			var prv_action =action_array[action_array.size()-2] as ActionInfo
			# 前一个是group 的情况需要仔细考量
			if prv_action.execution_mod == ActionInfo.EXEMOD_NEWEST and prv_action.state ==ActionInfo.STATE_INITED and prv_action.base_action in action.not_generous_type:
				prv_action.state = ActionInfo.STATE_PASSED
				action_mng.action_finish(prv_action)
				

#在运行的时刻，检测generous
#ATTENTION! 此时需要检测 连续的generous的情形
func _check_generous_on_process():
	
	if current_index>=action_array.size()-1 || !is_generous_type(_current_action):
		return

	var foundIndex = -1;
	
	#在循环中记录 找到的 GENEROUS类型的 group_id和第一个成员所处的Index,
	var found_group_id = -1 if _current_action.group_id<0 else _current_action.group_id
	var found_group_index = -1 if _current_action.group_id<0 else current_index
	#找出执行generous行为的最后一个index
	for i in range(current_index+1,action_array.size()):
		
		var action = action_array[i]
		#TODO 是否可以写成一行？
		if action.group_id>0 && action.group_exe_mod ==ActionInfo.EXEMOD_GENEROUS:
			
			if found_group_id>0:
				if found_group_id!=action.group_id:
					found_group_id = action.group_id
					found_group_index = i
					foundIndex = i-1
				else:
					var _prv_action = action_array[i-1]
					if _prv_action.execution_mod == ActionInfo.EXEMOD_GENEROUS:
						foundIndex = i-1
						pass
			else:
				
				found_group_id = action.group_id
				found_group_index = i
				foundIndex = i-1
			pass
		elif action.execution_mod ==ActionInfo.EXEMOD_GENEROUS:
			
			if found_group_id>0:
				found_group_id=-1
				found_group_index=-1
				foundIndex=i-1
				pass
			else:
				foundIndex=i-1
			pass
		else:
			
			found_group_id=-1
			found_group_index=-1
			foundIndex = i-1
			break
			pass
		pass
	pass
		
#	if current_index!=foundIndex:
		#执行generous操作
	for i in range(current_index,foundIndex+1):
		
		_current_action.state =ActionInfo.STATE_PASSED
		var pass_action = _current_action
		self.current_index = current_index+1
		action_mng.action_finish(pass_action)
		pass


func _check_loop_on_process():
	
	var count =0
	if _current_action and _current_action.is_loop:
		
		for i in range(current_index,action_array.size()):
			
			var _action =  action_array[i] as ActionInfo
			if _action.loop_break:
				
				count +=1
				
				if count >1:
				
					_current_action.state = ActionInfo.STATE_ENDED
					var finished_Action =_current_action
					self.current_index=current_index+1
					#为了让 使用 current_index 取到的 都是 inited/ing 状态的action
					action_mng.action_finish(finished_Action)
					break

func on_tick(delta):
	
	while true:
		if _current_action and _current_action.state == ActionInfo.STATE_PASSED:
			self.current_index+=1
		else:
			break
		
	if _current_action !=null:
		
		if _current_action.state == ActionInfo.STATE_INITED:
			#generous类型的 设定之一：运行时刻 检测
			_check_generous_on_process()
			_check_loop_on_process()
			
			if _current_action:
			
				_current_action.state = ActionInfo.STATE_ING
				_current_action.action_begin_time = OS.get_ticks_msec()
				_current_action.action_pass_time =0
				push_warning("action start.... %s" % CommonTools.get_enum_key_name(Glob.FightMotion,_current_action.base_action))
	#			debug_print()
				action_mng.action_start(_current_action)
			
		elif _current_action.state ==ActionInfo.STATE_ING :

			_current_action.action_pass_time =_current_action.action_pass_time + delta*1000

			if !_current_action.is_loop && _current_action.action_pass_time >= _current_action.action_duration_ms:
				
#				debug_print()
				_current_action.state = ActionInfo.STATE_ENDED
				var finished_Action =_current_action
				self.current_index=current_index+1
				#为了让 使用 current_index 取到的 都是 inited/ing 状态的action
				action_mng.action_finish(finished_Action)
				pass
			else:
				#发射信号 进行中
				#不要在这里做复杂的操作！尽可能在业务完成后取消信号联结
				action_mng.action_process(_current_action)
				
		elif _current_action.state == ActionInfo.STATE_ENDED:
			push_warning("current action state in physics_process is against rule. its STATE_ENDED")
			self.current_index=self.current_index+1
		elif _current_action.state == ActionInfo.STATE_NULL:
			push_warning("current action state in physics_process is against rule. its STATE_NULL")
			self.current_index=self.current_index+1

#一个interupt类型的action 加入队列
func _blind_append_interupt(action:ActionInfo):
	
	var _prv_action =_current_action
	action_array.append(action)
	self.current_index = action_array.size()-1
	
	if _prv_action!=null:
		_prv_action.state =ActionInfo.STATE_INTERUPTED
		action_mng.action_finish(_prv_action)
	

	
