extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


class LeftAction :
	extends "res://FrameWork/InputAction.gd"
	
	func doAction():
		print("do left")
	

class RightAction :
	extends "res://FrameWork/InputAction.gd"
	
	func doAction():
		print("do right")


class UpAction :
	extends "res://FrameWork/InputAction.gd"
	
	func doAction():
		print("do Up")			
		
		
class DownAction :
	extends "res://FrameWork/InputAction.gd"
	
	func doAction():
		print("do down")	
