extends Node2D

export (NodePath)var tn 
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func change_face_direction(face):
	
	if face>0:
		$Sprite.flip_h = false
	elif face<0:
		$Sprite.flip_h = true
	print("change face direction",face,$Sprite.frame)
	print("current time scale",get_node(tn).get("parameters/TimeScale/scale"))
	pass

func _on_FightKinematicMovableObj_Charactor_Face_Direction_Changed(direction):
	
	change_face_direction(direction.x)
