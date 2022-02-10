extends BasePlatformerCharactor

class_name FightComponent_human

var hp;

onready var fightKinematicMovableObj:FightKinematicMovableObj = $FightKinematicMovableObj
#接口
#需要传入controlableMovingObj的速度参数
func getSpeed():
	return $ActionHandler.getSpeed()
	
onready var sprite_animation = $SpriteAnimation
onready var actionMng:FightActionMng = $FightActionMng
onready var wu = $Wu
onready var corner_detector = $CornerDetect

#动作控制器。是玩家输入或者是 AI 控制器
var fight_controller :BaseFightActionController

export (bool) var is_player =false;

var player_controller_scene =preload("res://FrameWork/Fight/Controller/PlatformGestureController.tscn")
var ai_controller_scene=preload("res://FrameWork/Fight/Controller/AiFightGestureController.gd")

#是否处于可攀爬位置
func is_at_hanging_corner()->bool:
	return corner_detector.is_colliding_with_corner()

#重载setter方法，在b= false 的时候，设置climb状态的结束
func set_climbing(b):
	.set_climbing(b)
	if not b:
		fightKinematicMovableObj.climb_over()

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
	$Wu.wuxue.animation_player.root_node = $Wu.wuxue.animation_player.get_path_to(sprite_animation.get_node("hip"))
	
	#TODO 根据配置设置角色形象
#	sprite_animation.set_sprite_texture($Wu.get_texture())
	$Wu.wuxue.animation_tree.active = true
	
	#初始状态检测
	#TODO 可以指定初始状态
	if not is_on_floor():
		fightKinematicMovableObj.state = FightKinematicMovableObj.ActionState.JumpDown
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
		var oppo = oppose_array[0] as BaseCharactor
		
		if oppo.global_position.distance_to(global_position) < 200:
			is_engaged = true
		else:
			is_engaged = false
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
#	print("action frame:",$SpriteAnimation/Sprite.frame)
#	$FightAnimationTree.act(action,time)	
	get_animation_tree().act(action,time)

func _on_FightActionMng_ActionFinish(action:ActionInfo):
	var base =FightBaseActionDataSource.get_by_base_id(action.base_action) as BaseAction
	#可以用type 来过滤
	if base and "_in" in base.animation_name:
		fightKinematicMovableObj.attackOver()
		print("attack over time",OS.get_ticks_msec())
		print("attack over",$SpriteAnimation/Sprite.frame)
		
	if action.base_action == Tool.FightMotion.HangingClimb:
		fightKinematicMovableObj.hanging_climb_over(corner_detector._last_hang_climb_end)
		corner_detector.set_deferred("enabled", true)

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

#movableobj 状态变化信号
func _on_FightKinematicMovableObj_State_Changed(state):
	
	if (state ==FightKinematicMovableObj.ActionState.Idle or state ==FightKinematicMovableObj.ActionState.Hanging or state ==FightKinematicMovableObj.ActionState.HangingClimb ) and actionMng.is_connected("ActionProcess",fightKinematicMovableObj,"_on_FightActionMng_ActionProcess") :
		#在IDLE 的时候检测是否监听actionProcess事件并且取消监听	
		actionMng.call_deferred("disconnect","ActionProcess",fightKinematicMovableObj,"_on_FightActionMng_ActionProcess")
#		actionMng.disconnect("ActionProcess",fightKinematicMovableObj,"_on_FightActionMng_ActionProcess")
	elif state == FightKinematicMovableObj.ActionState.JumpUp or state == FightKinematicMovableObj.ActionState.JumpDown or  state == FightKinematicMovableObj.ActionState.Climb:
		#在jumpup jumpdown climb 的时候监听
		#可以在空中移动方向
		actionMng.connect("ActionProcess",fightKinematicMovableObj,"_on_FightActionMng_ActionProcess")
		pass
	
	if state == FightKinematicMovableObj.ActionState.HangingClimb:
		#进入HangingClimb阶段；	
		corner_detector.enabled = false
		pass
	elif state ==FightKinematicMovableObj.ActionState.Hanging:
		
		pass

#移动的时候碰到的tile的信息
func _on_FightKinematicMovableObj_CollisionObjChanged(collision:KinematicCollision2D):
	if collision:
		var collider = collision.collider
		if collider is Platform: 
			is_on_platform = true
			print("is platform")
		else:
			is_on_platform = false 
		

func _on_FightKinematicMovableObj_FaceDirectionChanged(v:Vector2):
	if v.y <= 0:
	
		if v.y<0:
			#不检测platform 层
			if collision_mask != 0b0000_0000_0000_0000_0000_0000_0001_0000 :
	#			set_deferred("collisaion_mask", 0b0000_0000_0000_0000_0000_0000_0001_0000)
				collision_mask = 0b0000_0000_0000_0000_0000_0000_0001_0000
		
	else:
		if not is_on_platform:
			#检测platform 层碰撞
	#		set_deferred("collision_mask", 0b0000_0000_0000_0000_0000_0000_1001_0000)
			if collision_mask != 0b0000_0000_0000_0000_0000_0000_1001_0000 :
	#			set_deferred("collisaion_mask", 0b0000_0000_0000_0000_0000_0000_1001_0000)
				collision_mask = 0b0000_0000_0000_0000_0000_0000_1001_0000
		pass
		


func _on_FightKinematicMovableObj_Active_State_Changed(base_action):
	var base = FightBaseActionDataSource.get_by_base_id(base_action) as BaseAction
	if base != null :
		if base_action == Tool.FightMotion.JumpUp or base_action == Tool.FightMotion.JumpDown:
			var action = Tool.getPollObject(ActionInfo,[base_action, OS.get_ticks_msec(), [Vector2.ZERO], base.get_duration(), ActionInfo.EXEMOD_SEQ, true, true])
			actionMng.regist_actioninfo(action)
		else:
			var action = Tool.getPollObject(ActionInfo,[base_action, OS.get_ticks_msec(), [Vector2.ZERO], base.get_duration(), ActionInfo.EXEMOD_GENEROUS, false, true])
			actionMng.regist_actioninfo(action)
