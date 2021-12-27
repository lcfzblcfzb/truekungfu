extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	var v =  body.get_velocity() as Vector2
	if v and v.y>0 :
		body.set("is_on_platform" , true)
	
func _on_Area2D_body_exited(body):
	body.set("is_on_platform" , false)
