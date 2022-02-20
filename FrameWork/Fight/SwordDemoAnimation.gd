extends Node2D

signal Hit
signal Hurt

export (NodePath)var fight_component_path

var fight_component:FightComponent_human 

onready var weapon_box:WeaponBox = $weapon_box 
onready var hurt_box:HurtBox = $hurt_box

func _ready():
	fight_component = get_node(fight_component_path)
	$hurt_box.fight_cpn = fight_component
	
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

func _physics_process(delta):
	#检测武器实时碰撞
	if weapon_box.monitoring :
		var list =weapon_box.get_overlapping_areas()
		if list.size()>0:
			emit_signal("Hit",list)	
			weapon_box.set_deferred("monitoring",false)
			
	
	if hurt_box.monitoring :
		var list =hurt_box.get_overlapping_areas()
		if list.size()>0:
			
			for area in list:
				var fight_cpn = area.fight_cpn
				fight_cpn.sprite_animation.weapon_box.set_deferred("monitorable",false)
				pass
			
			emit_signal("Hurt",list)	

func _on_weapon_box_area_entered(area):
	pass # Replace with function body.


func _on_hurt_box_area_entered(area):
	pass
