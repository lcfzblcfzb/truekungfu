class_name KinematicMovableObj
	
extends Node2D

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

#速度变化上限 的上限
var velocityTowardLimit = 0

#当前加速度值（加速度-阻力）
var acceleration = ACC
#速度变化上限
var velocityToward =0
#移动体对象
var body:KinematicBody2D
#朝向向量
var faceDirection:Vector2
#当前移动速度
var velocity:Vector2 = Vector2.ZERO

#构造器函数
func _init(kidBody:KinematicBody2D):
	body = kidBody
	
func onProcess(delta=0):
	pass
	
#_physiceProcess 回调
func onPhysicsProcess(delta):
	
	match isMoving:
		false:
			player_idle(delta)
		true:
			player_move(delta)
	#PlayState.ATTACK:
	#	player_attack(delta)

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
	print(velocity)
	if(velocityToward>velocityTowardLimit):
		velocityToward = velocityTowardLimit
	velocity =velocity.move_toward(faceDirection* velocityToward,acceleration*delta);
	print("velocity toward"+ velocity as String+" LIMIT:" +velocityToward as String)
	body.move_and_collide(velocity*delta)
#停下函数
func _stopPlayer(delta):
	velocityToward= 0
	_movePlayer(delta)

