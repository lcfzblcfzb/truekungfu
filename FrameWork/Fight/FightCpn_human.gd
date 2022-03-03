extends BasePlatformerCharactor

class_name FightComponent_human

var block_value=5
var health_point=1

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
#是否是玩家操作的角色
export (bool) var is_player =false;
#控制器的预加载
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
	
	#初始化 武器碰撞
	var col = CollisionShape2D.new()
	col.shape = wu.get_weapon_box()
	sprite_animation.weapon_box.add_child(col)
	if col.shape is CapsuleShape2D:
		col.position.x = col.shape.radius
	#设置fight_cpn 到hitbox和hurtbox
	sprite_animation.weapon_box.fight_cpn = self
	sprite_animation.hurt_box.fight_cpn = self
	
	if is_player:
		fight_controller = player_controller_scene.instance()
		fight_controller.jisu = self
		add_child(fight_controller)
		fight_controller.connect("NewFightMotion",$Wu,"_on_FightController_NewFightMotion")
		
		#设置武器碰撞检测层
		sprite_animation.weapon_box.collision_layer = 0b0001
		sprite_animation.weapon_box.collision_mask = 0b1000
		sprite_animation.hurt_box.collision_layer = 0b0010
		sprite_animation.hurt_box.collision_mask = 0b0100
		var camera = Camera2D.new()
		add_child(camera)
		camera.current = true
		
	else:
		#TODO AI controller
		fight_controller = ai_controller_scene.new() 
		add_child(fight_controller)
		fight_controller.connect("NewFightMotion",$Wu,"_on_FightController_NewFightMotion")
		fight_controller.init_behaviour_tree(self,$Wu.get_behavior_tree())
		fight_controller.call_deferred('active_tree')
		
		if camp == Tool.CampEnum.Bad:
			#设置武器碰撞检测层
			sprite_animation.weapon_box.collision_layer =	 0b0100
			sprite_animation.weapon_box.collision_mask = 	 0b0010
			sprite_animation.hurt_box.collision_layer =  	0b1000
			sprite_animation.hurt_box.collision_mask =	    0b0001
		elif camp == Tool.CampEnum.Good:
			#设置武器碰撞检测层
			sprite_animation.weapon_box.collision_layer = 0b0001
			sprite_animation.weapon_box.collision_mask =  0b1000
			sprite_animation.hurt_box.collision_layer =   0b0010
			sprite_animation.hurt_box.collision_mask = 0b0100
			
	#初始化 武学
#	$Wu.wuxue.animation_player.root_node = $Wu.wuxue.animation_player.get_path_to(sprite_animation.get_node("hip"))
	
	#TODO 根据配置设置角色形象
#	sprite_animation.set_sprite_texture($Wu.get_texture())
	sprite_animation.choose_wuxue_animation_and_gear($Wu.wuxue)
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

func set_engaged(e):
	is_engaged = e
	if e:
		self.is_prepared = true

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

#是否处于准备状态
var is_prepared = false setget set_prepared

func set_prepared(p):
	
	if p and not is_prepared:
		#是从false 变化到 true的情况； 出剑
		var base = FightBaseActionDataSource.get_by_base_id(Tool.FightMotion.Prepared) as BaseAction
		if base != null :
			var action = Tool.getPollObject(ActionInfo,[base.id, OS.get_ticks_msec(), [Vector2.ZERO], base.get_duration(), ActionInfo.EXEMOD_GENEROUS, false, true])
			actionMng.regist_actioninfo(action)
	elif is_prepared and not p:
		#是从true 变为false；收剑
		var base = FightBaseActionDataSource.get_by_base_id(Tool.FightMotion.Unprepared) as BaseAction
		if base != null :
			var action = Tool.getPollObject(ActionInfo,[base.id, OS.get_ticks_msec(), [Vector2.ZERO], base.get_duration(), ActionInfo.EXEMOD_GENEROUS, false, true])
			actionMng.regist_actioninfo(action)
		pass
	
	is_prepared = p 
	if p:
		update_prepared_timer()
