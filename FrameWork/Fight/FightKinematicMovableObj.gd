class_name FightKinematicMovableObj

extends KinematicMovableObj


signal State_Changed

enum ActionState{
	
	Idle,
	Walk,
	Run,
	Run2Idle,
	Idl2Run,
	Attack,
	Stop,
	
}

var state = ActionState.Idle setget changeState

func changeState(s):
	
	if(s !=state):
		emit_signal("State_Changed",s)
		state =s
		
		match state:
			ActionState.Idle:
				isMoving = true
				acceleration = 100
				velocityToward = 0
				pass
			ActionState.Walk:
				isMoving = true
				acceleration = 300
				velocityToward = 100
				pass
			ActionState.Run:
				isMoving = true
				acceleration = 500
				velocityToward = 200
				pass
			ActionState.Run2Idle:
				isMoving = true
				acceleration = 100
				velocityToward = 70
				pass
			ActionState.Idl2Run:
				isMoving = true
				acceleration = 100
				velocityToward = 100
				pass
			ActionState.Attack:
				isMoving = true
				acceleration = 100
				velocityToward = 0
				pass
			ActionState.Stop:
				isMoving = false
	pass


#输入参数
var input_vector:Vector2 = Vector2.ZERO setget setInputVector

#默认情况下 input_vector 就是faceDirection
func setInputVector(v):
	input_vector = v
	self.faceDirection = v

#攻击结束回调。 可以由动画的终结信号调用
func attackOver(s = ActionState.Idle):
	state = s

