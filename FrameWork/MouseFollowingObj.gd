extends KinematicBody2D


export var movingSpeed = 5

onready var direction= Vector2.ZERO

var canMove = true
var velocity = Vector2.ZERO
var targetPosition = Vector2.ZERO

func _input(event):
	if(event is InputEventMouseMotion):
		targetPosition = event.position
		direction = (targetPosition-self.global_position).normalized()

	elif(event is InputEventMouse):
		if event.is_action_pressed("attack"):
			velocity = Vector2.ONE *movingSpeed
		if event.is_action_released("attack"):
			velocity = Vector2.ZERO
	

func _physics_process(delta):
	
	if(canMove && velocity!=Vector2.ZERO):
		
		velocity =direction*movingSpeed;
		move_and_collide(velocity)
		
		var lg =(targetPosition-self.global_position).length()
		print("length")
		print(lg)
		if( lg<5) :
			velocity = Vector2.ZERO
	
	
