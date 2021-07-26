extends Node

var PlayerAction =preload("res://Player/PlayerAction.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _physics_process(delta):
	
	if Input.is_action_pressed(mappingDict.get(InputType.UP)):
		PlayerAction.UpAction.new().doAction()
	elif Input.is_action_pressed(mappingDict.get(InputType.DOWN)):
		PlayerAction.DownAction.new().doAction()
	elif Input.is_action_pressed(mappingDict.get(InputType.LEFT)):
		PlayerAction.LeftAction.new().doAction()
	elif Input.is_action_pressed(mappingDict.get(InputType.RIGHT)):
		PlayerAction.RightAction.new().doAction()


enum InputType{
	UP,DOWN,LEFT,RIGHT
}

export var  mappingDict={
	InputType.UP:"ui_up",
	InputType.DOWN:"ui_down",
	InputType.LEFT:"ui_left",
	InputType.RIGHT:"ui_right"
}
