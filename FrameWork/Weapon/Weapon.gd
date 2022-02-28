extends Node2D

class_name Weapon

enum Direction{
	UP,CENTER,DOWN
}

var peace_transform = Transform2D(deg2rad(-110),Vector2(1,0))
var engaged_transform = Transform2D(deg2rad(115),Vector2(0,0))

#StandarCharactorCharactor.BodySlotEnum
var slot_id

var attached_charactor:StandarCharactor

export(int) var state = StandarCharactor.CharactorState.Peace setget to_state

func to_state(s):
	_on_to_state(s)
	match s:
		StandarCharactor.CharactorState.Peace:
			transform =peace_transform
			pass
		StandarCharactor.CharactorState.Engaged:
			transform =engaged_transform
			pass
	state = s

func add_to_charactor(charactor):
	pass

func _on_to_state(s):
	pass

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
	

func self_attach_to_charactor(attached_charactor):
	pass
