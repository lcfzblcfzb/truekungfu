extends Node2D


var state =0

func _input(event):
	if event.is_action_pressed("attack"):
		attack()
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func attack():
	$Position2D/sword.linear_damp= 0
	state =1
	attackState=1
	$Position2D/sword.add_force(Vector2.ZERO,Vector2.RIGHT*2000)
	pass

func is_out_of_bound():
	
	if $Position2D/sword.position.length_squared()>100:
		return true
	else:
		return false
		
func is_near_position():
	
	if $Position2D/sword.position.length_squared()<=3:
		return true
	
	return false

#state 1：出剑   2:收回   0:到达
var attackState = 0
func attack_process(delta):
	if attackState==1:
		print("attackState ",attackState)
		if is_out_of_bound():
			$Position2D/sword.add_force(Vector2.ZERO,$Position2D/sword.applied_force.rotated(PI)*2)
			attackState = 2
	elif attackState ==2:
		
		print("attackState ",attackState)
		if is_near_position():
			
			$Position2D/sword.applied_force=Vector2.ZERO
			$Position2D/sword.linear_damp= 100
			attackState = 0
			state=0
	pass
var temp_force=Vector2.ZERO
func _physics_process(delta):
	if state==1:
		attack_process(delta)
	if temp_force !=$Position2D/sword.applied_force:
		print("applyed_force",$Position2D/sword.applied_force)
		temp_force = $Position2D/sword.applied_force
