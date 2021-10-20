class_name KinematicMovableObj
	
extends Node2D

signal FaceDirectionChanged
#状态
var isMoving = false
#加速度
export var ACC = 800
#摩擦力
export var FRICTION = 500
#最大速度
export var MAX_SPEED = 100
#攻击时刻的最大移动速度
export var MAX_SPEED_ATTACK = 50

#速度变化上限 的上限;
# 由于目标对象的速度
#var velocityTowardLimit = MAX_SPEED

#当前加速度值（加速度-阻力）
var acceleration = ACC

#速度-》移动对象的一个固有速度。通常由移动对象状态变化设置：如快速移动下的速度；或者被减速后的速度；
var velocityToward =0 setget setVelocityToward

func setVelocityToward(v):
	velocityToward =v 

#私有速度变量；用来表示真正用来处理计算的速度。不论是对象加速或者减速，处于IDLE的时候速度都是0
#这个私有变量就是实际计算时候的速度。
var velocity_value =0  setget ,getVelocityValue

func getVelocityValue():
	
	if isMoving:
		return velocityToward
	else:
		return 0

#移动体对象
var body:KinematicBody2D
export(NodePath) var bodyPath : NodePath
#朝向向量
var faceDirection:Vector2 =Vector2.DOWN  setget _setFaceDirection

#设置faceDirections
func _setFaceDirection(v):
	
	if v==Vector2.ZERO:
		return
	
	if faceDirection !=v:
		emit_signal("FaceDirectionChanged",v)
	faceDirection = v	

#当前移动速度向量
var velocity:Vector2 = Vector2.ZERO

func _ready():
	
	if body==null && bodyPath!=null:
		body =get_node(bodyPath)
	
pass
#构造器函数
#func _init(kidBody:KinematicBody2D):
#	if kidBody:
#		body = kidBody
	
	
func onProcess(delta=0):
	pass
	
#_physiceProcess 回调
func onPhysicsProcess(delta):
	pass
	#PlayState.ATTACK:
	#	player_attack(delta)

func _physics_process(delta):
	
	match isMoving:
		false:
			player_idle(delta)
		true:
			player_move(delta)
			
	onPhysicsProcess(delta)

func _process(delta):
	onProcess(delta)
#移动态
#	以velocity 速度移动
func player_move(delta):
	_movePlayer(delta)
#Idle 状态
#	以friction 速度停下	
func player_idle(delta):
	_stopPlayer(delta)

#移动函数
func _movePlayer(delta):
#	if(velocityToward>velocityTowardLimit):
#		velocityToward = velocityTowardLimit
	if isMoving:
		velocity =velocity.move_toward(faceDirection* self.velocity_value,acceleration*delta);
		body.move_and_collide(velocity*delta)
#停下函数
func _stopPlayer(delta):
	velocityToward= 0
	_movePlayer(delta)
