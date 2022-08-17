class_name FightKinematicMovableObj

extends KinematicPlatformMovableObj


signal State_Changed
signal Charactor_Face_Direction_Changed
signal Active_State_Changed

enum ActionState{
	
	Idle,#0
	Walk,
	Run,
	Run2Idle,
	Idle2Run,
	Attack,
	Stop,
	JumpUp,
	JumpDown,#8
	JumpRising#9
	JumpFalling#10
	Climb,#11
	Hanging,
	HangingClimb#11 从hang攀爬到站起的过程          
}

var state = ActionState.Idle setget changeState

export(int, 0, 1000) var IDLE_ACC = 1900
export(int, 0, 1000) var WALK_ACC = 900
export(int, 0, 1000) var WALK_VELOCITY = 110
export(int, 0, 1000) var RUN_ACC = 500
export(int, 0, 1000) var RUN_VELOCTIY = 200
export(int, 0, 1000) var RUN_2_IDLE_ACC = 700
export(int, 0, 1000) var RUN_2_IDLE_VELOCITY = 100
export(int, 0, 1000) var IDLE_2_RUN_ACC = 100
export(int, 0, 1000) var IDLE_2_RUN_VELOCITY = 100
export(int, 0, 1000) var ATTACK_VELOCITY = 100
export(int, 0, 1000) var ATTACK_ACC = 500
export(int, 0, 1000) var JUMP_VELOCITY = 250
export(int, 0, 1000) var JUMP_ACC = 900
export(int, 0, 100000) var CLIMB_ACC = 9000
export(int, 0, 1000) var CLIMB_VELOCITY = 80

func _ready():
	pass
	
func changeState(s):
	
	if(s!=state ):
		_snap_vector=SNAP_DOWN
		use_snap =true
		
		ignore_gravity = false
		v_acceleration = gravity
		v_velocityToward = FREE_FALL_SPEED
		match s:
			ActionState.Idle:
				isMoving = true
				h_acceleration = IDLE_ACC
				h_velocityToward = 0
				self.faceDirection.y = 1
				pass
			ActionState.Walk:
				isMoving = true
				h_acceleration = WALK_ACC
				h_velocityToward = _get_attribute_mng().get_value(Glob.CharactorAttribute.WalkSpeed)
				self.faceDirection.y = 1
				pass
			ActionState.Run:
				isMoving = true 
				h_acceleration = RUN_ACC
				h_velocityToward = _get_attribute_mng().get_value(Glob.CharactorAttribute.RunSpeed)
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
				
			ActionState.JumpRising:
				
				isMoving = true
				_snap_vector=NO_SNAP
				use_snap =false
				v_acceleration = JUMP_ACC
				v_velocityToward = 0
				h_acceleration = WALK_ACC
				h_velocityToward = WALK_VELOCITY
				velocity.y = -_get_attribute_mng().get_value(Glob.CharactorAttribute.JumpSpeed)
				self.faceDirection.y = -1
			
			ActionState.JumpFalling:
				isMoving = true
				
#				_snap_vector=NO_SNAP
#				use_snap =false
				v_acceleration = gravity
				v_velocityToward = FREE_FALL_SPEED
				h_acceleration = WALK_ACC
				h_velocityToward = WALK_VELOCITY
				self.faceDirection.y = 1
			
			ActionState.JumpUp:
#				isMoving = true
#				_snap_vector=NO_SNAP
#				use_snap =false
#				v_acceleration = JUMP_ACC
#				v_velocityToward = 0
#				h_acceleration = WALK_ACC
#				h_velocityToward = WALK_VELOCITY
#				velocity.y = -_get_attribute_mng().get_value(Glob.CharactorAttribute.JumpSpeed)
#				self.faceDirection.y = -1
				isMoving = true
				_snap_vector=NO_SNAP
				use_snap =false
				v_acceleration = gravity
				v_velocityToward = 0
				h_acceleration = WALK_ACC
				h_velocityToward = _get_attribute_mng().get_value(Glob.CharactorAttribute.AttackMoveSpeed)
				self.faceDirection.y = 0
			
			ActionState.JumpDown:
				isMoving = true
				_snap_vector=NO_SNAP
				use_snap =false
