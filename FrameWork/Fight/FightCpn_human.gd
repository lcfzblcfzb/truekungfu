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
#动画结束事件
#根据动画名字检测动作
func _on_FightAnimationTree_State_Changed(anim_name):
	if anim_name ==null||anim_name=="":
		return 
	
	if prv_animin.find("_in",0)>0:
		
		#var prvAction = fightActionController.action_array.back() as FightActionController.ActionInfo
		#if prvAction!=null && prvAction.action_type>3:
		#	prvAction.state = FightActionController.ActionInfo.STATE_ENDED
				
		fightKinematicMovableObj.attackOver()
	if anim_name.find("_pre")>0:
		#var prvAction = fightActionController.action_array.back() as FightActionController.ActionInfo
		#if prvAction!=null && prvAction.action_type>3:
		#	prvAction.state = FightActionController.ActionInfo.STATE_ING
		
		fightKinematicMovableObj.state = FightKinematicMovableObj.ActionState.Attack
	if anim_name=="run2idle":
		fightKinematicMovableObj.state = FightKinematicMovableObj.ActionState.Run2Idle
	elif anim_name=="idle":
		fightKinematicMovableObj.state = FightKinematicMovableObj.ActionState.Idle
	elif anim_name =="idle2run":
		fightKinematicMovableObj.state = FightKinematicMovableObj.ActionState.Idle2Run
		
	prv_animin = anim_name
	pass # Replace with function body.


func _on_FightController_ActionStart(action:ActionInfo):
	
	var base =FightBaseActionMng.get_by_base_id(action.base_action)
	
	#$FightAnimationTree.call_deferred("act",action.base_action)
	#动画播放时长
	var time = animation_cfg.get(base.animation_name);
	if time==0 || time ==null:
		time=1
	#if time !=null:
	#	print("scale",$FightAnimationTree.get("parameters/TimeScale/scale"))
	#	$FightAnimationTree.set("parameters/TimeScale/scale",1/time)
	#	pass
	
	$FightAnimationTree.act(action.base_action,time)	
	
	#$FightAnimationTree.act(action.base_action)
	pass # Replace with function body.


func _on_FightController_ActionFinish(action:ActionInfo):
	var base =FightBaseActionMng.get_by_base_id(action.base_action)


