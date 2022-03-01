extends Weapon

onready var sword_left_hand = $sword_left_hand
onready var sword_right_hand = $sword_right_hand

var	peace_transform = Transform2D(deg2rad(-110),Vector2(1,0))
var	engaged_transform = Transform2D(deg2rad(120),Vector2(0,0))
	

func _on_to_state(s):
	
	match s:
		StandarCharactor.CharactorState.Peace:
			sword_right_hand.visible = false
			sword_left_hand.visible = true
			sword_left_hand.transform = peace_transform
			pass
		StandarCharactor.CharactorState.Engaged:
			sword_right_hand.visible = true
			sword_left_hand.visible = false
			sword_right_hand.transform = engaged_transform
			pass

func on_add_to_charactor(_charactor:StandarCharactor):
	remove_child(sword_left_hand)
	_charactor.add_to_body(StandarCharactor.CharactorBodySlotEnum.Left_Hand , sword_left_hand )
	remove_child(sword_right_hand)
	_charactor.add_to_body(StandarCharactor.CharactorBodySlotEnum.Right_Hand , sword_right_hand )
	pass

func on_remove_from_charactor(_charactor:StandarCharactor):
	pass
