extends BasePlatformerCharactor

class_name FightComponent_human

var hp;

onready var fightKinematicMovableObj:FightKinematicMovableObj = $FightKinematicMovableObj
#接口
#需要传入controlableMovingObj的速度参数
func getSpeed():
	return $ActionHandler.getSpeed()
#保存动画时间的字典
onready var animation_cfg = $StateController
onready var sprite_animation = $SpriteAnimation
onready var actionMng:FightActionMng = $FightActionMng
onready var wu = $Wu

#动作控制器。是玩家输入或者是 AI 控制器
var fight_controller :BaseFightActionController

export (bool) var is_player =false;

var player_controller_scene =preload("res://FrameWork/Fight/Controller/PlatformGestureController.tscn")
var ai_controller_scene=preload("res://FrameWork/Fight/Controller/AiFightGestureController.gd")

func _ready():
	
	if is_player:
		fight_controller = player_controller_scene.instance()
		fight_controller.jisu = self
		add_child(fight_controller)
		fight_controller.connect("NewFightMotion",$Wu,"_on_FightController_NewFightMotion")
	else:
		#TODO AI controller
		fight_controller = ai_controller_scene.new() 
		add_child(fight_controller)
		fight_controller.connect("NewFightMotion",$Wu,"_on_FightController_NewFightMotion")
		fight_controller.init_behaviour_tree(self,$Wu.get_behavior_tree())
		fight_controller.call_deferred('active_tree')
		
	#初始化 武学
	$Wu.wuxue.animation_player.root_node = $Wu.wuxue.animation_player.get_path_to(sprite_animation)
	sprite_animation.set_sprite_texture($Wu.get_texture())
	$Wu.wuxue.animation_tree.active = true
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

func get_velocity():
	return fightKinematicMovableObj.velocity

#是否进战斗了
var is_engaged=false

#检测是否进战斗了	
func check_engaged():
	var oppose_array = CharactorMng.findOpposeMember(camp)
	if oppose_array.size()>0:
		is_engaged = true
	else:
		is_engaged = false
	
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
	
	var base =FightBaseActionDataSource.get_by_base_id(action.base_action) as BaseAction
	
	if base == null:
		return
	
	#动画播放时长
	var time = base.duration
	if time<=0 || time ==null:
		time=1
		
	print("action start time",OS.get_ticks_msec())
	print("action frame:",$SpriteAnimation/Sprite.frame)
#	$FightAnimationTree.act(action,time)	
	get_animation_tree().act(action,time)

func _on_FightActionMng_ActionFinish(action:ActionInfo):
	var base =FightBaseActionDataSource.get_by_base_id(action.base_action) as BaseAction
	#可以用type 来过滤
	if base and "_in" in base.animation_name:
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
	elif area is WeaponBox:
		
		var otherfighter =area.fight_cpn as FightComponent_human
		wu.wuxue.against_wuxue(otherfighter.wu.wuxue)
		pass
	pass # Replace with function body.


func _on_hurtbox_area_entered(area):
	
	if area is WeaponBox:
		isDead  = true
		test_dead_motion()
		pass
	pass # Replace with function body.
