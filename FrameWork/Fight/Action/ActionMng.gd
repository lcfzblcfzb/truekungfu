class_name FightActionMng

extends Node

var global_group_id = 100

func next_group_id():
	global_group_id = global_group_id+1
	return global_group_id

export var MAX_ACTION_ARRAY_SIZE =101
#动作历史记录
var action_array = []

var current_index = 0 setget set_current_index

func set_current_index(idx):
	current_index = idx
	updateCurrentAction()

#set 当前索引的时候，更新下当前action
func updateCurrentAction():

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

	pass

#检测执行顺序如果有STATE_INTERUPTED 类型的就直接执行
func chek_execution_prority():

	if current_index <action_array.size():

		var back = action_array.back() as ActionInfo
		#如果最后一个动作是INTERUPT 模式；
		#则执行 抢占式操作,并将current_index 设置成此动作;
		if back.execution_mod == ActionInfo.EXEMOD_INTERUPT || back.group_exe_mod ==ActionInfo.EXEMOD_INTERUPT:
			if back !=_current_action:
				_current_action.state = ActionInfo.STATE_INTERUPTED
				emit_signal("ActionFinish",_current_action)

				self.current_index = action_array.size()-1
		#检测是否当前的action是generous
		_check_generous_on_add()
	pass

var _current_action:ActionInfo = null
#旧数组数据
var old_array =[]
#对象池
var actionPool = ObjPool.new(ActionInfo)

#保持数组长度不超过 MAX_ACTION_ARRAY_SIZE 的长度
#缓存上一个数组的数据
# Deprecated
func regist_action(a, duration=1, exemod=ActionInfo.EXEMOD_NEWEST,groupId =-1,param:Array=[] ):
	#var action =ActionInfo.new(a,OS.get_ticks_msec(),param)
	print("regist action",a)
	var input_array = [a ,OS.get_ticks_msec(),param,duration*1000,exemod,groupId]
	var action =actionPool.instance(input_array)

	regist_actioninfo (action)

#注册整个action
func regist_actioninfo(action:ActionInfo):

	_resize_action_array()

	_add_action(action)

	updateCurrentAction()

	chek_execution_prority()

	#打印一些数据
	var n =  10  if  action_array.size()>10 else action_array.size()
	var s =''
	for i in n:
		var a = action_array[-(i+1)] as ActionInfo
		var baseAction =FightBaseActionMng.dict.get(a.base_action)
		if a.state ==ActionInfo.STATE_ING:
			s = s+"[current -> :" +baseAction.animation_name+"]"
			pass
		else:
			s = s+"["+a.state as String +baseAction.animation_name+"]"
		pass

	print(s)

	emit_signal("NewFightMotion",action.base_action)
	return action

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
	
	if action.group_id>0 && action.group_exe_mod==ActionInfo.EXEMOD_INTERUPT && prvAction.group_id!=action.group_id:
		return true
	
	if action.group_id>0 && action.execution_mod==ActionInfo.EXEMOD_INTERUPT && prvAction.group_id!=action.group_id:
		return true
		
	#ATTENTION: 有一种特殊情况是 interrupt出现在 组合的中间的时候，是被当作SEQ 类型一样的处理的
	return false


func _add_action(action:ActionInfo):
	
	if current_index<=action_array.size()-1:
		# A:前一个有待执行的活动
		
		var prv_action = action_array.back() as ActionInfo
		
		if _is_interrupt_mod(action,prv_action):
			#抢占式
			_blind_append_interupt(action)
			pass
		else:
			
			if prv_action.group_id>0:
				_add_to_group(action)
				pass
			else:
				_add_to_action_array(action)
				pass

			pass
		
		pass
	else:
		# B:没有前一个活动
		action_array.append(action)
		pass
	
	pass

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
#新的action加入到action_array，且前一个action 是 group类型
func _add_to_group(action:ActionInfo):
	
	var prvAction = action_array.back() as ActionInfo
	if prvAction==null:
		push_error("prv action is null inside add_to_group()")
		return

	#根据前一个的group类型 分别处理
	if prvAction.group_exe_mod == ActionInfo.EXEMOD_NEWEST:
		var prv_group_id = prvAction.group_id

		if _is_action_group_playing(prvAction) || prv_group_id == action.group_id:
			
			#前一个group 已经正在执行中了。
			_add_to_action_array(action)
			pass
		else:
			#前一个group 还没有执行。 进行替换工作
			_blind_replace_newest(action,prv_group_id)
			pass
		
	else:
		_add_to_action_array(action)
  
