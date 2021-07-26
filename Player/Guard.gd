extends KinematicBody2D

var KinematicObj = preload("res://FrameWork/KinematicMovableObj.gd")
var kinematicObj :KinematicMovableObj

onready var sword = $sword

export var MAX_SPEED = 16
export var ATTACK_CD = 500

var player

var velocity = 0

var attacking = false

var lastActionTime = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	kinematicObj=KinematicMovableObj.new(self) 
	kinematicObj.MAX_SPEED =MAX_SPEED

func _physics_process(delta):
	if(player!=null):
		var direction2Player:Vector2 = (player.global_position - self.global_position).normalized()
		kinematicObj.faceDirection = direction2Player
		kinematicObj.isMoving = true
		if(!attacking):
			if(OS.get_ticks_msec() - lastActionTime>ATTACK_CD):
				kinematicObj.isMoving = true
				attacking = true
				sword.swingRight(direction2Player.angle())
	kinematicObj.onPhysicsProcess(delta)
	



func _on_attackRange_body_entered(body):
	velocity = 0


func _on_attackRange_body_exited(body):
	velocity = MAX_SPEED


func _on_AnimationPlayer_animation_finished(anim_name):
	attacking = false
	kinematicObj.isMoving = true
	lastActionTime = OS.get_ticks_msec()


func _on_swordBox_area_entered(area):
	print("player hitted")
