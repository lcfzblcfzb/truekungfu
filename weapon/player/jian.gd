extends Weapon

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
	
