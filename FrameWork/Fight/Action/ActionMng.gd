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
		
		print("generous_state",_current_action.state)
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
		
		if back.execution_mod == ActionInfo.EXEMOD_INTERUPT:
			if back !=_current_action:
				_current_action.state = ActionInfo.STATE_INTERUPTED
				emit_signal("ActionFinish",_current_action)	
				
				self.current_index = action_array.size()-1
		
		#如果当前的ACTION 是 generous 类型,且有下一个action，则直接执行下一个action
		if current_index<action_array.size()-1:
			if _current_action.execution_mod ==ActionInfo.EXEMOD_GENEROUS:
				_current_action.state = ActionInfo.STATE_INTERUPTED
				emit_signal("ActionFinish",_current_action)	
				self.current_index = action_array.size()-1
		
	pass

var _current_action:ActionInfo = null
#旧数组数据
var old_array =[]
#对象池
var actionPool = ObjPool.new(ActionInfo)

#保持数组长度不超过 MAX_ACTION_ARRAY_SIZE 的长度
#缓存上一个数组的数据
func regist_action(a,duration=1, exemod=ActionInfo.EXEMOD_NEWEST,groupId =-1,param:Array=[] ):
	#var action =ActionInfo.new(a,OS.get_ticks_msec(),param)
	print("regist action",a)
	var input_array = [a,OS.get_ticks_msec(),param,duration*1000,exemod,groupId]
	var action =actionPool.instance(input_array)
	
	_resize_action_array()
	
	_add_to_action_array(action)
	
	updateCurrentAction()
	
	chek_execution_prority()
	
	#打印一些数据
	var n =  10  if  action_array.size()>10 else action_array.size()
	var s =''
	for i in n:
		a = action_array[-(i+1)]
		var baseAction =FightBaseActionMng.dict.get(a.base_action)
		s = s+"[" +baseAction.animation_name+"]"
		pass
		
	print(s)
	
	emit_signal("NewFightMotion",a)
	return action

#新的action输入
func _add_to_action_array(action:ActionInfo):
	
	if current_index == action_array.size() || current_index ==action_array.size()-1:
		#所有action都执行完，或者没有后续action的情况
		action_array.append(action)	
		return
	elif current_index< (action_array.size()-1):
		#至少有一个未执行的action 情况
		if action.execution_mod ==ActionInfo.EXEMOD_INTERUPT:
			
			if _current_action!=null:
				_current_action.state =ActionInfo.STATE_INTERUPTED
				emit_signal("ActionFinish",_current_action)
			
			var sliced_actions = action_array.slice(current_index,action_array.size())
			action_array.resize(current_index)
			action_array.append(action)
			#回归下对象池
			for sa in sliced_actions:
				sa.dead()
			
		elif action.execution_mod ==ActionInfo.EXEMOD_SEQ:
			
			var back_action = action_array.back() as ActionInfo
			
			if back_action.execution_mod == ActionInfo.EXEMOD_NEWEST:
				action_array.pop_back()
				back_action.dead()
				action_array.append(action)
				pass
			elif back_action.execution_mod == ActionInfo.EXEMOD_GROUP_NEWEST:
				
				var old_group_id = back_action.group_id
				if _current_action.execution_mod==ActionInfo.EXEMOD_GROUP_NEWEST && back_action.group_id ==_current_action.group_id:
					#前一个 的group  正在执行中。 
					action_array.append(action)
				else:
					#否则就筛选出前一位所有等待的 旧group， 被最新的group 替代
					action_array.pop_back()
					back_action.dead()
					
					var searching = true
					while searching:
						var _back_back = action_array.back() as ActionInfo
						if _back_back.state ==ActionInfo.STATE_INITED && _back_back.execution_mod ==ActionInfo.EXEMOD_GROUP_NEWEST && _back_back.group_id == old_group_id:
							action_array.pop_back()
							_back_back.dead()
						else:
							searching = false
					action_array.append(action)
				pass
				 
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
			elif back_action.execution_mod == ActionInfo.EXEMOD_GROUP_NEWEST:
				
				var old_group_id = back_action.group_id
				if _current_action.execution_mod==ActionInfo.EXEMOD_GROUP_NEWEST && back_action.group_id ==_current_action.group_id:
					#前一个 的group  正在执行中。 
					action_array.append(action)
				else:
					#否则就筛选出前一位所有等待的 旧group， 被最新的group 替代
					action_array.pop_back()
					back_action.dead()
					
					var searching = true
					while searching:
						var _back_back = action_array.back() as ActionInfo
						if _back_back.state ==ActionInfo.STATE_INITED && _back_back.group_id == old_group_id:
							action_array.pop_back()
							_back_back.dead()
						else:
							searching = false
					action_array.append(action)
				
			else:
				action_array.append(action)
			
			pass
		elif action.execution_mod ==ActionInfo.EXEMOD_GROUP_NEWEST:
			
			var back_action = action_array.back() as ActionInfo
			
			if back_action.execution_mod == ActionInfo.EXEMOD_NEWEST:
				action_array.pop_back()
				back_action.dead()
				action_array.append(action)
				pass
			elif back_action.execution_mod ==ActionInfo.EXEMOD_GROUP_NEWEST	:
				
				if back_action.group_id == action.group_id:
					action_array.append(action)
					pass
				
				else:	
					var old_group_id = back_action.group_id
					if _current_action.execution_mod==ActionInfo.EXEMOD_GROUP_NEWEST && back_action.group_id ==_current_action.group_id:
						#前一个 的group  正在执行中。 
						action_array.append(action)
					else:
						#否则就筛选出前一位所有等待的 旧group， 被最新的group 替代
						action_array.pop_back()
						back_action.dead()
						
						var searching = true
						while searching:
							var _back_back = action_array.back() as ActionInfo
							if _back_back.state ==ActionInfo.STATE_INITED && _back_back.group_id == old_group_id:
								action_array.pop_back()
								_back_back.dead()
							else:
								searching = false
						action_array.append(action)
						
			else:
				action_array.append(action)
			pass
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
