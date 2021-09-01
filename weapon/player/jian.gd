extends Weapon

signal block_end

onready var weaponBox =$weaponBox
onready var animationPlayer = $Sprite/AnimationPlayer
onready var shape2d:CollisionShape2D =$WeaponBox/CollisionShape2D
onready var audioPlayer = $Sprite/AudioStreamPlayer2D
onready var sprite =$Sprite
onready var defBox = $defBox
onready var sparkEffect = $spark as Particles2D

onready var blockSound = preload("res://sound/sword_hit001.wav")

var faceDownOffset :float = -40.0/180.0*PI
var faceLeftOffset:float = -130.0/180.0 *PI
var faceUpOffset:float = 104/180.0 *PI
var faceRightOffset:float = 11.1/180.0 *PI

var blocked = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	weaponBox.weapon = self
	defDirection(Vector2.DOWN)

#attack:
func attack(dir:float=0):
	sprite.rotation = dir+faceDownOffset	
	
	

#attack:
func attackDirection(dir:float=0,faceDirection:Vector2=Vector2.DOWN):
	sprite.offset = Vector2.ZERO
	var offset = 0
	match faceDirection:
		Vector2.DOWN:
			offset = faceDownOffset
		Vector2.UP:
			offset = faceUpOffset
		Vector2.LEFT:
			offset = faceLeftOffset
		Vector2.RIGHT:
			offset = faceRightOffset
	sprite.rotation = dir+offset	
	

	print("dir:"+dir as String)
	print("rotation:"+rotation as String)
	
func block_end():
	blocked = false
	emit_signal("block_end")


#defBox 自动防御的区域
func defDirection(direction:Vector2):
	defBox.rotation = direction.angle()


func _on_weaponBox_area_entered(area):
	if area is WeaponBox:
		blocked = true
		audioPlayer.stream = blockSound
		audioPlayer.play()
		
		var material = sparkEffect.process_material as ParticlesMaterial
		#金属火花碰撞
		var dir =Vector3.ZERO
		var dirTmp =self.global_position.direction_to(area.global_position)
		dir.x = dirTmp.x
		dir.y = dirTmp.y
		material.direction = dir
		sparkEffect.global_position = area.global_position
		sparkEffect.restart()
			#shape2d.set_deferred("disabled",true)
			#var  sec = animationPlayer.current_animation_position
			#animationPlayer.play("swingBlocked")
			#animationPlayer.seek(animationPlayer.current_animation_length-sec)

func _on_defBox_area_entered(area):
	if area is WeaponBox:
		blocked = true
		audioPlayer.stream = blockSound
		audioPlayer.play()
