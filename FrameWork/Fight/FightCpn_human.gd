
extends KinematicBody2D

class_name FightComponent_human

onready var fightKinematicMovableObj:FightKinematicMovableObj = $FightKinematicMovableObj
#接口
#需要传入controlableMovingObj的速度参数
func getSpeed():
	return $ActionHandler.getSpeed()
#保存动画时间的字典
onready var animation_cfg = $StateController
onready var sprite = $SpriteAnimation/Sprite
onready var actionMng = $FightActionMng

#动作控制器。是玩家输入或者是 AI 控制器
export(NodePath) var fight_controller_path
var fight_controller :BaseFightActionController
#战斗角色的阵营
export (Tool.CampEnum)var camp = Tool.CampEnum.Bad

func _ready():
	
	fight_controller = get_node(fight_controller_path)
	fight_controller.connect("NewFightMotion",$Wu,"_on_FightController_NewFightMotion")
#	$Wu.switch_wu(WuxueMng.WuxueEnum.Fist)
#	sprite.texture = $Wu.get_texture()
#	yield(get_tree().create_timer(2),"timeout")
#	$Wu.switch_wu(WuxueMng.WuxueEnum.Sword)
#	sprite.texture = $Wu.get_texture()
	
#	test_switch()
	pass 

#func test_switch():
#
#	var gongfu =[WuxueMng.WuxueEnum.Fist,WuxueMng.WuxueEnum.Sword]
#	var i=0;
#
#	while (true):
#		var choosed = gongfu[i % gongfu.size()]
#		$Wu.switch_wu(choosed)
#		sprite.texture = $Wu.get_texture()
#		i=i+1
#		if i>1000:
#			break
#	pass
	
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
	print("action frame:",$SpriteAnimation/Sprite.frame)
#	$FightAnimationTree.act(action,time)	
	get_animation_tree().act(action,time)

func _on_FightActionMng_ActionFinish(action:ActionInfo):
	var base =FightBaseActionMng.get_by_base_id(action.base_action) as BaseAction
	#可以用type 来过滤
	if "_in" in base.animation_name:
		fightKinematicMovableObj.attackOver()
		print("attack over time",OS.get_ticks_msec())
		print("attack over",$SpriteAnimation/Sprite.frame)

func test_dead_motion():
	
	var tween = $Tween
	tween.interpolate_property(self,"position",position,position+Vector2(0,50),1,Tween.TRANS_LINEAR,Tween.EASE_IN)
	tween.start()
	yield(tween,"tween_completed")
	queue_free()
	pass		


func _on_weaponBox_area_entered(area):
	
	if area is HurtBox:
		
		pass
	pass # Replace with function body.


func _on_hurtbox_area_entered(area):
	
	if area is WeaponBox:
		test_dead_motion()
		pass
	pass # Replace with function body.