#				_snap_vector=NO_SNAP
#				use_snap =false
				v_acceleration = gravity
				v_velocityToward = FREE_FALL_SPEED
				h_acceleration = WALK_ACC
				h_velocityToward = WALK_VELOCITY
				self.faceDirection.y = 1
				
			ActionState.Climb:
				isMoving = true
				_snap_vector=NO_SNAP
				use_snap =false
				ignore_gravity = true
				v_acceleration =CLIMB_ACC
				v_velocityToward=CLIMB_VELOCITY
				h_acceleration =CLIMB_ACC
				h_velocityToward=CLIMB_VELOCITY
			
			ActionState.Hanging:
				#攀爬墙壁边缘
				use_snap =false
				ignore_gravity = true
				v_acceleration =9999
				v_velocityToward=0
				h_acceleration =9999
				h_velocityToward=0
				
			ActionState.HangingClimb:
				#攀爬墙壁边缘
				use_snap =false
				ignore_gravity = true
				v_acceleration =9999
				v_velocityToward=0
				h_acceleration =9999
				h_velocityToward=0
								
		print("  state change",s)
		state =s	
		emit_signal("State_Changed",s)
	pass

func _get_attribute_mng()->AttribugeMng:
	return body.attribute_mng

func _physics_process(delta):
	#检测跳跃状态
	if self.state==ActionState.JumpFalling and body.is_on_genelized_floor():
		
		var base = FightBaseActionDataSource.get_by_id(Glob.FightMotion.JumpDown)
		var action = GlobVar.getPollObject(ActionInfo,[Glob.FightMotion.JumpDown, OS.get_ticks_msec(), [body.fight_controller.get_moving_vector()], base.get_duration(), ActionInfo.EXEMOD_SEQ, false, true])
		
		var idle_base = FightBaseActionDataSource.get_by_id(Glob.FightMotion.Idle)
		var idle_action = GlobVar.getPollObject(ActionInfo,[Glob.FightMotion.Idle, OS.get_ticks_msec(), [body.fight_controller.get_moving_vector()], base.get_duration(), ActionInfo.EXEMOD_GENEROUS, false, false])
		
		body.actionMng.regist_group_actions([action,idle_action],ActionInfo.EXEMOD_GENEROUS)
#		emit_signal("Active_State_Changed",Glob.FightMotion.JumpDown)
		
	#若在空中的情况	
	if not body.is_on_genelized_floor() :
		if self.state==ActionState.JumpRising :
			if velocity.y ==0:
				#升至跳跃max,设置faceDirection 向下
				
				var base = FightBaseActionDataSource.get_by_id(Glob.FightMotion.JumpFalling)
				var action = GlobVar.getPollObject(ActionInfo,[Glob.FightMotion.JumpFalling, OS.get_ticks_msec(), [body.fight_controller.get_moving_vector()], base.get_duration(), ActionInfo.EXEMOD_SEQ, false, true])
				body.actionMng.regist_actioninfo(action)
#				emit_signal("Active_State_Changed",Glob.FightMotion.JumpFalling)
#				self.state = ActionState.JumpDown
#			elif (state != ActionState.HangingClimb and state != ActionState.Hanging )and body.is_at_hanging_corner() : #优先设置成hanging
#				change_movable_state(Vector2.ZERO , ActionState.Hanging)
			
		elif self.state!=ActionState.Climb and self.state !=ActionState.Hanging and self.state != ActionState.HangingClimb and self.state != ActionState.JumpUp and self.state != ActionState.JumpRising:
			#最基础的判定下落的地方
			
			var base = FightBaseActionDataSource.get_by_id(Glob.FightMotion.JumpFalling)
			var action = GlobVar.getPollObject(ActionInfo,[Glob.FightMotion.JumpFalling, OS.get_ticks_msec(), [body.fight_controller.get_moving_vector()], base.get_duration(), ActionInfo.EXEMOD_SEQ, false, true])
			body.actionMng.regist_actioninfo(action)
#			emit_signal("Active_State_Changed",Glob.FightMotion.JumpFalling)
#			self.state = ActionState.JumpDown
			
#		elif (state != ActionState.HangingClimb and state != ActionState.Hanging )and body.is_at_hanging_corner() : #优先设置成hanging
#			change_movable_state(Vector2.ZERO , ActionState.Hanging)
		
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
	
#	#在attack 的时候无法改变朝向   -->目前来说可以
#	if state != ActionState.Attack:
		
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
		ignore_gravity = false
		emit_signal("State_Changed",s)
	pass	
#hangingClimb动作结束的回调
func hanging_climb_over(position:Vector2,s = ActionState.Idle):
	ignore_gravity = false
#	body.global_position = position
	self.state = s
	
#当前角色朝向
func is_face_left():
	return faceDirection.x<0

var _prv_process_action:ActionInfo

#在actionmng 进行中的action 进行处理
func _on_FightActionMng_ActionProcess(action:ActionInfo):
	#避免触发jump 之类的；会导致无限循环的卡住。
	if action.base_action == Glob.FightMotion.Walk or action.base_action == Glob.FightMotion.Run or action.base_action == Glob.FightMotion.Idle:
#		if _prv_process_action ==null or _prv_process_action!= action :
		_process_action(action)
