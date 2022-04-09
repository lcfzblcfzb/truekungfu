class_name StandarCharactor

extends Node2D

# Glob.CharactorEnum
export (Glob.CharactorEnum) var charactor_type 
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
	Left_Weapon=53,
	
	Right_Upper_Arm = 60,
	Right_Fore_Arm = 61,
	Right_Hand = 62,
	Right_Weapon = 63,
	
	Head = 70
}

#改变hurt_box 的反伤类型
#改变weapon_box 的伤害类型
#Glob.CounterDamageType
func change_gear_state(_code):
	var active_weapon = _get_active_weapon()
	match _code:
		Glob.AnimationMethodType.BlockStart:
			$hurt_box.counter_attack_type = Glob.CounterDamageType.Block
		Glob.AnimationMethodType.BlockEnd:
			$hurt_box.counter_attack_type = Glob.CounterDamageType.AutoBlock
		Glob.AnimationMethodType.DodgeStart:
			$hurt_box.counter_attack_type = Glob.CounterDamageType.Dodge
		Glob.AnimationMethodType.DodgeEnd:
			$hurt_box.counter_attack_type = Glob.CounterDamageType.AutoBlock
		Glob.AnimationMethodType.RollStart:
			$hurt_box.counter_attack_type = Glob.CounterDamageType.Rolling
		Glob.AnimationMethodType.RollEnd:
			$hurt_box.counter_attack_type = Glob.CounterDamageType.AutoBlock
			
		Glob.AnimationMethodType.AttackCiStart:
			active_weapon.weapon_box.damage_type = Glob.DamageType.Ci
			active_weapon.weapon_box.start_monitoring()
		Glob.AnimationMethodType.AttackCiEnd:
			active_weapon.weapon_box.damage_type = -1
			active_weapon.weapon_box.stop_monitoring()
		Glob.AnimationMethodType.AttackPiStart:
			active_weapon.weapon_box.damage_type = Glob.DamageType.Pi
			active_weapon.weapon_box.start_monitoring()
		Glob.AnimationMethodType.AttackPiEnd:
			active_weapon.weapon_box.damage_type = -1
			active_weapon.weapon_box.stop_monitoring()
		Glob.AnimationMethodType.AttackSaoStart:
			active_weapon.weapon_box.damage_type = Glob.DamageType.Sao
			active_weapon.weapon_box.start_monitoring()
		Glob.AnimationMethodType.AttackSaoEnd:
			active_weapon.weapon_box.damage_type = -1
			active_weapon.weapon_box.stop_monitoring()
#处于active 状态下 的weapon	
func _get_active_weapon()->Weapon:
	
	for g in _gears_array:
		if g is Weapon and g.active:
			return g
	
	return null

#可以理解为关键帧
export(int) var state setget set_state;

func set_state(s):
	state = s
	
	for part in _gears_array:
		part.to_state(s)
	pass

#用来设定一个固定状态，使所有部件保持某个位置
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
	
	
func remove_gear(gear):
	var idx =_gears_array.find(gear)   
	if idx>=0:
		_gears_array.remove(idx)
		remove_child(gear)
		


#加一个部位
func add_to_body(slot_id:int, part , front = true):
	
	var to_part = get_body_part_by_id(slot_id)
	if to_part:
		to_part.add_child(part)
		if !front:
			part.show_behind_parent = true

func get_hurt_box()->HurtBox:
	return $hurt_box as HurtBox

func get_animation_root():
	return $hip

func get_body_part_by_id(slot_id):
	
	match slot_id:
		CharactorBodySlotEnum.Body:
			return $hip/body
		CharactorBodySlotEnum.Head:
			return $hip/body/head
		CharactorBodySlotEnum.Hip:
			return $hip
			pass
		CharactorBodySlotEnum.Left_Thigh:
			return $hip/left_thigh
			pass
		CharactorBodySlotEnum.Left_Shank:
			return $hip/left_thigh/left_shank
			pass
		CharactorBodySlotEnum.Left_Foot:
			return $hip/left_thigh/left_shank/left_foot
			pass
		CharactorBodySlotEnum.Right_Thigh:
			return $hip/right_thigh
			pass
		CharactorBodySlotEnum.Right_Shank:
			return $hip/right_thigh/right_shank
			pass
		CharactorBodySlotEnum.Right_Foot:
			return $hip/right_thigh/right_shank/right_foot
			pass
		CharactorBodySlotEnum.Left_Upper_Arm:
			return $hip/body/left_upper_arm
			pass
		CharactorBodySlotEnum.Left_Fore_Arm:
			return $hip/body/left_upper_arm/left_fore_arm
			pass
		CharactorBodySlotEnum.Left_Hand:
			return $hip/body/left_upper_arm/left_fore_arm/left_hand
		CharactorBodySlotEnum.Left_Weapon:
			return $hip/body/left_upper_arm/left_fore_arm/left_hand/left_weapon
			pass	
		CharactorBodySlotEnum.Right_Upper_Arm:
			return $hip/body/right_upper_arm
			pass
		CharactorBodySlotEnum.Right_Fore_Arm:
			return $hip/body/right_upper_arm/right_fore_arm
			pass
		CharactorBodySlotEnum.Right_Hand:
			return $hip/body/right_upper_arm/right_fore_arm/right_hand
			pass
		CharactorBodySlotEnum.Right_Weapon:
			return $hip/body/right_upper_arm/right_fore_arm/right_hand/right_weapon		
