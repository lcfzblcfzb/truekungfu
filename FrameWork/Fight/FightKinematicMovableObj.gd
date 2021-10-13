class_name FightKinematicMovableObj

extends KinematicMovableObj


signal State_Changed

enum ActionState{
	
	Idle,
	Walk,
	Run,
	Run2Idle,
	Idle2Run,
	Attack,
	Stop,
	
}

var state = ActionState.Idle setget changeState

export(int, 0, 1000) var IDLE_ACC = 500
export(int, 0, 1000) var WALK_ACC = 300
export(int, 0, 1000) var WALK_VELOCITY = 100
export(int, 0, 1000) var RUN_ACC = 500
export(int, 0, 1000) var RUN_VELOCTIY = 200
export(int, 0, 1000) var RUN_2_IDLE_ACC = 100
export(int, 0, 1000) var RUN_2_IDLE_VELOCITY = 100
export(int, 0, 1000) var IDLE_2_RUN_ACC = 100
export(int, 0, 1000) var IDLE_2_RUN_VELOCITY = 100


func changeState(s):
	
	if(s !=state):
		emit_signal("State_Changed",s)
		state =s
		
		match state:
			ActionState.Idle:
				isMoving = true
				acceleration = IDLE_ACC
				velocityToward = 0
				pass
			ActionState.Walk:
				isMoving = true
				acceleration = WALK_ACC
				velocityToward = WALK_VELOCITY
				pass
			ActionState.Run:
				isMoving = true
				acceleration = RUN_ACC
				velocityToward = RUN_VELOCTIY
				pass
			ActionState.Run2Idle:
				isMoving = true
				acceleration = RUN_2_IDLE_ACC
				velocityToward = RUN_2_IDLE_VELOCITY
				pass
			ActionState.Idle2Run:
				isMoving = true
				acceleration = IDLE_2_RUN_ACC
				velocityToward = IDLE_2_RUN_VELOCITY
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
#如果input_vector 是 空向量，则保持不变
func setInputVector(v):
	input_vector = v
	if input_vector.x!=0 :
		self.faceDirection = v

#攻击结束回调。 可以由动画的终结信号调用
func attackOver(s = ActionState.Idle):
	state = s

