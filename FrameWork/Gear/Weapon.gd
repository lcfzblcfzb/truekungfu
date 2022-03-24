extends Gear
class_name Weapon

#static

var base_weapon_id
var _base_weapon_obj:BaseWeapon

#dynamic

var weapon_box:WeaponBox setget ,getWeaponBox
#是否 是正在使用的武器
var active = false setget set_active,get_active

func init(base_gear:BaseGear,fcpn):
	.init(base_gear,fcpn)
	
	_base_weapon_obj = BaseWeaponDmg.get_by_base_gear_id(base_gear.id)
	base_weapon_id = _base_weapon_obj.id

func set_active(a):
	on_active(a)
	active =a
	
func get_active():
	
	return active

func get_base_weapon()->BaseWeapon:
	if not _base_weapon_obj:
		_base_weapon_obj = BaseWeaponDmg.get_by_id(base_weapon_id)
	return _base_weapon_obj

func getWeaponBox():
	
	return weapon_box

func on_active(a):
	
	pass


enum Direction{
	UP,CENTER,DOWN
}
#防御
func defence(d):
	push_warning("defence not implemented .")
	pass

#重攻击
func heavyAttack(d):
	push_warning("heavyAttack not implemented .")
	pass
#轻攻击
func lightAttck(d):
	push_warning("lightAttck not implemented .")
	pass

#defBox 自动防御的区域
func defDirection(direction:Vector2):
	pass
	
