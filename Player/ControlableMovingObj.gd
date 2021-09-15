class_name  ControlableMovingObj

extends AggresiveCharactor

#构造器函数
func _init(body).(body):
	assert(body.has_method("getSpeed"))
	pass

#process回调函数：在引用对象中_process()中调用
func onProcess(delta=0):
	
	input_vector = Vector2.ZERO;
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left");
	input_vector.y = Input.get_action_strength("ui_down")-Input.get_action_strength("ui_up");
	
	input_vector =  input_vector.normalized()

	
	if input_vector!=Vector2.ZERO:
		self.faceDirection = input_vector
		
	if Input.is_action_just_released("attack"):
		self.state = PlayState.Attack
	elif  state!= PlayState.Attack: 
		if input_vector!=Vector2.ZERO:
			self.state = PlayState.Moving
			self.velocityToward=body.getSpeed()
		else :
			self.state = PlayState.Idle
#攻击结束回调。 可以由动画的终结信号调用
func attackOver(s = PlayState.Idle):
	self.state = s
