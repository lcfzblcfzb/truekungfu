extends Weapon

#onready var sword_left_hand = $sword_left_hand
onready var sword_right_hand = $sword_right_hand
onready var sword_sheath = $sword_sheath

var	peace_transform = Transform2D(deg2rad(-110),Vector2(0,1))
var	engaged_transform = Transform2D(deg2rad(120),Vector2(0,0))
var sheath_engaged_transform =Transform2D(deg2rad(-120),Vector2(3.5,-1))

func _on_to_state(s):
	
	match s:
		StandarCharactor.CharactorState.Peace:
			sword_right_hand.get_parent().visible = false
#			sword_left_hand.visible = true
#			sword_left_hand.get_parent().transform = peace_transform
			sword_sheath.get_parent().transform = peace_transform
			pass
		StandarCharactor.CharactorState.Engaged:
			sword_right_hand.get_parent().visible = true
#			sword_left_hand.visible = false
			sword_right_hand.get_parent().transform = engaged_transform
			sword_sheath.get_parent().transform = sheath_engaged_transform
			pass

func on_add_to_charactor(_charactor:StandarCharactor):
#	remove_child(sword_left_hand)
#	_charactor.add_to_body(StandarCharactor.CharactorBodySlotEnum.Left_Weapon , sword_left_hand )
	remove_child(sword_sheath)
	_charactor.add_to_body(StandarCharactor.CharactorBodySlotEnum.Left_Weapon , sword_sheath )
	remove_child(sword_right_hand)
	_charactor.add_to_body(StandarCharactor.CharactorBodySlotEnum.Right_Weapon , sword_right_hand )
	pass

func on_remove_from_charactor(_charactor:StandarCharactor):
#	sword_left_hand.get_parent().remove_child(sword_left_hand)
	sword_right_hand.get_parent().remove_child(sword_right_hand)
	sword_sheath.get_parent().remove_child(sword_sheath)
	pass