#计算prepared状态的timer
onready var _unpreparing_timer = $Timer

func update_prepared_timer():
	_unpreparing_timer.start(1)
	
	while true:
		var func_return = yield(_unpreparing_timer,"timeout")
		if is_engaged:
			_unpreparing_timer.start(1)
		else:
			self.is_prepared = false
			break
	
export(float) var impact_strength=0;

#当前角色朝向
func is_face_left():
	return fightKinematicMovableObj.charactor_face_direction.x<0

var prv_face_direction = Vector2.ZERO

var prv_animin =""

func get_animation_tree():
	return $SpriteAnimation.get_coresponding_animation_tree()
	pass

func _on_FightActionMng_ActionStart(action:ActionInfo):
	
	if action==null:
		push_error("actioninfo is null.")
		return 
	
	var base =FightBaseActionDataSource.get_by_base_id(action.base_action as int) as BaseAction
	
	if base == null:
		return
	
	#动画播放时长
	var time = base.duration
	if time<=0 || time ==null:
		time=1
		
	if action.base_action ==Tool.FightMotion.Attack:
		sprite_animation.weapon_box.monitoring = true
		sprite_animation.weapon_box.monitorable = true
		
		if is_prepared == false:
			self.is_prepared = true
		pass
	
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
	
	if action.base_action ==Tool.FightMotion.Prepared:
		
#		yield(sprite_animation.get_coresponding_animation_tree(),"State_Changed")
		sprite_animation.set_state(StandarCharactor.CharactorState.Engaged)
		pass

func test_dead_motion():
	
	var tween = $Tween
	tween.interpolate_property(self,"position",position,position+Vector2(0,50),1,Tween.TRANS_LINEAR,Tween.EASE_IN)
	tween.start()
	yield(tween,"tween_completed")
	queue_free()
	pass		


#movableobj 状态变化信号
func _on_FightKinematicMovableObj_State_Changed(state):
	
	if (state ==FightKinematicMovableObj.ActionState.Idle or state ==FightKinematicMovableObj.ActionState.Hanging ) and actionMng.is_connected("ActionProcess",fightKinematicMovableObj,"_on_FightActionMng_ActionProcess") :
		#在IDLE 的时候检测是否监听actionProcess事件并且取消监听	
		actionMng.call_deferred("disconnect","ActionProcess",fightKinematicMovableObj,"_on_FightActionMng_ActionProcess")
#		actionMng.disconnect("ActionProcess",fightKinematicMovableObj,"_on_FightActionMng_ActionProcess")
	elif state == FightKinematicMovableObj.ActionState.JumpUp or state == FightKinematicMovableObj.ActionState.JumpDown or  state == FightKinematicMovableObj.ActionState.Climb or state ==FightKinematicMovableObj.ActionState.HangingClimb :
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
			if collision_mask != 0b0000_0000_0000_0000_0000_0000_0111_0000 :
	#			set_deferred("collisaion_mask", 0b0000_0000_0000_0000_0000_0000_0001_0000)
				collision_mask = 0b0000_0000_0000_0000_0000_0000_0111_0000
		
	else:
		if not is_on_platform:
			#检测platform 层碰撞
	#		set_deferred("collision_mask", 0b0000_0000_0000_0000_0000_0000_1001_0000)
			if collision_mask != 0b0000_0000_0000_0000_0000_0000_1111_0000 :
	#			set_deferred("collisaion_mask", 0b0000_0000_0000_0000_0000_0000_1001_0000)
				collision_mask = 0b0000_0000_0000_0000_0000_0000_1111_0000
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


func _on_SpriteAnimation_Hit(areas):
	pass # Replace with function body.


func _on_SpriteAnimation_Hurt(area):
	if block_value>0:
		block_value = block_value -1
		print("Im hurt")
	elif health_point >0:
		health_point = health_point -1
		if health_point<=0:
			isDead  = true
			test_dead_motion()
			print("Im dead")
