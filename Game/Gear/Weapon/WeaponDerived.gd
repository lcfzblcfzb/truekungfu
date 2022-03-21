class_name WeaponDerived

extends Weapon

var proxy_weapon:Weapon

func get_WeaponBox():
	return proxy_weapon.weapon_box


func to_state(s):
	proxy_weapon.to_state(s)

func _on_to_state(s):
	proxy_weapon._on_to_state(s)
#装备的回调方法
func on_add_to_charactor(_charactor):
	proxy_weapon.on_add_to_charactor(_charactor)

func on_remove_from_charactor(_charactor):
	proxy_weapon.on_remove_from_charactor(_charactor)
	
func on_actioninfo_start(action:ActionInfo):
	proxy_weapon.on_actioninfo_start(action)
	
#同上 是 end 方法的回调
func on_actioninfo_end(action:ActionInfo):
	proxy_weapon.on_actioninfo_end(action)
