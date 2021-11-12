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

