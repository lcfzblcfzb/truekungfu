extends AnimatedSprite

onready var sword = $sword
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	sword.swingLeft(PI)
	


func _on_Area2D_area_entered(area):
	print("player hit ")


func _on_AnimationPlayer_animation_finished(anim_name, extra_arg_0):
	sword.swingLeft(PI)


func _on_swordBox_area_entered(area):
	sword.monitaling(false)
	print("enermy hit player sword")
	print(area)
	print(sword)
