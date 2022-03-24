extends BasePlatformerRole

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

#已经学会的 wuxue
export (Array,Glob.WuxueEnum) var _learned_wuxue:Array=[Glob.WuxueEnum.Fist]

#可选角色形象
export (Glob.CharactorEnum) var chosed_characor = Glob.CharactorEnum.Daoshi

#已装备的 道具
# slot->[ baseGear ]
var _equiped_gears_dict = {}
#使用中的weapon
var weapon_onuse :Weapon

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
	#选择队应角色形象
	sprite_animation.choose_charactor(chosed_characor)	
	#所有角色有一个默认的weapon-->fist
	equip_gear(Glob.GearEnum.Fist)
	#TODO 装备物品  测试用
	equip_gear(Glob.GearEnum.DuanJian)
	#用特定武学 选择一件武器
	choose_weapon_using_wuxue(0,Glob.WuxueEnum.Fist)
	
	#初始状态检测
	#TODO 可以指定初始状态
	if not is_on_floor():
		fightKinematicMovableObj.state = FightKinematicMovableObj.ActionState.JumpDown
	
	$Energy.set_max_value(block_value)
	$Energy.update_value(block_value)
	
	UiManager.regist_none_ovelap_UI($Energy.get_texture_progress())
	pass 

#初始化 武学
func init_wuxue(_wuxue_list:Array):
	learn_wuxue(_wuxue_list)

#学习 wuxue
func learn_wuxue(_wuxue_list:Array):
	for _wuxue in _wuxue_list:
		#去重复
		if _learned_wuxue.has(_wuxue):
			continue
		_learned_wuxue.append(_wuxue)	

#通过weapon type 获得适配的 学会的wuxue 
func get_learned_wuxue_by_weapon_type(type):
	var result =[]
	for _wuxue in _learned_wuxue:
		var _base_wuxue = BaseWuxueDmg.get_by_id(_wuxue) as BaseWuxue
		if _base_wuxue and _base_wuxue.weapon_type.has(type):
			result.append(_base_wuxue)
	
	return result

#初始化武器
#base_weapon_id :Glob.GearEnum
func init_weapon(base_weapon_id):
	
	pass
	
#装备武器
func equip_weapon(base_weapon):
	
	var base_weapon_obj:BaseWeapon
	if base_weapon is BaseWeapon:
		base_weapon_obj = base_weapon
	elif base_weapon is int:
		base_weapon_obj = BaseWeaponDmg.get_by_id(base_weapon) as BaseWeapon
	
	if base_weapon_obj:
		
		if base_weapon.scene_path:
			var weapon_derived = load(base_weapon.scene_path).instance()
		else:
			var weapon_derived = load("res://Game/Gear/Weapon/WeaponDerived.tscn").instance() as Node
			var proto = BaseWeaponDmg.weapontype2prototype[base_weapon_obj.weaponType]
			weapon_derived.add_child(proto)

var weapon_in_use:Weapon

#选择武器使用
func choose_weapon_using_wuxue(id,wuxue):
	#武器 的 外形 在此初始化
	var weapon = _equiped_gears_dict.get(Glob.GearSlot.Weapon)[id] as Weapon
	
	var weapon_type = weapon.get_base_weapon().weaponType
	
	if not _learned_wuxue.has(wuxue):
		push_error("dont have leanrned wuxue to use")
		return
	weapon_in_use = weapon
	_set_weapon_active(weapon)
	wu.switch_wu(wuxue)
	
	#选择符合的动画
	sprite_animation.choose_wuxue_animation($Wu.wuxue)

#激活一个武器
func _set_weapon_active(weapon):
	
	for _wp in _equiped_gears_dict.get(Glob.GearSlot.Weapon):
		if _wp != weapon:
			_wp.active = false
	
	weapon.active =true
	
#装备道具
func equip_gear(base_gear_id):
	var base_gear = BaseGearDmg.get_by_id(base_gear_id) as BaseGear
	var _gear = load(base_gear.scene_path).instance() as Gear
	
	if base_gear.script_path:
		var script =load(base_gear.script_path)
		print(script)
		_gear.set_script(script)
	_add_to_gear_dict(_gear,base_gear)
	
#向gear dict 添加装备的工具方法
func _add_to_gear_dict(_gear:Gear,base_gear:BaseGear):
	
	var slot =  base_gear.slot
	
	if _equiped_gears_dict.has(slot):
		_equiped_gears_dict.get(slot).append(_gear)
	else:
		_equiped_gears_dict[slot]=[_gear]
	
	sprite_animation.get_standar_charactor().add_gear(_gear)
	
	_gear.init(base_gear,self)
	_gear.on_add_to_charactor()