#替换newest
#blind 函数：默认 prv_action.group_id>0; prv_action.group_exe_mod = NEWEST
#action 是新增的参数；且紧接的是exemod==newest 模式的动作
func _blind_replace_newest(action,prv_group_id):

	while true:
		var prv_action = action_array.back() as ActionInfo
		if prv_action ==null:
			break
		if prv_action.group_id != prv_group_id:
			break

		action_array.pop_back()
		prv_action.dead()

	action_array.append(action)

#新的action输入
# ATTENTION:若是在add_to_group 中调用，则是表示已经处理完group_exe_mod 优先级，现在开始处理group内 的单个action 的优先级
func _add_to_action_array(action:ActionInfo):

	var back_action = action_array.back() as ActionInfo

	if back_action.execution_mod == ActionInfo.EXEMOD_NEWEST:
		action_array.pop_back()
		back_action.dead()
		action_array.append(action)
		pass
	else:
		action_array.append(action)
	pass


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
func _check_generous_on_add():
	
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
					tmp_action.action_end_time = OS.get_ticks_msec()
					emit_signal("ActionFinish",_current_action)
					self.current_index = current_index+1
					pass
				else:
					break
	#exemod = generous类型的判断
	elif _current_action.execution_mod == ActionInfo.EXEMOD_GENEROUS:
		if current_index< (action_array.size()-1):
			var next_action = action_array[current_index+1] as ActionInfo
			if ! next_action.base_action in _current_action.not_generous_type:

				_current_action.state = ActionInfo.STATE_PASSED
				_current_action.action_end_time = OS.get_ticks_msec()
				emit_signal("ActionFinish",_current_action)

				self.current_index = current_index+1
				pass
			pass
		pass
	pass

#在运行的时刻，检测generous
#ATTENTION! 此时需要检测 连续的generous的情形
func _check_generous_on_process():
	
	if current_index>=action_array.size()-1 || !is_generous_type(_current_action):
		return

	var foundIndex = current_index;
	
	#在循环中记录 找到的 GENEROUS类型的 group_id和第一个成员所处的Index,
	var found_group_id = -1
	var found_group_index = -1
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
		_current_action.action_end_time = OS.get_ticks_msec()
		emit_signal("ActionFinish",_current_action)
		self.current_index = current_index+1
		
		pass

func _physics_process(delta):

	if _current_action !=null:
		if _current_action.state == ActionInfo.STATE_INITED:
			#generous类型的 设定之一：运行时刻 检测
			_check_generous_on_process()
			
			_current_action.state = ActionInfo.STATE_ING
			_current_action.action_begin_time = OS.get_ticks_msec()
			_current_action.action_end_time = _current_action.action_begin_time + _current_action.action_duration_ms

			emit_signal("ActionStart",_current_action)
		elif _current_action.state ==ActionInfo.STATE_ING :

			if !_current_action.is_loop && _current_action.action_end_time <= OS.get_ticks_msec():
				_current_action.state = ActionInfo.STATE_ENDED
				var finished_Action =_current_action
				self.current_index=current_index+1
				#为了让 使用 current_index 取到的 都是 inited/ing 状态的action
				emit_signal("ActionFinish",finished_Action)
				pass

		elif _current_action.state == ActionInfo.STATE_ENDED:
			push_warning("current action state in physics_process is against rule. its STATE_ENDED")
			self.current_index=self.current_index+1
		elif _current_action.state == ActionInfo.STATE_NULL:
			push_warning("current action state in physics_process is against rule. its STATE_NULL")
			self.current_index=self.current_index+1

#一个interupt类型的action 加入队列
func _blind_append_interupt(action:ActionInfo):
	if _current_action!=null:
			_current_action.state =ActionInfo.STATE_INTERUPTED
			emit_signal("ActionFinish",_current_action)

	var sliced_actions = action_array.slice(current_index,action_array.size())
	action_array.resize(current_index)
	action_array.append(action)
	#回归下对象池
	for sa in sliced_actions:
		sa.dead()
