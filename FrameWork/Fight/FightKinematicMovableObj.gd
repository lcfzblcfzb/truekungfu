class_name FightKinematicMovableObj

extends KinematicMovableObj


signal State_Changed
signal Charactor_Face_Direction_Changed

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
export(int, 0, 1000) var WALK_ACC = 600
export(int, 0, 1000) var WALK_VELOCITY = 100
export(int, 0, 1000) var RUN_ACC = 500
export(int, 0, 1000) var RUN_VELOCTIY = 200
export(int, 0, 1000) var RUN_2_IDLE_ACC = 700
export(int, 0, 1000) var RUN_2_IDLE_VELOCITY = 100
export(int, 0, 1000) var IDLE_2_RUN_ACC = 100
export(int, 0, 1000) var IDLE_2_RUN_VELOCITY = 100
export(int, 0, 1000) var ATTACK_VELOCITY = 80
export(int, 0, 1000) var ATTACK_ACC = 50

func changeState(s):
	
	if(state!=ActionState.Attack && s!=state ):
		
		match s:
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
				acceleration = ATTACK_ACC
				velocityToward = ATTACK_VELOCITY
				pass
			ActionState.Stop:
				isMoving = false
				
		print("  state change",s)
		state =s	
		emit_signal("State_Changed",s)
	pass
#改变 movableobjstate
func change_movable_state(input_vector,s):
	self.charactor_face_direction = input_vector
	self.faceDirection = input_vector
	self.state = s
	pass
#角色 朝向 参数
var charactor_face_direction:Vector2 = Vector2.RIGHT setget setCharactorFaceDirection

#默认情况下 input_vector 就是faceDirection
#如果input_vector 是 空向量，则保持不变
func setCharactorFaceDirection(v):
	#v.x ==0 的时候不改变面向
	if v.x==0:
		return
	
	#在attack 的时候无法改变朝向
	if state != ActionState.Attack:
		
		if v!= charactor_face_direction:
			charactor_face_direction = v
			emit_signal("Charactor_Face_Direction_Changed",charactor_face_direction)
		else:
			charactor_face_direction = v
			
#攻击结束回调。 可以由动画的终结信号调用
func attackOver(s = ActionState.Idle):
	var prv_s = state
	state =s	
	if prv_s!=s:
		print("  attack over",s)
		emit_signal("State_Changed",s)
	
#当前角色朝向
func is_face_left():
	return faceDirection.x<0
