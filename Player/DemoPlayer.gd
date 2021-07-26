extends Node2D

var InputMng =preload("res://FrameWork/InputMng.gd")

#攻击指示标（鼠标按下和抬起的位置）
var endPos = Vector2.ZERO
var attackPos = Vector2.ZERO
#攻击标识符
onready var attackMark = $mark
#武器模型
onready var sword =$sword
#剑轨迹
onready var swordPathLeft =$sword/swordPathLeft
#剑轨迹
onready var swordPathRight =$sword/swordPathRight


#状态机
onready var state = State.Idle setget setState

func setState(s):
	state = s
	
enum State{
	Idle,
	Attack
}

#攻击方向。叉乘获得。顺时针为正值
var attackDirection =0

var beginTime = 0
func _input(event):
	if(event is InputEventKey):
		if event.is_action_pressed("ui_up"):
			print("move up")
		elif event.is_action_pressed("ui_down"):
			print("move down")
		elif event.is_action_pressed("ui_left"):
			print("move left")
		elif event.is_action_pressed("ui_right"):
			print("move right")
			
	if(event is InputEventMouse):
		
		if event.is_action_pressed("attack"):
			attackMark.visible = true
			attackPos =event.global_position;
			print("attack!")
		elif event.is_action_released("attack"):
			print("attack end!")
			beginTime=OS.get_system_time_msecs()
			attackMark.visible = false
			endPos = event.global_position
			angleSpeed = MaxAngleSpeed;
			predict(angleSpeed,AngleAcc)
			
			var startVector = attackPos - global_position
			var moveVector = endPos - global_position

			attackDirection =sign(startVector.cross(moveVector))
			if attackDirection==0:
				attackDirection =1;
			
			var radion =endPos.angle_to_point(self.global_position)
			sword.rotation = radion-attackDirection *PI/3
			state = State.Attack;
			
			
	if(event is InputEventMouseMotion):
		#relativePos = event.relative;
		attackMark.global_position = event.global_position
				
	#	print(event.relative as String+" ;"+ event.tilt as String+" ;"+event.speed as String+";"+ event.is_action_released("attack") as String)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

export var MaxAngleSpeed = (PI/2)
export var AngleAcc = 0.01
var angleSpeed = 0

var t =0.0
const swingExpT = 0.3
func _physics_process(delta):
	
	if state == State.Idle :
		pass
	elif state == State.Attack:
		#计算加速度
		angleSpeed = angleSpeed -AngleAcc*delta;
		
		if angleSpeed>0:
			
			sword.rotation +=  attackDirection* angleSpeed*delta
			
			#t = t+1
			#if attackDirection<=0:	
			#	sword.position = swordPathLeft.curve.interpolate_baked(t * delta/ swingExpT * swordPathLeft.curve.get_baked_length(), true)
			#else:
			#	sword.position = swordPathRight.curve.interpolate_baked(t * delta/ swingExpT * swordPathRight.curve.get_baked_length(), true)

		else:
			print(OS.get_system_time_msecs()-beginTime);
			state =State.Idle
	
	

# 预测测试
func predict(v,a):
	var time = v/a
	print("predict");
	print(time)
