class_name KinematicPlatformMovableObj
	
extends Node2D

signal FaceDirectionChanged
signal CollisionObjChanged
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
onready var gravity_vector = ProjectSettings.get("default_gravity_vector") 

const FLOOR_NORMAL = Vector2.UP
# 像素与 m 的比例：25像素=1米
const PIX_METER_RATE = 25

#自由落体速度
const FREE_FALL_SPEED = 900

const NO_SNAP=Vector2.ZERO
const SNAP_DOWN= Vector2.DOWN*1000

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
#与地面发生碰撞的碰撞信息
var _last_collision_id =null
#是使用move_……_with_snap 或 move_and_slide
var use_snap = true

#是否忽略重力
var ignore_gravity = false
#是否处于地面变量记录
var _on_floor =false
#使用摩擦力
#若是false，水平上的速度会直接到达而不是逐渐到达
var use_friction = false

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
	var v_movingdirection = 1
	if ignore_gravity:
		v_movingdirection = faceDirection.y
	else:
		#y轴默认是朝下-》重力的方向
		v_movingdirection = 1
		if faceDirection.y < 0:
			#表示是跳跃的情况
			v_movingdirection = -1
	
	var _v_toward =  v_velocityToward * v_movingdirection
	var _h_toward =  h_velocityToward * faceDirection.x 
	
	if _v_toward!=velocity.y && v_acceleration==0:
		push_warning("v_acceleration is 0 but velocity_toward.y is not equal to velocity.y")
	if _h_toward!=velocity.x && h_acceleration==0:
		push_warning("h_acceleration is 0 but velocity_toward.x is not equal to velocity.x")
	velocity.y = move_toward(velocity.y, _v_toward , v_acceleration *delta)
	
	if use_friction: 
		velocity.x = move_toward(velocity.x, _h_toward , h_acceleration *delta) 
	else: 
		velocity.x = _h_toward
		if ignore_gravity:
			velocity.y = _v_toward
#	velocity.x = _h_toward
#	print(velocity)
	if use_snap:
		velocity =body.move_and_slide(velocity,Vector2.UP,true,4,0.9)
#		body.move_and_slide_with_snap(velocity, _snap_vector, Vector2.UP, true ,4,0.9)
	else:
		velocity =body.move_and_slide(velocity,Vector2.UP, true,4,0.9)
#		body.move_and_slide_with_snap(velocity, _snap_vector, Vector2.UP, true,4,0.9)
	#is_on_floor 只能在move_and_slide之后调用
	var _curr_on_floor = body.is_on_floor()
	body.set("on_floor",_curr_on_floor)
	
	#状态改变的信号输出
	#只有在切换的那一瞬间进行信号发射
	if not _on_floor and _curr_on_floor:
		#这是之前不在地面，现在在地面的信号变化
		var _collision = body.get_last_slide_collision()
		if _collision!=null:
				_last_collision_id = _collision.collider_id
				emit_signal("CollisionObjChanged",_collision)
	elif _on_floor and not _curr_on_floor:
		#之前在地面 现在跳跃起来的情况
		_last_collision_id =null
		emit_signal("CollisionObjChanged",null)
	elif _on_floor and _curr_on_floor:
		#这是接触到了不同collision 的情况
		var _collision = body.get_last_slide_collision()
		if _collision!=null:
			if _last_collision_id==null :
				_last_collision_id =_collision.collider_id
				emit_signal("CollisionObjChanged",_collision.collider)
			elif _collision.collider_id != _last_collision_id:
				_last_collision_id = _collision.collider_id
				emit_signal("CollisionObjChanged",_collision.collider)
	
	_on_floor = _curr_on_floor
	
	
#停下函数
func _stopPlayer(delta):
	h_velocityToward = 0
	_movePlayer(delta)
