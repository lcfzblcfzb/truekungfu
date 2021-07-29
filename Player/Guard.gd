extends KinematicBody2D

var KinematicObj = preload("res://FrameWork/KinematicMovableObj.gd")
var kinematicObj :KinematicMovableObj

onready var sword = $sword

export var MAX_SPEED = 16
export var ATTACK_CD = 500

var player

var attacking = false

var lastActionTime = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	kinematicObj=KinematicMovableObj.new(self) 
	kinematicObj.MAX_SPEED =MAX_SPEED
	kinematicObj.isMoving = true

func _physics_process(delta):
	if(player!=null):
		var direction2Player:Vector2 = (player.global_position - self.global_position).normalized()
		kinematicObj.faceDirection = direction2Player
		if(!attacking):
			if(OS.get_ticks_msec() - lastActionTime>ATTACK_CD):
				attacking = true
				sword.swingRight(direction2Player.angle())
	kinematicObj.onPhysicsProcess(delta)
	




func _on_AnimationPlayer_animation_finished(anim_name):
	attacking = false
	lastActionTime = OS.get_ticks_msec()


func _on_swordBox_area_entered(area):
	print("enermy hit")

func _on_hurtbox_area_entered(area):
	print("enermy hurted by player")


func _on_attackRange_body_entered(body):
	kinematicObj.isMoving = false


func _on_attackRange_body_exited(body):
	kinematicObj.isMoving = true
