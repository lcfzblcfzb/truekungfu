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
	JumpDown,#8
	Climb#9
}

var state = ActionState.Idle setget changeState

export(int, 0, 1000) var IDLE_ACC = 600
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
export(int, 0, 1000) var JUMP_VELOCITY = 300
export(int, 0, 1000) var JUMP_ACC = 900
export(int, 0, 100000) var CLIMB_ACC = 9000
export(int, 0, 1000) var CLIMB_VELOCITY = 80

func _ready():
	pass
	
func changeState(s):
	
	if(state!=ActionState.Attack and s!=state ):
		_snap_vector=SNAP_DOWN
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
				_snap_vector=NO_SNAP
				v_acceleration = gravity
				v_velocityToward = 0
				h_acceleration = JUMP_ACC
				h_velocityToward = WALK_VELOCITY
				velocity.y = -JUMP_VELOCITY
				self.faceDirection.y = -1
				
			ActionState.JumpDown:
				isMoving = true
				v_acceleration = gravity
				v_velocityToward = FREE_FALL_SPEED
				h_acceleration = JUMP_ACC
				h_velocityToward = WALK_VELOCITY
				self.faceDirection.y = 1
				
			ActionState.Climb:
				isMoving = true
				_snap_vector=NO_SNAP
				v_acceleration =CLIMB_ACC
				v_velocityToward=CLIMB_VELOCITY
				h_acceleration =CLIMB_ACC
				h_velocityToward=CLIMB_VELOCITY
								
		print("  state change",s)
		state =s	
		emit_signal("State_Changed",s)
	pass

func _physics_process(delta):
	#检测跳跃状态
	if state==ActionState.JumpDown and body.is_on_genelized_floor():
		
#		if faceDirection != Vector2.ZERO:
			#这里加IF 的情况分析： 跳跃降落到地面，原先直接设置state=idle，在 避免重复添加action 改了FightActionMng之后
			#假设降落到地面的过程中玩家一直按下左或者右方向不变，则在落地后的walk 会被FightActionMng 认为重复而丢弃
			#所以会出现停住的现象
#			self.state = ActionState.Walk
#		else:
		self.state = ActionState.Idle
	
	#若在空中的情况	
	if not body.is_on_genelized_floor() :
		
		if self.state==ActionState.JumpUp :
			if velocity.y ==0:
				#升至跳跃max,设置faceDirection 向下
				self.state = ActionState.JumpDown
		elif self.state!=ActionState.JumpDown and self.state!=ActionState.Climb:
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
		
#攀爬动作结束的调用
func climb_over(s = ActionState.Idle):
	var prv_s = state
	state =s	
	if prv_s!=s:
		print("  climb over",s)
		emit_signal("State_Changed",s)
	pass		
	
#当前角色朝向
func is_face_left():
	return faceDirection.x<0

var _prv_process_action:ActionInfo

func _on_FightActionMng_ActionProcess(action:ActionInfo):
	#避免触发jump 之类的；会导致无限循环的卡住。
	if action.base_action == Tool.FightMotion.Walk or action.base_action == Tool.FightMotion.Run or action.base_action == Tool.FightMotion.Idle:
#		if _prv_process_action ==null or _prv_process_action!= action :
			_process_action(action)
#		_prv_process_action = action
	pass

var _current_action:ActionInfo

func _on_FightActionMng_ActionStart(action:ActionInfo):
	
	_process_action(action)


#可能在action 开始 和 进行中的时候调用；
func _process_action(action:ActionInfo):
	#TODO 此处带备注的代码 都可以 写到状态机 中。
	#	下面match 的部分可以用状态机改写;
	#当前处于下降下/或者 上升，如果按了移动，则会卡住。是因为移动完又自动会调用idle
	if (state ==ActionState.JumpDown or state ==ActionState.JumpUp) and action.base_action==Tool.FightMotion.Idle:
		return
		
	var input_vector = Vector2.ZERO
	
	if action.param!=null && action.param.size()>0 && action.param[0] is Vector2:
		input_vector = action.param[0]
	print("in movable obj",input_vector)
	
	#如果当前处于下降，按了移动，则会表现异常（有可能上不去Platform）
	#是因为移动的状态导致台阶判定出错
	if ( state ==ActionState.JumpUp) and (action.base_action==Tool.FightMotion.Walk or action.base_action==Tool.FightMotion.Run):
		change_movable_state(Vector2(input_vector.x,-1) , state)
		return
	elif (state ==ActionState.JumpDown ) and (action.base_action==Tool.FightMotion.Walk or action.base_action==Tool.FightMotion.Run):
		change_movable_state(Vector2(input_vector.x,1) , state)
		return
	
	if state ==ActionState.Climb and (action.base_action==Tool.FightMotion.Idle or action.base_action==Tool.FightMotion.Walk or action.base_action==Tool.FightMotion.Run):
		change_movable_state(input_vector,ActionState.Climb)
		return
	
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
		Tool.FightMotion.Climb:
			change_movable_state(input_vector,ActionState.Climb)	
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
