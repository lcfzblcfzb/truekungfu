extends BaseCharactor

var ControlableMovingObj = preload("res://Player/ControlableMovingObj.gd")
var controableMovingObj :ControlableMovingObj


onready var animationPlayer = $AnimationPlayer
onready var animationTree =$AnimationTree
onready var playerStateMachine = animationTree["parameters/StateMachine/playback"]
onready var attackStateMachine:AnimationNodeStateMachinePlayback = animationTree["parameters/StateMachine/Attack/playback"]

onready var mouseMng = PlayerMouseMng.new(self)
onready var audioPlayer = $AudioStreamPlayer
onready var sprite = $Sprite

onready var rightHand =$Sprite/rightHand

onready var state =PlayerState.IDLE;

#未进入战斗姿态转换计时器。
onready var engagedAutoShiftTimer = $Timer
export var ENGAGED_AUTO_SHIFT_TIME = 5

#方向角度常量定义
const DOWN_RAD = PI/2
const UP_RAD = PI*3/2
const RIGHT_RAD = 0.0
const LEFT_RAD = PI

#是否进入战斗
var engaged = false setget setEngaged;
#是否战斗准备
var prepared = false setget setPrepared;

#暂时变量，指示是否处于危险
export var Dangerous = false setget setDangerous,isDangerous;

#锁定状态---》朝向由鼠标朝向指定
var locked =false setget setLocked

#攻击范围
export var attackRange =  PI*2/3

#=============================↓↓↓↓↓↓↓↓↓↓↓↓↓函数区↓↓↓↓↓↓↓↓↓↓↓↓

func setLocked(v):
	locked =v
	if( locked):
		controableMovingObj.velocityTowardLimit = controableMovingObj.MAX_SPEED_ATTACK
	else:
		controableMovingObj.velocityTowardLimit = controableMovingObj.MAX_SPEED

func isDangerous():
	return Dangerous;
func setDangerous(v):
	Dangerous = v
	if !v:
		_startEngagedAutoShiftTimer()
#由场景触发，而且正常来每一场战斗说<必定>会触发一次，标志战斗结束，让角色做一个入鞘动作
#也可能在和平状态下，玩家使用攻击指令也会触发计时器，不过当计时器结束检测处于和平状态，则做一个入鞘动作
func _startEngagedAutoShiftTimer():
	engagedAutoShiftTimer.start(ENGAGED_AUTO_SHIFT_TIME)		

func setEngaged(s):
	if s:
		var currentIdleState =animationTree.get("parameters/StateMachine/Idle/Transition/current")
		animationTree.set("parameters/StateMachine/Idle/Transition/current",1)
		#如果是idle_free， 则设置一个拔剑动作
		if(currentIdleState==0):
			animationTree.set("parameters/StateMachine/Idle/tran_engaged/current",0)
		animationTree.set("parameters/StateMachine/Move/Transition/current",1)
	else:
			
		animationTree.set("parameters/StateMachine/Idle/Transition/current",0)
		animationTree.set("parameters/StateMachine/Move/Transition/current",0)
	
	engaged = s

func setPrepared(s):
	if s!=prepared:
		animationTree.set("parameters/StateMachine/Idle/tran_prepared/current",0)
		#设置prepared的blendspace。1代表拔刀，0代表收刀
		if s:
			animationTree.set("parameters/StateMachine/Idle/prepared_bs/blend_position",1)
			animationTree.set("parameters/StateMachine/Idle/Transition/current",2)
		else:
			animationTree.set("parameters/StateMachine/Idle/prepared_bs/blend_position",-1)
			animationTree.set("parameters/StateMachine/Idle/Transition/current",0)
	prepared =s
	
func _movingObjStateChanged(s):
	
	match s:
		ControlableMovingObj.PlayState.Attack:
			playerStateMachine.travel("Attack")
		ControlableMovingObj.PlayState.Idle:
			playerStateMachine.travel("Idle")
		ControlableMovingObj.PlayState.Moving:
			playerStateMachine.travel("Move")

func getFaceDirection()->Vector2:
	return controableMovingObj.faceDirection

#朝向向量方向值（弧度）
func faceDirectionRadian()->float:
	match controableMovingObj.faceDirection:
		Vector2.DOWN :
			return DOWN_RAD
		Vector2.UP:
			return UP_RAD
		Vector2.LEFT:
			return LEFT_RAD
		Vector2.RIGHT:
			return RIGHT_RAD
	
	return DOWN_RAD

#可攻击 范围
func attackEndPosLimitRadian(dir:bool=true)->float:
	var s = 1
	if !dir:
		s = -1;
	return faceDirectionRadian()+attackRange*s/2
	
func _ready():
	add_child(mouseMng)
	controableMovingObj = ControlableMovingObj.new(self)
	controableMovingObj.isMovableWhenAttack = true
	controableMovingObj.connect("State_Changed",self,"_movingObjStateChanged")
	controableMovingObj.velocityTowardLimit = controableMovingObj.MAX_SPEED
	
func _physics_process(delta):
	controableMovingObj.onPhysicsProcess(delta)

