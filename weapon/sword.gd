extends Sprite


#in radius
export var swordDirection =0 setget setSwordDirection

onready var animation = $AnimationPlayer
onready var collisionShape = $swordBox/CollisionShape2D
onready var swordBox = $swordBox


func _ready():
	if(material):
		material.set_shader_param("nb_frames",Vector2(hframes, vframes))


func _process(delta):
	if(material):
		material.set_shader_param("frame_coords",frame_coords)
		material.set_shader_param("velocity",1)

func setSwordDirection(dir):
	swordDirection = dir
	rotation =  swordDirection

func swingLeft(dir:float):
	setSwordDirection(dir)
	visible = true
	monitaling(true)
	animation.play("swingLeft")
	var slAni = animation.get_animation("swingLeft")
	var oTime =slAni.length;
	var attackTime = 0.5;
	var bonus = -0.0
	var newTime = attackTime+bonus
	var rate = oTime/newTime
	animation.play("swingLeft",-1,rate);
	
	
func swingRight(dir:float):
	setSwordDirection(dir)
	visible = true
	monitaling(true)
	animation.play("swingRight")

func invalidCollision():
	collisionShape.set_deferred("disabled",true)

func monitaling(v:bool):
	swordBox.set_deferred("monitoring",v) 
	
func monitable(v:bool):
	swordBox.set_deferred("monitorable",v) 

func _on_AnimationPlayer_animation_finished(anim_name):
	visible = false

