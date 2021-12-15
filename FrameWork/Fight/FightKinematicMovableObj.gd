class_name FightKinematicMovableObj

extends KinematicPlatformMovableObj


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
	JumpUp,
	JumpDown
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
export(int, 0, 1000) var ATTACK_VELOCITY = 0
export(int, 0, 1000) var ATTACK_ACC = 500
export(int, 0, 1000) var JUMP_VELOCITY = 150


func _ready():
	#初始状态检测
	#TODO 可以指定初始状态
	if not body.is_on_floor():
		self.state = ActionState.JumpDown

func changeState(s):
	
	if(state!=ActionState.Attack and s!=state ):
		
		match s:
			ActionState.Idle:
				isMoving = true
				h_acceleration = IDLE_ACC
				h_velocityToward = 0
				
				v_acceleration = 0
				v_velocityToward =0
				self.faceDirection.y = 0
				self.velocity.y = 0
				pass
			ActionState.Walk:
				isMoving = true
				h_acceleration = WALK_ACC
				h_velocityToward = WALK_VELOCITY
				pass
			ActionState.Run:
				isMoving = true
				h_acceleration = RUN_ACC
				h_velocityToward = RUN_VELOCTIY
				pass
			ActionState.Run2Idle:
				isMoving = true
				h_acceleration = RUN_2_IDLE_ACC
				h_velocityToward = RUN_2_IDLE_VELOCITY
				pass
			ActionState.Idle2Run:
				isMoving = true
				h_acceleration = IDLE_2_RUN_ACC
				h_velocityToward = IDLE_2_RUN_VELOCITY
				pass
			ActionState.Attack:
				isMoving = true
				h_acceleration = ATTACK_ACC
				h_velocityToward = ATTACK_VELOCITY
				pass
			ActionState.Stop:
				isMoving = false
				
			ActionState.JumpUp:
				isMoving = true
				v_acceleration = gravity
				v_velocityToward = 0
				velocity.y = -JUMP_VELOCITY
				self.faceDirection.y = -1
				
			ActionState.JumpDown:
				isMoving = true
				v_acceleration = gravity
				v_velocityToward = FREE_FALL_SPEED
				self.faceDirection.y = 1
				
		print("  state change",s)
		state =s	
		emit_signal("State_Changed",s)
	pass

func _physics_process(delta):
	#检测跳跃状态
	if state==ActionState.JumpDown and body.is_on_floor():
		self.state = ActionState.Idle
		
	if not body.is_on_floor() and self.state==ActionState.JumpUp:
		#升至跳跃max,设置faceDirection 向下
		self.state = ActionState.JumpDown
	
	
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


func _on_FightActionMng_ActionStart(action:ActionInfo):
	#当前处于跳跃状态下，不接受其他动作
	if state==ActionState.JumpUp or state==ActionState.JumpDown:
		return
	
	var input_vector = Vector2.ZERO
	
	if action.param!=null && action.param.size()>0 && action.param[0] is Vector2:
		input_vector = action.param[0]
	print("in movable obj",input_vector)
	
	match(action.base_action):
		Tool.FightMotion.Idle:
			change_movable_state(input_vector,ActionState.Idle)
		Tool.FightMotion.Run:
			change_movable_state(input_vector,ActionState.Run)
		Tool.FightMotion.Walk:
			change_movable_state(input_vector,ActionState.Walk)
		Tool.FightMotion.Run2Idle:
			change_movable_state(input_vector,ActionState.Run2Idle)
		Tool.FightMotion.Idle2Run:
			change_movable_state(input_vector,ActionState.Idle2Run)
		Tool.FightMotion.JumpUp:
			change_movable_state(input_vector,ActionState.JumpUp)	
		_:
			
			var baseObj = FightBaseActionDataSource.get_by_base_id(action.base_action) as BaseAction
			# 是攻击类型的type
			#TODO 建立一个枚举 表示 action_type 方便理解
			if 2 in baseObj.type:
				var name =baseObj.animation_name as String
				if "_pre" in name: 
					change_movable_state(input_vector,ActionState.Attack)
					print("attack action start..stop moving")
					
	pass