func _remove_from_gear_dict(_gear:Gear):
	
	var slot =  _gear.get_base_gear().slot
	
	if _equiped_gears_dict.has(slot):
		_equiped_gears_dict.get(slot).erase(_gear)
		
	sprite_animation.get_standar_charactor().remove_gear(_gear)
	
	_gear.on_remove_from_charactor()
	
#func test_switch():
#
#	var gongfu =[Glob.WuxueEnum.Fist,Glob.WuxueEnum.Sword]
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
	var oppose_array = RoleMng.findOpposeMember(camp)
	if oppose_array.size()>0:
		var oppo = oppose_array[0] as BaseRole
		
		if oppo.global_position.distance_to(global_position) < 200:
			is_engaged = true
		else:
			is_engaged = false
	else:
		is_engaged = false

#切换武器
#wuxue: Glob.WuxueEnum.Fist
func switch_weapon(index,wuxue):
	
	choose_weapon_using_wuxue(index,wuxue)
#	wu.switch_wu(wuxue)
#	sprite_animation.choose_wuxue_animation_and_gear(wu.wuxue)

#是否处于准备状态
var is_prepared = false setget _set_prepared

func _set_prepared(p):
	
	if p and not is_prepared:
		#是从false 变化到 true的情况； 出剑
		var base = FightBaseActionDataSource.get_by_id(Glob.FightMotion.Prepared) as BaseAction
		if base != null :
			var action = Glob.getPollObject(ActionInfo,[base.id, OS.get_ticks_msec(), [Vector2.ZERO], base.get_duration(), ActionInfo.EXEMOD_GENEROUS, false, true])
			actionMng.regist_actioninfo(action)
	elif is_prepared and not p:
		#是从true 变为false；收剑
		var base = FightBaseActionDataSource.get_by_id(Glob.FightMotion.Unprepared) as BaseAction
		if base != null :
			var action = Glob.getPollObject(ActionInfo,[base.id, OS.get_ticks_msec(), [Vector2.ZERO], base.get_duration(), ActionInfo.EXEMOD_GENEROUS, false, true])
			actionMng.regist_actioninfo(action)
		pass
	
	is_prepared = p 
	if p:
		_update_prepared_timer()
#计算prepared状态的timer
onready var _unpreparing_timer = $Timer
#更新 PREPARED状态 计时器
func _update_prepared_timer():
	_unpreparing_timer.start(5)
	
	while true:
		var func_return = yield(_unpreparing_timer,"timeout")
		
		if is_engaged:
			_unpreparing_timer.start(5)
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
	
	var base =FightBaseActionDataSource.get_by_id(action.base_action as int) as BaseAction
	
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
	
	for _list in _equiped_gears_dict.values():
		
		for _gear  in _list:
			
			_gear.on_actioninfo_start(action)


func _on_FightActionMng_ActionFinish(action:ActionInfo):
		
	if action.base_action == Glob.FightMotion.HangingClimb:
		fightKinematicMovableObj.hanging_climb_over(corner_detector._last_hang_climb_end)
		corner_detector.set_deferred("enabled", true)
	
	if action.base_action ==Glob.FightMotion.Prepared:
		
		sprite_animation.set_state(StandarCharactor.CharactorState.Engaged)
		
	if action.base_action ==Glob.FightMotion.Unprepared:
		sprite_animation.set_state(StandarCharactor.CharactorState.Peace)
	
	for _list in _equiped_gears_dict.values():
		
		for _gear  in _list:
			
			_gear.on_actioninfo_end(action)
		
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
	var base = FightBaseActionDataSource.get_by_id(base_action) as BaseAction
	if base != null :
		if base_action == Glob.FightMotion.JumpUp: 
			var action = Glob.getPollObject(ActionInfo,[base_action, OS.get_ticks_msec(), [fight_controller.get_moving_vector()], base.get_duration(), ActionInfo.EXEMOD_SEQ, false, true])
			actionMng.regist_actioninfo(action)
		
		elif  base_action == Glob.FightMotion.JumpDown:
			
			var action = Glob.getPollObject(ActionInfo,[base_action, OS.get_ticks_msec(), [fight_controller.get_moving_vector()], base.get_duration(), ActionInfo.EXEMOD_GENEROUS, false, true])
			actionMng.regist_actioninfo(action)
			
		else:
			var action = Glob.getPollObject(ActionInfo,[base_action, OS.get_ticks_msec(), [fight_controller.get_moving_vector()], base.get_duration(), ActionInfo.EXEMOD_GENEROUS, false, true])
			actionMng.regist_actioninfo(action)


func _on_SpriteAnimation_Hit(areas):
	pass # Replace with function body.


func _on_SpriteAnimation_Hurt(area):
	if block_value>0:
		block_value = block_value -1
		$Energy.update_value(block_value)
		print("Im hurt")
	elif health_point >0:
		health_point = health_point -1
		if health_point<=0:
			isDead  = true
			test_dead_motion()
			print("Im dead")
