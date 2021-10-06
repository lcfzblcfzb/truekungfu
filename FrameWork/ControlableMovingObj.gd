class_name  ControlableMovingObj

extends AggresiveCharactor

#构造器函数
#func _init(body).(body):
#	assert(body.has_method("getSpeed"))
#	pass


func _ready():
	#需要传入 speed 参数
	assert(body.has_method("getSpeed"))
	


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
	
	elif Input.is_action_just_released("def"):
		self.state = PlayState.Def
		pass
	elif  state== PlayState.Moving || state ==PlayState.Idle: 
		if input_vector!=Vector2.ZERO:
			self.state = PlayState.Moving
			self.velocityToward=body.getSpeed()
		else :
			self.state = PlayState.Idle
#攻击结束回调。 可以由动画的终结信号调用
func attackOver(s = PlayState.Idle):
	self.state = s

func defOver(s=PlayState.Idle):
	self.state = s


#动画结束事件
#根据动画名字检测动作

func _on_AnimationTree_State_Changed(anim_name):
	if anim_name ==null||anim_name=="":
		return 
	
	if anim_name.find("after",0)>0:
		attackOver()
		pass
	
	pass # Replace with function body.
