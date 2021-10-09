class_name AggresiveCharactor

extends KinematicMovableObj

signal State_Changed

enum PlayState{
	Idle,
	Moving,
	Attack,
	Def,
	Roll,
	Stop
}

#状态
var state = PlayState.Idle setget setState

func setState(s):
	if(s !=state):
		emit_signal("State_Changed",s)
		state =s
	match state:
		PlayState.Idle:
			acceleration =  FRICTION
		PlayState.Moving:
			acceleration  = ACC

var isMovableWhenAttack = false

#输入参数
var input_vector:Vector2 = Vector2.ZERO setget setInputVector

#默认情况下 input_vector 就是faceDirection
func setInputVector(v):
	input_vector = v
	self.faceDirection = v

#func _init(body).(body):
#	pass

func onProcess(delta=0):
	pass
	
func onPhysicsProcess(delta):
	
	match state:
		PlayState.Idle:
			isMoving =true
		PlayState.Moving:
			isMoving = true
		PlayState.Attack:
			player_attack(delta)
		PlayState.Def:
			isMoving =false
		PlayState.Roll:
			isMoving = true
		PlayState.Stop:
			isMoving = false
		
	.onPhysicsProcess(delta)
#进入攻击态
#	移动停止	
func player_attack(delta):
	if isMovableWhenAttack :
		_moveWhileAttack(delta)
	else:
		isMoving=false
		_stopPlayer(delta)
#攻击时候移动
func _moveWhileAttack(delta):
	
	if( input_vector ==Vector2.ZERO):
		acceleration= ACC-FRICTION
		isMoving = false
	else:
		velocityToward = MAX_SPEED_ATTACK
		isMoving=true
		

#攻击结束回调。 可以由动画的终结信号调用
func attackOver(s = PlayState.Idle):
	state = s
