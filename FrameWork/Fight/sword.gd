extends RigidBody2D

var isFloating = true
var floatForceAdded = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _integrate_forces(physics2dDirectBodyState:Physics2DDirectBodyState):
	if isFloating && !floatForceAdded:
		
		physics2dDirectBodyState.add_central_force(physics2dDirectBodyState.total_gravity.rotated(PI))
		floatForceAdded = true
	#physics2dDirectBodyState.transform = Transform2D.IDENTITY
