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
#旧数组数据
var old_array =[]
#对象池
var actionPool = ObjPool.new(ActionInfo)
#保持数组长度不超过 MAX_ACTION_ARRAY_SIZE 的长度
#缓存上一个数组的数据
func regist_action(a,param=null):
	#var action =ActionInfo.new(a,OS.get_ticks_msec(),param)
	var action =actionPool.instance([a,OS.get_ticks_msec(),param])
	if action_array.size() >= MAX_ACTION_ARRAY_SIZE:
		var last  = action_array.pop_back()
		if old_array.size()>0:
			for o in old_array:
				o.dead()
				
		old_array = action_array
		action_array = [last,action]
	else:		
		action_array.append(action)

	emit_signal("NewFightMotion",a)
#action 信息
class ActionInfo :
	extends ObjPool.IPoolAble	
	
	func _init(pool,params).(pool):
		action_type=params[0]
		action_begin = params[1]
		param =params[2]
	pass
	
	var action_type;
	var action_begin;
	var param;#如果是 run/move 指令，保存方向向量
	
	func _clean():
		action_type=null
		action_begin=null
		param=null
		pass
