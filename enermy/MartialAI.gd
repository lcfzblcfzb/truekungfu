class_name AI
extends Node2D

export (NodePath) var charactorNodePath;
onready var detector=$AiDetector as AIDetector
var charactor:BaseCharactor
var movableObj:AggresiveCharactor

#检测范围附近是否存在敌方单位
var isOppoAround =false

#是否锁定对象
var isLocked = false
var lockTarget:Node2D;

#计算与目标位置的物理frame数
var _lastCalcPhysFrame = 0
#朝向目标的向量
var _direction2Target = Vector2.ZERO

#观测范围
export var VISUAL_RANGE :int=500;
#安全距离
export var SAFE_RANGE :int=100;
#攻击距离
export var ATTACK_RANGE :int=70;

#范围类型  0:超出观测范围，1：安全范围之外，2：安全范围之内，攻击范围之外，3：攻击范围之内
var rangeType = 0  

#是否和平状态
var is_free_state = true

var UN_INIT = -1
var WIGGLE = 0
var READY =1
var MOVE_SAFEZONE =2
var SWITCH=3
var DEF=4
var ROLL=5
var IDLE =6
var PATROL =7
var ESCAPE=8
var ATTACK =9
var IDLE_MOVE = 10
var MOVE_ATTACKRANGE =11

#当前所属状态
var state setget setState;

func setState(s):
		
	state = s;
	if !movableObj:
		return
	print("state:"+state as String)
	match state:
		IDLE:
			movableObj.state = AggresiveCharactor.PlayState.Idle
			movableObj.input_vector = Vector2.ZERO
		
		SWITCH:
			movableObj.state = AggresiveCharactor.PlayState.Moving
		WIGGLE:
			lastWiggleShiftTime = OS.get_ticks_msec()
			movableObj.state = AggresiveCharactor.PlayState.Moving
			movableObj.velocityToward = 40
			var v2t =getDirection2target()
			v2t =v2t.rotated(PI/2)
			movableObj.input_vector = v2t
		MOVE_SAFEZONE:
			
			if rangeType==2||rangeType==3:
				#moveOut
				moveSafeZoneDirection = -1
				pass
			else:
				moveSafeZoneDirection = 1
				#moveIn
				pass
			movableObj.velocityToward = movableObj.MAX_SPEED
			movableObj.state = AggresiveCharactor.PlayState.Moving
			movableObj.input_vector = moveSafeZoneDirection * getDirection2target()
		UN_INIT:
			return	
		ATTACK:
			charactor.attack()
		MOVE_ATTACKRANGE:
			switchMove2AttackRange()
	pass

#上次状态切换时间
var lastProcessTime = OS.get_ticks_msec()
#上次wiggle改变姿态时间
var lastWiggleShiftTime = 0
#wiggle切换时间
const WIGGLE_SHIFT_DURATION = 500
const WIGGLE_DURATION = 6000
const IDLE_DURATION = 3000
const MOVE_SAFEZONE_DURATION = 3000
const SWITCH_DURATION = 3000

var wiggleDirection = 1
var moveSafeZoneDirection = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.state = SWITCH
	charactor = get_node(charactorNodePath)

func _process(delta):
	pass

func stateShift(s):
	self.state = s
	lastProcessTime = OS.get_ticks_msec()

#移动向玩家攻击范围
func switchMove2AttackRange():
	
	if rangeType !=3:
		movableObj.velocityToward = 200
		movableObj.state = AggresiveCharactor.PlayState.Moving
		movableObj.input_vector = getDirection2target()
	else:
		charactor.attack()
	
#wiggle动作
func doWiggle(delta):
	
	if OS.get_ticks_msec() - lastWiggleShiftTime>WIGGLE_SHIFT_DURATION:
		#doShift
		if randf()>0.5:
			#changeDirection
			wiggleDirection = 1
		else:
			wiggleDirection =-1
		pass
		
		lastWiggleShiftTime = OS.get_ticks_msec()
	else:
		var v2t =getDirection2target()
		v2t =v2t.rotated(wiggleDirection*(PI/2 -0.01))
		movableObj.input_vector = v2t
	var lt =OS.get_ticks_msec() - lastProcessTime
	if lt <WIGGLE_DURATION:
		
		
		pass
		
#switch动作
func doSwitch(delta):
	if OS.get_ticks_msec()-lastProcessTime >SWITCH_DURATION:
		stateShift(SWITCH)
		return
	
	var targetDirection = Vector2.ZERO
	var moveDirection = Vector2.ZERO
	if lockTarget is BaseCharactor && lockTarget.controableMovingObj.isMoving:
		targetDirection = lockTarget.controableMovingObj.faceDirection
		
	#转向方向等于：两个目标切线方向加上 目标移动方向
	moveDirection = getDirection2target().rotated(Tool.hPi)	*0.2+targetDirection*0.8
		
	movableObj.input_vector = moveDirection.normalized()
	

