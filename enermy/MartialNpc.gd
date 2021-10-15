extends NpcOf2Direction

var aggresiveMovingContril:AggresiveCharactor
#1:right,-1:left
var faceDirection = 1 setget setFaceDirection

onready var ai:AI =$AI
onready var animationTree = $AnimationTree
#行为状态机
var actionSM 

# Called when the node enters the scene tree for the first time.
func _ready():
	aggresiveMovingContril = AggresiveCharactor.new() 
	ai.movableObj = aggresiveMovingContril
	aggresiveMovingContril.connect("State_Changed",self,"onStateChanged")
	actionSM = animationTree.get("parameters/bt/sm/playback")
	
func _process(delta):
	aggresiveMovingContril.onProcess(delta)
	
func _physics_process(delta):
	aggresiveMovingContril.onPhysicsProcess(delta)

func setFaceDirection(v):
	if faceDirection!=v :
		faceDirection = v
		_setBlendPosition(v)
		
#角色朝向变化
func onFaceDirectionChange(v):
	var bp = 0
	if(v.x>0):
		bp=1
	elif v.x<0:
		bp=-1
	if faceDirection!=bp :
		self.faceDirection = bp
		_setBlendPosition(bp)

#设置animationTree中所有的blendspace1D 的position
func _setBlendPosition(position):
	var v = Vector2.ZERO
	v.x = position
	animationTree.set("parameters/bt/sm/attack/attack001/blend_position",v)
	animationTree.set("parameters/bt/sm/attack/attack002/blend_position",v)
	animationTree.set("parameters/bt/sm/death/blend_position",v)
	animationTree.set("parameters/bt/sm/idle/blend_position",v)
	animationTree.set("parameters/bt/sm/move/blend_position",v)

func onStateChanged(s):
	var sm = animationTree.get("parameters/bt/sm/playback");
	match s:
		AggresiveCharactor.PlayState.Moving:
			sm.travel("move")
			pass
		AggresiveCharactor.PlayState.Idle:
			sm.travel("idle")
			pass
		AggresiveCharactor.PlayState.Attack:
			sm.travel("attack")
			pass

func onDead():
	actionSM.travel("death")

func attack():
	aggresiveMovingContril.state = AggresiveCharactor.PlayState.Attack
	actionSM.travel("attack")

func attackOver():
	aggresiveMovingContril.state = AggresiveCharactor.PlayState.Idle
