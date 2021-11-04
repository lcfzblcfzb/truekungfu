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
		
		#如果当前的ACTION 是 generous 类型,且有下一个action，则直接执行下一个action
		if current_index<action_array.size()-1:
			if _current_action.execution_mod ==ActionInfo.EXEMOD_GENEROUS:
				_current_action.state = ActionInfo.STATE_PASSED
				emit_signal("ActionFinish",_current_action)	
				self.current_index = action_array.size()-1
			
			elif _current_action.group_exe_mod ==ActionInfo.EXEMOD_GENEROUS:
				#若当前action 是 group类型，执行方式是generous：则遍历正在进行和等待进行的成员，中断执行
				var interupt_group_id = _current_action.group_id
				#循环遍历找出与当前group_id 一样的动作进行中止操作;因为是同一组的动作，他们必然都是GENEROUS类型;
				while (true):
					
					if _current_action == null:
						break
					if _current_action.group_id == interupt_group_id:
						_current_action.state = ActionInfo.STATE_PASSED
						emit_signal("ActionFinish",_current_action)	
						self.current_index = action_array.size()-1
					else:
						break	
					pass	
				
				pass
	pass

var _current_action:ActionInfo = null
#旧数组数据
var old_array =[]
#对象池
var actionPool = ObjPool.new(ActionInfo)

#保持数组长度不超过 MAX_ACTION_ARRAY_SIZE 的长度
#缓存上一个数组的数据
func regist_action(a, duration=1, exemod=ActionInfo.EXEMOD_NEWEST,groupId =-1,param:Array=[] ):
	#var action =ActionInfo.new(a,OS.get_ticks_msec(),param)
	print("regist action",a)
	var input_array = [a,OS.get_ticks_msec(),param,duration*1000,exemod,groupId]
	var action =actionPool.instance(input_array)
	
	regist_actioninfo(action)

#注册整个action
func regist_actioninfo(action:ActionInfo):
	
	_resize_action_array()
	
	if current_index>0:
		
		var prv_action = action_array[current_index-1] as ActionInfo
		
		if prv_action.group_id>0:
			_add_to_group(action)
		
		else:
			_add_to_action_array(action)
		
	else:
		_add_to_action_array(action)
	
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
	
	
	pass

#新的action加入到action_array，且前一个action 是 group类型
func _add_to_group(action:ActionInfo):
	#interupt 类型的优先级最高
	if action.execution_mod ==ActionInfo.EXEMOD_INTERUPT :	
		_blind_append_interupt(action)
		return
	
	var prvAction = action_array[current_index-1] as ActionInfo
	if prvAction==null:
		push_error("prv action is null inside add_to_group()")
		return
	
	#若当前的group_exe_mod 是INTERUPT 类型，需要分两种情况
	if action.group_exe_mod ==ActionInfo.EXEMOD_INTERUPT: 
		if prvAction.group_id!= action.group_id:
			#如果前一个并非是同一组，则强行插入group
			_blind_append_interupt(action)
			pass
		else:
			#与非group 的添加判断一致
			_add_to_action_array(action)
			pass
			
		return
	
	#根据前一个的group类型 分别处理
	match prvAction.group_exe_mod:
		ActionInfo.EXEMOD_INTERUPT:
			_add_to_action_array(action)
			pass
		ActionInfo.EXEMOD_SEQ:
			_add_to_action_array(action)
			pass
		ActionInfo.EXEMOD_GENEROUS:
			#这里直接添加，因为GENEROUS的判断在 chek_execution_prority  方法中；
			_add_to_action_array(action)
			pass
		ActionInfo.EXEMOD_NEWEST:
			var prv_group_id = prvAction.group_id
			
			if _current_action !=null:
				
				if prv_group_id == _current_action.group_id && _current_action.state ==ActionInfo.STATE_ING:
					#前一个group 已经正在执行中了。 
					_add_to_action_array(action)
					pass
				else:
					#前一个group 还没有执行。 进行替换工作
					_blind_replace_newest(action,prv_group_id)
					pass
				pass
			pass
	pass

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
	
	if current_index == action_array.size() || current_index ==action_array.size()-1:
		#所有action都执行完，或者没有后续action的情况
		action_array.append(action)	
		return
	elif current_index< (action_array.size()-1):
		#至少有一个未执行的action 情况
		if action.execution_mod ==ActionInfo.EXEMOD_INTERUPT:
			
			_blind_append_interupt(action)
			
		elif action.execution_mod ==ActionInfo.EXEMOD_SEQ:
			
			var back_action = action_array.back() as ActionInfo
			
			if back_action.execution_mod == ActionInfo.EXEMOD_NEWEST:
				action_array.pop_back()
				back_action.dead()
				action_array.append(action)
				pass
