extends ListDataMng

var id2derived={}

func _init():
	file_path="res://resource/config/BaseWeapon.tres"
	data_type=BaseWeapon	


func _ready():
	
	pass
#weapon type 与 对应prototype 的 map
var weapontype2prototype={
	Glob.WeaponType.Jian:"res://FrameWork/Gear/Weapon/SwordPrototype.tscn"
	}



#使用base_gear_id 获得对应的weapon
func get_by_base_gear_id(base_gear_id):
	for _weapon in _list:
		if _weapon.baseGearId == base_gear_id:
			return _weapon
