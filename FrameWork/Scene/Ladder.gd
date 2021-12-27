extends Node2D

func _on_Area2D_body_entered(body):
	
	body.set("is_climbing" , true)

func _on_Area2D_body_exited(body):
	body.set("is_climbing" , false)