#		_prv_process_action = action
	elif action.base_action == Glob.FightMotion.HangingClimb:
		
		#TODO 待优化
		var end_position = body.corner_detector._last_hang_climb_end as Vector2
		
		var time = (action.action_duration_ms -action.action_pass_time) / 1000
		
		var distance = global_position.distance_to(end_position)
		
		var speed = distance /time
		
		#TODO 优化点：符合实际的攀爬应该分为两段：第一段垂直上升，第二段水平方向移动
		
		self.faceDirection = global_position.direction_to(end_position)
		v_velocityToward = speed  
		h_velocityToward = speed  
		
		pass
	pass

var _current_action:ActionInfo

func _on_FightActionMng_ActionStart(action:ActionInfo):
	#在开始和 进行中 有可能触发
	
	_process_action(action)


#可能在action 开始 和 进行中的时候调用；
func _process_action(action:ActionInfo):
	#TODO 此处带备注的代码 都可以 写到状态机 中。
	#	下面match 的部分可以用状态机改写;
	#当前处于下降下/或者 上升，如果按了移动，则会卡住。是因为移动完又自动会调用idle
#	if (state ==ActionState.JumpDown or state ==ActionState.JumpUp) and action.base_action==Glob.FightMotion.Idle:
#		return
	
	if state == ActionState.HangingClimb:
		#hangingclimb 状态下不接收输入
		return
	
	var input_vector = Vector2.ZERO
	
	if action.param!=null && action.param.size()>0 && action.param[0] is Vector2:
		input_vector = action.param[0]
	
#	if state == ActionState.Hanging:
		#攀援的状态	
#		if sign(charactor_face_direction.x) * sign(input_vector.x) <0:
#			#往hanging 相反移动的操作将结束hanging状态
#			change_movable_state(input_vector , ActionState.Idle)
#			ignore_gravity = false
#			pass 
#		elif action.base_action ==Glob.FightMotion.JumpUp:
#			#跳跃
#			change_movable_state(input_vector , ActionState.JumpUp)
#			ignore_gravity = false
#		elif sign(charactor_face_direction.x) * sign(input_vector.x) >0:
#			#相同方向 攀爬至平台上
#			change_movable_state(input_vector , ActionState.HangingClimb)
#			pass
#		pass
#	else:
		
	#在空中的状态在 接收到 IDLE,WALK,RUN移动指令的时候需要特殊处理
	#会接收到IDLE是应为输入控制器 在最后一个按键抬起的时候会发送一个IDLE事件
#	if ( state ==ActionState.JumpUp) and (action.base_action==Glob.FightMotion.Idle or action.base_action==Glob.FightMotion.Walk or action.base_action==Glob.FightMotion.Run):
#		change_movable_state(Vector2(input_vector.x,-1) , state)
#		return
#	elif (state ==ActionState.JumpDown ) and (action.base_action==Glob.FightMotion.Walk or action.base_action==Glob.FightMotion.Run):
#		change_movable_state(Vector2(input_vector.x,1) , state)
#		return
	if state ==ActionState.Climb and (action.base_action==Glob.FightMotion.Idle or action.base_action==Glob.FightMotion.Walk or action.base_action==Glob.FightMotion.Run):
		change_movable_state(input_vector,ActionState.Climb)
		return

	match(action.base_action): 
		Glob.FightMotion.Idle:
			change_movable_state(input_vector,ActionState.Idle)
		Glob.FightMotion.Run:
			change_movable_state(input_vector,ActionState.Run)
		Glob.FightMotion.Walk:
			change_movable_state(input_vector,ActionState.Walk)
		Glob.FightMotion.Run2Idle:
			change_movable_state(input_vector,ActionState.Run2Idle)
		Glob.FightMotion.Idle2Run:
			change_movable_state(input_vector,ActionState.Idle2Run)
		Glob.FightMotion.JumpRising:
			input_vector.y = O.UP.y
			change_movable_state(input_vector,ActionState.JumpRising)
		Glob.FightMotion.JumpUp:
			input_vector.y = O.UP.y
			change_movable_state(input_vector,ActionState.JumpUp)
		Glob.FightMotion.JumpFalling:
			input_vector.y = O.DOWN.y
			change_movable_state(input_vector,ActionState.JumpFalling)	
		Glob.FightMotion.JumpDown:
			input_vector.y = O.DOWN.y
			change_movable_state(input_vector,ActionState.JumpDown)	
		Glob.FightMotion.Climb:
			change_movable_state(input_vector,ActionState.Climb)	
		Glob.FightMotion.Hanging:
			change_movable_state(input_vector,ActionState.Hanging)
		Glob.FightMotion.HangingClimb:
			change_movable_state(input_vector,ActionState.HangingClimb)		
		Glob.FightMotion.Attack_Ci:
			change_movable_state(Vector2(faceDirection.x,0),ActionState.Attack)
								
	pass
