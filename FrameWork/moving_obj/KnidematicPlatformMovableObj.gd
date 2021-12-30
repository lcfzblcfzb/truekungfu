class_name KinematicPlatformMovableObj
	
extends Node2D

signal FaceDirectionChanged
#状态
var isMoving = false
#加速度
export var H_ACC = 800
#摩擦力
export var FRICTION = 500
#最大速度
export var MAX_SPEED = 100
#攻击时刻的最大移动速度
export var MAX_SPEED_ATTACK = 50

#取得系统配置的 重力
onready var gravity = ProjectSettings.get("physics/2d/default_gravity")

const FLOOR_NORMAL = Vector2.UP
# 像素与 m 的比例：25像素=1米
const PIX_METER_RATE = 25

#自由落体速度
const FREE_FALL_SPEED = 1000

const NO_SNAP=Vector2.ZERO
const SNAP_DOWN= Vector2.DOWN*100

#速度变化上限 的上限;
# 由于目标对象的速度
#var velocityTowardLimit = MAX_SPEED

#当前加速度值（加速度-阻力）
var h_acceleration = H_ACC
var v_acceleration = 0

#速度-》移动对象的一个固有速度。通常由移动对象状态变化设置：如快速移动下的速度；或者被减速后的速度；
var h_velocityToward =0

#私有速度变量；用来表示真正用来处理计算的速度。不论是对象加速或者减速，处于IDLE的时候速度都是0
#这个私有变量就是实际计算时候的速度。
var h_velocity_value =0  

var v_velocityToward =0

#最终用于计算的加速度
var _final_acc :Vector2

var _snap_vector:Vector2=Vector2.ZERO


func getHVelocityValue():
	
	if isMoving:
		return h_velocityToward
	else:
		return 0

#运动对象的质量/ kg
func get_mass():
	return 60
	pass

#移动体对象
var body:KinematicBody2D
export(NodePath) var bodyPath : NodePath
#朝向向量
var faceDirection:Vector2 =Vector2.ZERO  setget _setFaceDirection

#设置faceDirections
func _setFaceDirection(v):
	
#	if v==Vector2.ZERO:
#		return

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
	
	var _v_toward =  v_velocityToward * faceDirection.y
	var _h_toward =  h_velocityToward * faceDirection.x 
	
	if _v_toward!=velocity.y && v_acceleration==0:
		push_warning("v_acceleration is 0 but velocity_toward.y is not equal to velocity.y")
	if _h_toward!=velocity.x && h_acceleration==0:
		push_warning("h_acceleration is 0 but velocity_toward.x is not equal to velocity.x")
	velocity.y = move_toward(velocity.y, _v_toward , v_acceleration *delta)
	velocity.x = move_toward(velocity.x, _h_toward , h_acceleration *delta) 
	
	body.move_and_slide_with_snap(velocity, _snap_vector, Vector2.UP, false)


#停下函数
func _stopPlayer(delta):
	h_velocityToward = 0
	_movePlayer(delta)
