extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
var counte = 1
func _process(delta):
	
	counte=counte+1
	pass


func _on_HSlider_value_changed(value):
	Engine.time_scale = value
	$LineEdit.text = value as String

func _on_LineEdit_text_changed(new_text):
	Engine.time_scale = new_text as float
	$HSlider.value = new_text
