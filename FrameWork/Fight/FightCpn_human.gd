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
func _ready():
	pass # Replace with function body.

export(float) var impact_strength=0;

enum FightMotion{
	
	Idle,
	Holding,
	Walk,
	Run,
	
	Attack_Up,
	Attack_Mid,
	Attack_Bot,
	
	HeavyAttack_U2M,
	HeavyAttack_U,
	HeavyAttack_U2B,
	
	HeavyAttack_M2U,
	HeavyAttack_M,
	HeavyAttack_M2B,
	
	HeavyAttack_B2U,
	HeavyAttack_B,
	HeavyAttack_B2M,
	
	Def_Up,
	Def_Mid,
	Def_Bot,
	
	HeavyDef_U,
	HeavyDef_U2M,
	HeavyDef_U2B,
	
	HeavyDef_M,
	HeavyDef_M2U,
	HeavyDef_M2B,
	
	HeavyDef_B,
	HeavyDef_B2M,
	HeavyDef_B2U
}

#改变 movableobjstate
func change_movable_state(input_vector,s):
	fightKinematicMovableObj.input_vector = input_vector
	fightKinematicMovableObj.state = s
	pass

#当前角色朝向
func is_face_left():
	return fightKinematicMovableObj.faceDirection.x<0

var prv_face_direction = Vector2.ZERO

var prv_animin =""
#动画结束事件
#根据动画名字检测动作
func _on_FightAnimationTree_State_Changed(anim_name):
	if anim_name ==null||anim_name=="":
		return 
	
	if prv_animin.find("_in",0)>0:
		fightKinematicMovableObj.attackOver()
	if anim_name.find("_pre")>0:
		fightKinematicMovableObj.state = FightKinematicMovableObj.ActionState.Attack
	if anim_name=="run2idle":
		fightKinematicMovableObj.state = FightKinematicMovableObj.ActionState.Run2Idle
	elif anim_name=="idle":
		fightKinematicMovableObj.state = FightKinematicMovableObj.ActionState.Idle
	elif anim_name =="idle2run":
		fightKinematicMovableObj.state = FightKinematicMovableObj.ActionState.Idle2Run
		
	#动画播放时长
	var time = animation_cfg.get(anim_name);
	if time==0:
		time=1
	if time !=null:
		$FightAnimationTree.set_deferred("parameters/TimeScale/scale",1/time)
		pass
	
	prv_animin = anim_name
	pass # Replace with function body.

#方向改变
func _on_FightKinematicMovableObj_FaceDirectionChanged(direction):
	if direction.x!=0 && direction.x != prv_face_direction.x:
		prv_face_direction = direction
		$SpriteAnimation.change_face_direction(prv_face_direction.x)


#移动状态改变
func _on_FightKinematicMovableObj_State_Changed(state):
	
	if  state != FightKinematicMovableObj.ActionState.Attack :
		
		if fightKinematicMovableObj.faceDirection.x!=0 && fightKinematicMovableObj.faceDirection.x != prv_face_direction.x:
			prv_face_direction = fightKinematicMovableObj.faceDirection
			$SpriteAnimation.change_face_direction(prv_face_direction.x)
		pass
	pass



func _on_Node2D_NewFightMotion(motion):
		
	$FightAnimationTree.act(motion)
	pass # Replace with function body.
