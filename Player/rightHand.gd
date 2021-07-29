extends Sprite

signal block_end

onready var animationPlayer = $AnimationPlayer
onready var shape2d =$Weapon/CollisionShape2D
var  weaponOffset :float = -40.0/180.0*PI

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#attack:
func attack(dir:float=0):
	rotation = dir+weaponOffset	
	
func block_end():
	
	emit_signal("block_end")

func _on_Weapon_area_entered(area):
		if area is Weapon:
			print("weapon hit weapon")
			#shape2d.set_deferred("disabled",true)
			#var  sec = animationPlayer.current_animation_position
			#animationPlayer.play("swingBlocked")
			#animationPlayer.seek(animationPlayer.current_animation_length-sec)
	