func _process(delta):
	controableMovingObj.onProcess(delta)
	
	if locked:
		# var screenPos =Tool.getCameraPosition(self) 填self 不会确定位置
		var screenPos =Tool.getCameraPosition(sprite)
		var input_vector = (mouseMng.mouseMovingPos- screenPos).normalized()
		
		animationTree.set("parameters/StateMachine/Idle/idle_engaged_bs/blend_position",input_vector)
		animationTree.set("parameters/StateMachine/Idle/idle_free_bs/blend_position",input_vector)
		animationTree.set("parameters/StateMachine/Move/move_engaged_bs/blend_position",input_vector)
		animationTree.set("parameters/StateMachine/Move/move_free_bs/blend_position",input_vector)
		animationTree.set("parameters/StateMachine/Attack/attack_bs/blend_position",input_vector)
		animationTree.set("parameters/StateMachine/Attack/block_bs/blend_position",input_vector)
		
	else:
		animationTree.set("parameters/StateMachine/Idle/idle_engaged_bs/blend_position",controableMovingObj.faceDirection)
		animationTree.set("parameters/StateMachine/Idle/idle_free_bs/blend_position",controableMovingObj.faceDirection)
		animationTree.set("parameters/StateMachine/Move/move_engaged_bs/blend_position",controableMovingObj.faceDirection)
		animationTree.set("parameters/StateMachine/Move/move_free_bs/blend_position",controableMovingObj.faceDirection)
		animationTree.set("parameters/StateMachine/Attack/attack_bs/blend_position",controableMovingObj.faceDirection)
		animationTree.set("parameters/StateMachine/Attack/block_bs/blend_position",controableMovingObj.faceDirection)
		

	
func printStateMachine():
	
	print(playerStateMachine.get_current_node())
	print(attackStateMachine.get_current_node())

func _input(event):
	
	if(event is InputEventKey):
		if event.is_action_pressed("prepared"):
			self.prepared = !self.prepared
		if event.is_action_pressed("lock"):
			self.locked = !self.locked
		
	if event.is_action_pressed("attack"):
			
		#idleStateMachine.travel("idle_engaged")
		#animationTree.set("parameters/StateMachine/Idle2/engagedShot/active",true)
		#animationTree.set("parameters/StateMachine/Idle2/seek_engaged/seek_position",0)
		rightHand.visible = true
		self.engaged = true
		#Engine.time_scale = 0.1
			
	if event.is_action_released("attack"):
		attackStateMachine.travel("attack_bs")
		
		if !isDangerous():
			_startEngagedAutoShiftTimer()
	
		#Engine.time_scale = 1
	
	if event.is_action_pressed("ui_cancel"):
		
		animationTree.set("parameters/StateMachine/Idle/Transition/current",2)

		
#由animationPlayer触发
#  (bug)：会触发2次 不知道为什么。重启完正常了
func attackOver():
	
	controableMovingObj.attackOver()
	animationTree.set("parameters/StateMachine/Idle/tran_engaged/current",1)
	#animationTree.set("parameters/StateMachine/Idle2/Transition/current",1)
	#idleStateMachine.travel("idle_prepared")
	
func _on_rightHand_block_end():
	controableMovingObj.attackOver()

	animationTree.set("parameters/StateMachine/Idle/tran_engaged/current",1)
	#animationTree.set("parameters/StateMachine/Idle/Transition/current",1)
	#idleStateMachine.travel("idle_engaged")


func printMe():
	print("printme")
	
enum PlayerState{
	IDLE,
	MOVE,
	ROLL,
	ATTACK
}

#主角鼠标移动控制器；
class PlayerMouseMng  :
	
	#继承自MouseMng，调用回调方法；
	extends "res://FrameWork/MouseGestureMng.gd"
		
	func onMouseMovingPosChange():
		pass
	
	func onAttackPosChange():
		pass
	
	func onEndPosChange():
		var rightLimit= jisu.attackEndPosLimitRadian()
		var leftLimit= jisu.attackEndPosLimitRadian(false)
		var weaponRotation = Vector2.ZERO
		if(endPosRotation>=leftLimit && endPosRotation<=rightLimit):
			weaponRotation = endPosRotation
		else:
			#求夹角--》cos()值，总能得到夹角的值，然后比大小;
			#比大小： cos值越大，夹角角度越小
			var toRight =endPosRotation - rightLimit
			var toLeft = endPosRotation - leftLimit
			if(cos(toRight)>cos(toLeft)):
				weaponRotation = rightLimit
			else :
				weaponRotation = leftLimit
		jisu.rightHand.attackDirection(weaponRotation,jisu.getFaceDirection())
	
	func _init(e).(e):
		pass


func _on_hurtBox_area_entered(area):
	print("player hurt by enermy")
	

func _on_weaponBox_area_entered(area):
	if area is WeaponBox:
		
		print("player weapon hit")
		var sec = attackStateMachine.get_current_play_position()
		attackStateMachine.travel("blocked_bs")
		var cn =attackStateMachine.get_current_node()
		#animationTree.set("parameters/StateMachine/Attack/attack_down_blocked/Seek/seek_position",attackStateMachine.get_current_length()-sec)


func _on_Timer_timeout():
	if !isDangerous():
		self.engaged = false
