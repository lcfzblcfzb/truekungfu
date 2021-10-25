class_name BaseFightActionController
extends Node2D

signal NewFightMotion

#位置命名
enum PositionName{
		
	UP_Right=0b100000,
	Mid_Right=0b010000,
	Bot_Right=0b001000,
	Bot_Left=0b000100,
	Mid_Left=0b000010,
	Up_Left=0b000001
	#左侧第一位代表方向。因 UP_Right+Mid_Right= 110000 缺少方向标识，所以定义一个方向位；
	#代表着 相加结果中的高位1 是朝向低位 1 的位置 或者相反；
	#若左侧第一位是1 代表 UP_right->Mid_right;若第一位为0 代表 Mid_right ->Up_right；
	U2M_Right =0b1110000,
	U2B_Right =0b1101000,
	M2U_Right =0b0110000,
	M2B_Right =0b1011000,
	B2U_Right =0b0101000,
	B2M_Right =0b0011000,
	
	U2M_Left =0b0000011,
	U2B_Left =0b0000101,
	M2U_Left =0b1000011,
	M2B_Left =0b0000110,
	B2U_Left =0b1000101,
	B2M_Left =0b1000110,
	
}
var from_byte = 0b1000000;
var to_byte = 0;

#鼠标当前处于 攻击-上 的位置
func _is_attack_up_position(byte)->bool:
	if is_on_left():
		return byte ^ PositionName.Up_Left ==0
		pass
	else:
		return byte ^ PositionName.UP_Right ==0
		pass
#鼠标当前处于 攻击-中 的位置	
func _is_attack_mid_position(byte)->bool:
	if is_on_left():
		return byte ^ PositionName.Mid_Left ==0
		pass
	else:
		return byte ^ PositionName.Mid_Right ==0
		pass
		
#鼠标当前处于 攻击-下 的位置
func _is_attack_bot_position(byte)->bool:
	if is_on_left():
		return byte ^ PositionName.Bot_Left ==0
		pass
	else:
		return byte ^ PositionName.Bot_Right ==0
		pass
	
func _is_attack_u2b(byte):
	if is_on_left():
		return byte ^ PositionName.U2B_Left ==0
		pass
	else:
		return byte ^ PositionName.U2B_Right ==0
		pass
	
func _is_attack_u2m(byte):
	if is_on_left():
		return byte ^ PositionName.U2M_Left ==0
		pass
	else:
		return byte ^ PositionName.U2M_Right ==0
		pass

func _is_attack_m2u(byte):
	if is_on_left():
		return byte ^ PositionName.M2U_Left ==0
		pass
	else:
		return byte ^ PositionName.M2U_Right ==0
		pass
	
func _is_attack_m2b(byte):
	if is_on_left():
		return byte ^ PositionName.M2B_Left ==0
		pass
	else:
		return byte ^ PositionName.M2B_Right ==0
		pass

func _is_attack_b2u(byte):
	if is_on_left():
		return byte ^ PositionName.B2U_Left ==0
		pass
	else:
		return byte ^ PositionName.B2U_Right ==0
		pass
	
func _is_attack_b2m(byte):
	if is_on_left():
		return byte ^ PositionName.B2M_Left ==0
		pass
	else:
		return byte ^ PositionName.B2M_Right ==0
		pass

func _is_def_mid(byte):
	
	if is_on_left():
		return byte ^ PositionName.Mid_Right ==0
		pass
	else:
		return byte ^ PositionName.Mid_Left ==0
		pass
	
	pass

func _is_def_up(byte):
	
	if is_on_left():
		return byte ^ PositionName.UP_Right == 0
	else:
		
		return byte ^ PositionName.Up_Left == 0
	pass
	

func _is_def_bot(byte):
	return byte ^ PositionName.Bot_Right == 0 if is_on_left() else byte^ PositionName.Bot_Left==0
	
	
#攻击指示器出现在角色的左边or右边
#虚拟方法
func is_on_left():
	pass
	
export var MAX_ACTION_ARRAY_SIZE =101	
#动作历史记录
var action_array = []

var current_index = 0
var _current_action:ActionInfo = null
#旧数组数据
var old_array =[]
#对象池
var actionPool = ObjPool.new(ActionInfo)

#待执行数组
var actions_todo =[]

