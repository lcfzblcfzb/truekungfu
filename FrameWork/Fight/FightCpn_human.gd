extends Node2D

class_name FightComponent_human

onready var fightKinematicMovableObj:FightKinematicMovableObj = $FightKinematicMovableObj
#接口
#需要传入controlableMovingObj的速度参数
func getSpeed():
	return $ActionHandler.getSpeed()
#保存动画时间的字典
onready var animation_cfg = $StateController
# Called when the node enters the scene tree for the first time.

onready var sprite = $SpriteAnimation/Sprite

onready var actionMng = $FightActionMng
func _ready():
	$Wu.switch_wu(1)
	sprite.texture = $Wu.get_texture()
	yield(get_tree().create_timer(2),"timeout")
	$Wu.switch_wu(2)
	sprite.texture = $Wu.get_texture()
	pass 

export(float) var impact_strength=0;

#当前角色朝向
func is_face_left():
	return fightKinematicMovableObj.charactor_face_direction.x<0

var prv_face_direction = Vector2.ZERO

var prv_animin =""

func get_animation_tree():
	
	return $Wu.get_animation_tree()
	pass

func _on_FightActionMng_ActionStart(action:ActionInfo):
	
	if action==null:
		push_error("actioninfo is null.")
		return
	
	var base =FightBaseActionMng.get_by_base_id(action.base_action) as BaseAction
	#动画播放时长
	var time = base.duration
	if time<=0 || time ==null:
		time=1
		
	print("action start time",OS.get_ticks_msec())
	print("attack start:",$SpriteAnimation/Sprite.frame)
#	$FightAnimationTree.act(action,time)	
	get_animation_tree().act(action,time)

func _on_FightActionMng_ActionFinish(action:ActionInfo):
	var base =FightBaseActionMng.get_by_base_id(action.base_action) as BaseAction
	#可以用type 来过滤
	if "_in" in base.animation_name:
		fightKinematicMovableObj.attackOver()
		print("attack over time",OS.get_ticks_msec())
		print("attack over",$SpriteAnimation/Sprite.frame)
		print("attack over current time scale",$FightAnimationTree.get("parameters/TimeScale/scale"))

