extends Node2D

export (NodePath)var fight_component_path

var fight_component:FightComponent_human 

func _ready():
	fight_component = get_node(fight_component_path)
	$hurtbox.fight_cpn = fight_component
	$weaponBox.fight_cpn = fight_component


func change_face_direction(face):
	
	if face>0:
		$Sprite.flip_h = false
	elif face<0:
		$Sprite.flip_h = true
	print("change face direction",face,$Sprite.frame)
	pass

func _on_FightKinematicMovableObj_Charactor_Face_Direction_Changed(direction):
	
	change_face_direction(direction.x)
