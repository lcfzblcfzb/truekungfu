class_name StandarCharactor

extends Sprite

# Tool.CharactorEnum
var charactor_type 
#就是 SpriteAnimation 节点
var animation_node
# 数组
var _gears_array:Array

#身体部位的枚举
enum CharactorBodySlotEnum{
	
	Hip=10,
	
	Left_Thigh = 20,	
	Left_Shank = 21,
	Left_Foot = 22,
	
	Right_Thigh = 30,
	Right_Shank = 31,
	Right_Foot = 32,
	
	Body = 40,
	
	Left_Upper_Arm = 50,
	Left_Fore_Arm = 51,
	Left_Hand =52,
	
	Right_Upper_Arm = 60,
	Right_Fore_Arm = 61,
	Right_Hand = 62,
	
	Head = 70
}

#可以理解为关键帧
export(int) var state setget set_state;

func set_state(s):
	state = s
	
	for part in _gears_array:
		part.to_state(s)
	pass

enum CharactorState{
	Peace=1,
	Engaged=2
	
}

#添加一个装备
func add_gear(gear):
	if _gears_array.has(gear):
		return
	_gears_array.append(gear)
	add_child(gear)
	gear._attach_charactor = self
	gear.on_add_to_charactor(self)
	
func remove_gear(gear):
	var idx =_gears_array.find(gear)
	if idx>=0:
		_gears_array.remove(idx)
		remove_child(gear)
		gear._attach_charactor = null
		gear.on_remove_from_charactor(self)
		

#animationPlayer中 由call_method_track 调用的方法
#做一个代理调用方法
func animation_call_method(args1):
	animation_node.emit_signal("AnimationCallMethod",args1)
	pass

#加一个部位
func add_to_body(slot_id:int, part , front = true):
	
	var to_part = get_body_part_by_id(slot_id)
	if to_part:
		to_part.add_child(part)
		if !front:
			part.show_behind_parent = true
	
	
func get_body_part_by_id(slot_id):
	
	match slot_id:
		CharactorBodySlotEnum.Body:
			return $body
		CharactorBodySlotEnum.Head:
			return $body/head
		CharactorBodySlotEnum.Hip:
			return self
			pass
		CharactorBodySlotEnum.Left_Thigh:
			return $left_thigh
			pass
		CharactorBodySlotEnum.Left_Shank:
			return $left_thigh/left_shank
			pass
		CharactorBodySlotEnum.Left_Foot:
			return $left_thigh/left_shank/left_foot
			pass
		CharactorBodySlotEnum.Right_Thigh:
			return $right_thigh
			pass
		CharactorBodySlotEnum.Right_Shank:
			return $right_thigh/right_shank
			pass
		CharactorBodySlotEnum.Right_Foot:
			return $right_thigh/right_shank/right_foot
			pass
		CharactorBodySlotEnum.Left_Upper_Arm:
			return $body/left_upper_arm
			pass
		CharactorBodySlotEnum.Left_Fore_Arm:
			return $body/left_upper_arm/left_fore_arm
			pass
		CharactorBodySlotEnum.Left_Hand:
			return $body/left_upper_arm/left_fore_arm/left_hand
			pass	
		CharactorBodySlotEnum.Right_Upper_Arm:
			return $body/right_upper_arm
			pass
		CharactorBodySlotEnum.Right_Fore_Arm:
			return $body/right_upper_arm/right_fore_arm
			pass
		CharactorBodySlotEnum.Right_Hand:
			return $body/right_upper_arm/right_fore_arm/right_hand
			pass	