#			elif back_action.execution_mod == ActionInfo.EXEMOD_GROUP_NEWEST:
#
#				var old_group_id = back_action.group_id
#				if _current_action.execution_mod==ActionInfo.EXEMOD_GROUP_NEWEST && back_action.group_id ==_current_action.group_id:
#					#前一个 的group  正在执行中。 
#					action_array.append(action)
#				else:
#					#否则就筛选出前一位所有等待的 旧group， 被最新的group 替代
#					action_array.pop_back()
#					back_action.dead()
#
#					var searching = true
#					while searching:
#						var _back_back = action_array.back() as ActionInfo
#						if _back_back.state ==ActionInfo.STATE_INITED && _back_back.execution_mod ==ActionInfo.EXEMOD_GROUP_NEWEST && _back_back.group_id == old_group_id:
#							action_array.pop_back()
#							_back_back.dead()
#						else:
#							searching = false
#					action_array.append(action)
#				pass
			else:
				action_array.append(action)
			pass
			
		elif action.execution_mod ==ActionInfo.EXEMOD_NEWEST:
			
			var back_action = action_array.back() as ActionInfo
			
			if back_action.execution_mod == ActionInfo.EXEMOD_NEWEST:
				action_array.pop_back()
				back_action.dead()
				action_array.append(action)
				pass
#			elif back_action.execution_mod == ActionInfo.EXEMOD_GROUP_NEWEST:
#
#				var old_group_id = back_action.group_id
#				if _current_action.execution_mod==ActionInfo.EXEMOD_GROUP_NEWEST && back_action.group_id ==_current_action.group_id:
#					#前一个 的group  正在执行中。 
#					action_array.append(action)
#				else:
#					#否则就筛选出前一位所有等待的 旧group， 被最新的group 替代
#					action_array.pop_back()
#					back_action.dead()
#
#					var searching = true
#					while searching:
#						var _back_back = action_array.back() as ActionInfo
#						if _back_back.state ==ActionInfo.STATE_INITED && _back_back.group_id == old_group_id:
#							action_array.pop_back()
#							_back_back.dead()
#						else:
#							searching = false
#					action_array.append(action)
				
			else:
				action_array.append(action)
			
			pass
#		elif action.execution_mod ==ActionInfo.EXEMOD_GROUP_NEWEST:
#
#			var back_action = action_array.back() as ActionInfo
#
#			if back_action.execution_mod == ActionInfo.EXEMOD_NEWEST:
#				action_array.pop_back()
#				back_action.dead()
#				action_array.append(action)
#				pass
#			elif back_action.execution_mod ==ActionInfo.EXEMOD_GROUP_NEWEST	:
#
#				if back_action.group_id == action.group_id:
#					action_array.append(action)
#					pass
#
#				else:	
#					var old_group_id = back_action.group_id
#					if _current_action.execution_mod==ActionInfo.EXEMOD_GROUP_NEWEST && back_action.group_id ==_current_action.group_id:
#						#前一个 的group  正在执行中。 
#						action_array.append(action)
#					else:
#						#否则就筛选出前一位所有等待的 旧group， 被最新的group 替代
#						action_array.pop_back()
#						back_action.dead()
#
#						var searching = true
#						while searching:
#							var _back_back = action_array.back() as ActionInfo
#							if _back_back.state ==ActionInfo.STATE_INITED && _back_back.group_id == old_group_id:
#								action_array.pop_back()
#								_back_back.dead()
#							else:
#								searching = false
#						action_array.append(action)
#
#			else:
#				action_array.append(action)
#			pass
		elif action.execution_mod == ActionInfo.EXEMOD_GENEROUS:
			
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

func _physics_process(delta):
	
	if _current_action !=null:
		if _current_action.state == ActionInfo.STATE_INITED:
			
			#exemod = generous类型的判断
			if _current_action.execution_mod == ActionInfo.EXEMOD_GENEROUS:
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