#保持数组长度不超过 MAX_ACTION_ARRAY_SIZE 的长度
#缓存上一个数组的数据
func regist_action(a,duration=1,param:Array=[]):
	#var action =ActionInfo.new(a,OS.get_ticks_msec(),param)
	var input_array = [a,OS.get_ticks_msec(),param,duration]
	var action =actionPool.instance(input_array)
	
	_resize_action_array()
	action_array.append(action)

	emit_signal("NewFightMotion",a)
	return action

#检测下action_array 是否太大，并进行处理
func _resize_action_array():
	if current_index >= MAX_ACTION_ARRAY_SIZE:
		if old_array.size()>0:
			for o in old_array:
				o.dead()
		#current_index 永远指向 下一个等待运行的action/null ;
		#old_array 少加了一个末尾action 是为了在新的action_array中保留一个最后完成的action 方便查询,因此这里使用 current_index-2
		old_array = action_array.slice(0,current_index-2)
		action_array  = action_array.slice(current_index-1,action_array.size())
		#设置index为1，而不是0 ；因为在重组后数组的第1个是上一个状态为完成的;
		current_index = 1

func getCurrentAction():
		
	if _current_action==null:
		_current_action = action_array[current_index]
	
	if _current_action!=null && _current_action.state ==ActionInfo.STATE_ENDED:
		
		if current_index < action_array.size():
			_current_action = action_array[current_index]
		elif current_index== action_array.size():
			_current_action =null
		else:
			#不存在的情况
			push_warning("current_index is somehow over the action_array size.")
			current_index =action_array.size()
			_current_action = null
		pass
	
	pass

func _physics_process(delta):
	
	getCurrentAction()
	
	if _current_action !=null:
		if _current_action.state == ActionInfo.STATE_INITED:
			_current_action.state = ActionInfo.STATE_ING
			_current_action.action_begin_time = OS.get_ticks_msec()
			_current_action.action_end_time = _current_action.action_begin_time + _current_action.action_duration_ms
		elif _current_action.state ==ActionInfo.STATE_ING :
			print(OS.get_ticks_msec())
			if _current_action.action_end_time <= OS.get_ticks_msec():
				_current_action.state = ActionInfo.STATE_ENDED
				current_index=current_index+1
				pass
		elif _current_action.state == ActionInfo.STATE_ENDED:
			push_warning("current action state in physics_process is against rule. its STATE_ENDED")
			current_index=current_index+1
		elif _current_action.state == ActionInfo.STATE_NULL:
			push_warning("current action state in physics_process is against rule. its STATE_NULL")
			current_index=current_index+1
#action 信息
class ActionInfo :
	extends ObjPool.IPoolAble	
	
	const STATE_NULL=-1
	const STATE_INITED=0
	const STATE_ING=10
	const STATE_ENDED=20
	 
	func _init(pool,params).(pool):
		action_type=params[0]
		action_create_time = params[1]
		param =params[2]
		action_duration_ms = params[3]
		state = STATE_INITED
	pass
	
	var action_type;
	#时间属性
	var action_create_time;
	var action_begin_time;
	var action_end_time;
	var action_duration_ms;
	
	var param;#如果是 run/move 指令，保存方向向量
	
	#保存动作的释放状态。
	#-1: NULL(未初始化，空的状态)
	#0: 初始化 未开始
	#10:进行中
	#20:结束
	var state = STATE_NULL setget _set_state
	
	#进行一个简单的提示，并不强制要求 严格的状态机切换
	func _set_state(s_to):
		
		match s_to:
			STATE_NULL:
				if state == STATE_INITED || state == STATE_ING:
					push_warning("FightControlActionStateShift NoLegal,from: to:")
				pass
			STATE_INITED:
				if state != STATE_NULL:
					push_warning("FightControlActionStateShift NoLegal,from: to:")
				pass
			STATE_ING:
				if state != STATE_INITED:
					push_warning("FightControlActionStateShift NoLegal,from: to:")
				pass
			STATE_ENDED:
				if state != STATE_ING:
					push_warning("FightControlActionStateShift NoLegal,from: to:")
				pass
		state = s_to
		pass
	
	func _clean():
		action_type=null
		action_create_time=null
		param=null
		state = STATE_NULL;
		pass