#写在物理procsess中
func _processState_Engaged(delta):

	match state:
		WIGGLE:
			
			if OS.get_ticks_msec() - lastProcessTime >WIGGLE_DURATION:
				if self.rangeType ==1:
					
					#stateShift(MOVE_SAFEZONE)
					
					stateShift(ATTACK)
				elif self.rangeType ==3 || self.rangeType==2:	
					
					stateShift(MOVE_ATTACKRANGE)
				
				else:
					stateShift(IDLE)
			if is_free_state:
				stateShift(IDLE)
			if self.rangeType==0 || self.rangeType ==1:
				stateShift(MOVE_SAFEZONE)
			elif self.rangeType ==2||self.rangeType==3:
				doWiggle(delta)
			
		IDLE:
			#doIdle
			#IDLE for sometime
			if OS.get_ticks_msec() - lastProcessTime >IDLE_DURATION:
				
				if rangeType ==1||rangeType==2:
					stateShift(WIGGLE)
				elif rangeType==3:
					stateShift(MOVE_SAFEZONE)
				#stateShift(MOVE_ATTACKRANGE)
				
			if rangeType ==3:
				stateShift(MOVE_SAFEZONE)
		ESCAPE:
			#doEscape
			
			
			pass
		READY:
			#doready
			
			stateShift(IDLE)
			pass
		MOVE_SAFEZONE:
			
			if OS.get_ticks_msec()-lastProcessTime >MOVE_SAFEZONE_DURATION:
				stateShift(READY)
			if self.rangeType==3||self.rangeType==2:
				#moveOut
				if moveSafeZoneDirection>0:
					stateShift(READY)
					
			elif self.rangeType==1||self.rangeType==0:
				#stopMovingout
				if moveSafeZoneDirection<=0:
					stateShift(READY)
		SWITCH:
			if self.rangeType==0||self.rangeType==1:
				stateShift(IDLE)
			else:
				doSwitch(delta)
				pass
			pass
		ATTACK:
			
			if movableObj.state != AggresiveCharactor.PlayState.Attack:
				stateShift(IDLE)
				pass
				
			pass
		DEF:
			pass
		ROLL:
			pass
		MOVE_ATTACKRANGE:
			movableObj.input_vector = getDirection2target()
			if rangeType ==3:
				stateShift(ATTACK)
		
func _processState_Free(delta):
	
	findLockTarget()
	pass			

func _physics_process(delta):
	if charactor:
		
		if is_free_state:
			
			_processState_Free(delta)
		else:
			
			checkRangeType()
			calcDirection2Target()
			_processState_Engaged(delta)

#获取 朝向目标向量
func getDirection2target()->Vector2:
	if lockTarget && charactor:
		if Engine.get_physics_frames()!=_lastCalcPhysFrame:
			calcDirection2Target()
		return _direction2Target
	else:
		return Vector2.ZERO

#计算朝向目标的方向
func calcDirection2Target():
	if lockTarget && charactor:
		_lastCalcPhysFrame =Engine.get_physics_frames()
		var d = (lockTarget.global_position-charactor.global_position).normalized()
		charactor.onFaceDirectionChange(d)
		_direction2Target = d
#查找锁定对象
func findLockTarget():
	#查找到	
	var oppoArray =CharactorMng.findOpposeMember(charactor.camp,false)
	#进行ray 检测
	for oppo in oppoArray:
		oppo =oppo as Node2D 
		
		var oppoPos = to_local(oppo.global_position)

		detector.detectEnemyRay.cast_to=oppoPos
		detector.detectEnemyRay.force_raycast_update()
		var col =detector.detectEnemyRay.get_collider()
		#TODO 这里检测的对象的判断需要后期优化
		if detector.detectEnemyRay.is_colliding() &&detector.detectEnemyRay.get_collider() is BaseCharactor:
			lockTarget = detector.detectEnemyRay.get_collider()
			lock2Target(lockTarget)
			break

#锁定目标
func lock2Target(target):
	
	lockTarget = target
	target.locked = true
	#解除和平状态
	is_free_state = false
	isLocked = true
	if movableObj.is_connected("FaceDirectionChanged",charactor,"onFaceDirectionChange"):
		movableObj.disconnect("FaceDirectionChanged",charactor,"onFaceDirectionChange")

#接触
func unlockTarget():
	lockTarget = null
	
	is_free_state = true
	isLocked = false
	
	movableObj.connect("FaceDirectionChanged",charactor,"onFaceDirectionChange")

#检测距离
func checkRangeType():
	
	if lockTarget==null || charactor==null:
		rangeType=0
		return
	
	var distance = lockTarget.global_position.distance_to(charactor.global_position)
	if distance >VISUAL_RANGE:
		rangeType=0
	elif distance >SAFE_RANGE:
		rangeType=1
	elif distance >ATTACK_RANGE:
		rangeType=2
	else:
		rangeType=3
