extends Node2D

export (NodePath)var fight_component_path

var fight_component:FightComponent_human 

func _ready():
	fight_component = get_node(fight_component_path)
	$hurtbox.fight_cpn = fight_component
	
	change_face_direction(1)

func set_sprite_texture(tex):
	$Sprite.texture = tex

func change_face_direction(face):
	
	if face>0:
		scale.x = 1
	elif face<0:
		scale.x = -1
	print("change face direction",face)
	pass

func _on_FightKinematicMovableObj_Charactor_Face_Direction_Changed(direction):
	
	change_face_direction(direction.x)
