extends Node2D


var ControlableMovingObj = preload("res://Player/ControlableMovingObj.gd")
var controableMovingObj :ControlableMovingObj


onready var animationPlayer = $AnimationPlayer
onready var animationTree =$AnimationTree
onready var idleStateMachine:AnimationNodeStateMachinePlayback  =animationTree["parameters/Idle/playback"]
onready var playerStateMachine = animationTree["parameters/playback"]
onready var attackStateMachine:AnimationNodeStateMachinePlayback = animationTree["parameters/Attack/playback"]
onready var mouseMng = PlayerMouseMng.new(self)


onready var rightHand =$Sprite/rightHand

onready var state =PlayerState.IDLE;

#方向角度常量定义
const DOWN_RAD = PI/2
const UP_RAD = PI*3/4
const RIGHT_RAD = 0
const LEFT_RAD = PI

#是否进入战斗
var engaged = false;
#是否战斗准备
var prepared = false;
#攻击范围
export var attackRange =  PI*2/3

#朝向向量方向值（弧度）
func faceDirectionRadian()->float:
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
	
func _physics_process(delta):
	controableMovingObj.onPhysicsProcess(delta)

func _process(delta):
	controableMovingObj.onProcess(delta)	
	
func printStateMachine():
	
	print(idleStateMachine.get_current_node())
	print(playerStateMachine.get_current_node())
	print(attackStateMachine.get_current_node())

func _input(event):
	
	if(event is InputEventKey):
		if event.is_action_pressed("prepared"):
			
			#idleStateMachine.travel("idle_prepared")
			
			animationTree.set("parameters/Idle2/Transition/current",2)
			animationTree.set("parameters/Idle2/tran_prepared/current",0)
		
	if event.is_action_pressed("attack"):
			
			#idleStateMachine.travel("idle_engaged")
			#animationTree.set("parameters/Idle2/engagedShot/active",true)
			#animationTree.set("parameters/Idle2/seek_engaged/seek_position",0)
			
			animationTree.set("parameters/Idle2/Transition/current",1)
			animationTree.set("parameters/Idle2/tran_engaged/current",0)
			
	if event.is_action_released("attack"):
		
			playerStateMachine.travel("Attack")
			attackStateMachine.travel("attack_down")
	
	if event.is_action_pressed("ui_cancel"):
		
		animationTree.set("parameters/Idle2/Transition/current",2)

		
#由animationPlayer触发
#  (bug)：会触发2次 不知道为什么。重启完正常了
func attackOver():
	
	controableMovingObj.attackOver()
	print("atk over")
	playerStateMachine.travel("Idle2")
	animationTree.set("parameters/Idle2/tran_engaged/current",1)
	#animationTree.set("parameters/Idle2/Transition/current",1)
	#idleStateMachine.travel("idle_prepared")
	
func _on_rightHand_block_end():
	controableMovingObj.attackOver()
	playerStateMachine.travel("Idle2")
	animationTree.set("parameters/Idle2/Transition/current",1)
	print("righthand blocked ending")
	print(idleStateMachine.get_current_node() )
	print("test func call block")
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
			print("attack endPos:"+endPosRotation as String)
			weaponRotation = endPosRotation
		else:
			#求夹角--》cos()值，总能得到夹角的值，然后比大小;
			#比大小： cos值越大，夹角角度越小
			var toRight =endPosRotation - rightLimit
			var toLeft = endPosRotation - leftLimit
			if(cos(toRight)>cos(toLeft)):
				print("attack Rightimit")
				weaponRotation = rightLimit
			else :
				print("attack LeftLimit")
				weaponRotation = leftLimit
		
		jisu.rightHand.attack(weaponRotation)
	
	func _init(e).(e):
		pass




func _on_attackBox_area_entered(area):
	print("player hit enermy")
	print(area)


func _on_hurtBox_area_entered(area):
	print("player hurt by enermy")
	


func _on_Weapon_area_entered(area):
	if area is Weapon:
		print("seek position")
		var sec = attackStateMachine.get_current_play_position()
		
		print(sec)
		print("lenght")
		print(attackStateMachine.get_current_length())

		attackStateMachine.travel("attack_down_blocked")
		var cn =attackStateMachine.get_current_node()
		#animationTree.set("parameters/Attack/attack_down_blocked/Seek/seek_position",attackStateMachine.get_current_length()-sec)


