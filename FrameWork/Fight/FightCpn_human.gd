extends Node2D

class_name FightComponent_human

onready var fightKinematicMovableObj:FightKinematicMovableObj = $FightKinematicMovableObj
onready var fightActionController = $FightController
#接口
#需要传入controlableMovingObj的速度参数
func getSpeed():
	return $ActionHandler.getSpeed()
#保存动画时间的字典
onready var animation_cfg = $StateController
# Called when the node enters the scene tree for the first time.
func _ready():
	fightActionController.state_controller = animation_cfg
	pass # Replace with function body.

export(float) var impact_strength=0;

#当前角色朝向
func is_face_left():
	return fightKinematicMovableObj.charactor_face_direction.x<0

var prv_face_direction = Vector2.ZERO

var prv_animin =""

func _on_FightController_ActionStart(action:ActionInfo):
	
	if action==null:
		push_error("actioninfo is null.")
		return
	
	var base =FightBaseActionMng.get_by_base_id(action.base_action)
	#动画播放时长
	var time = animation_cfg.get(base.animation_name);
	if time==0 || time ==null:
		time=1
		
	print("action start time",OS.get_ticks_msec())
	print("attack start:",$SpriteAnimation/Sprite.frame)
	$FightAnimationTree.act(action,time)	


func _on_FightController_ActionFinish(action:ActionInfo):
	var base =FightBaseActionMng.get_by_base_id(action.base_action) as BaseAction
	#可以用type 来过滤
	if "_in" in base.animation_name:
		fightKinematicMovableObj.attackOver()
		print("attack over time",OS.get_ticks_msec())
		print("attack over",$SpriteAnimation/Sprite.frame)
		print("attack over current time scale",$FightAnimationTree.get("parameters/TimeScale/scale"))


