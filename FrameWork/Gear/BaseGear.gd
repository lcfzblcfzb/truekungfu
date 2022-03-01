class_name BaseGear
extends Node2D
#被装备对象
var _attach_charactor;

export(int) var state = StandarCharactor.CharactorState.Peace setget to_state

func to_state(s):
	_on_to_state(s)
	state = s

func _on_to_state(s):
	pass
#装备的回调方法
func on_add_to_charactor(_charactor):
	pass

func on_remove_from_charactor(_charactor):
	pass
