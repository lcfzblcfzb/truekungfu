extends BasePlatformerRole

class_name FightComponent_human
#是否是玩家操作的角色
export (bool) var is_player =false;
#已经学会的 wuxue
export (Array,Glob.WuxueEnum) var _learned_wuxue:Array=[]

#可选角色形象
export (Glob.CharactorEnum) var chosed_characor = Glob.CharactorEnum.Daoshi

#初始的装备
export (Array,Glob.GearEnum) var initial_gears =[]
#计算prepared状态的timer
onready var _unpreparing_timer = $Timer
onready var sprite_animation = $SpriteAnimation
onready var actionMng:FightActionMng = $FightActionMng
onready var wu = $Wu
onready var corner_detector = $CornerDetect
onready var attribute_mng = $AttributeMng
onready var fightKinematicMovableObj:FightKinematicMovableObj = $FightKinematicMovableObj

#动作控制器。是玩家输入或者是 AI 控制器
var fight_controller :BaseFightActionController
#背包
var inventory :Inventory

#控制器的预加载
var player_controller_scene =preload("res://FrameWork/Fight/Controller/PlatformGestureController.tscn")
var ai_controller_scene=preload("res://FrameWork/Fight/Controller/AiFightGestureController.gd")
#是否处于准备状态
var is_prepared = false setget _set_prepared

#是否进战斗了
var is_engaged=false

var stamina_value
var block_value=5
var health_point=1

#已装备的 道具
# slot->[ baseGear ]
var _equiped_gears_dict = {}
#使用中的weapon
var weapon_in_use:Weapon

#  可交互的东西
var _current_interacts=[]

func add_interactable(interactbal):
	
	if not _current_interacts.has(interactbal):
		_current_interacts.append(interactbal)
		sort_interactable()

func remove_interactable(interacbal):
	_current_interacts.erase(interacbal)

func sort_interactable():
	_current_interacts.sort_custom(self,"_interacble_sort")
#sorting method
func _interacble_sort(a,b):
	var to_a =abs(a.global_position.x - self.global_position.x)
	var to_b = abs(b.global_position.x - self.global_position.x)
	
	if to_a <= to_b:
		return true
	return false

func _input(event):
	if event.is_action_pressed("interact"):
		if _current_interacts.size()>0:
			var interact = _current_interacts[0]
			interact.pick(self)
	
	if event.is_action_pressed("inventory"):
		
		if is_player:
			GlobVar.user_interface.bind_inventory(inventory)
			GlobVar.user_interface.open_inventory()
		
#接口
#需要传入controlableMovingObj的速度参数
func getSpeed():
	return $ActionHandler.getSpeed()

#是否处于可攀爬位置
func is_at_hanging_corner()->bool:
	return corner_detector.is_colliding_with_corner()

#重载setter方法，在b= false 的时候，设置climb状态的结束
func set_climbing(b):
	.set_climbing(b)
	if not b:
		fightKinematicMovableObj.climb_over()

func has_enough_stamina(_needed=0):
	return stamina_value>_needed

func cost_stamina(_v):
	if has_enough_stamina(_v):
		stamina_value =clamp( stamina_value- _v ,0,attribute_mng.get_value(Glob.CharactorAttribute.Stamina))
		$Stamina.update_value(stamina_value)
		return true
	
	return false


func _physics_process(delta):
	
	if stamina_value < attribute_mng.get_value(Glob.CharactorAttribute.Stamina):
		
		stamina_value =clamp(stamina_value + attribute_mng.get_value(Glob.CharactorAttribute.StaminaRegen),0 , attribute_mng.get_value(Glob.CharactorAttribute.Stamina))
		$Stamina.update_value(stamina_value)
	
	if block_value < attribute_mng.get_value(Glob.CharactorAttribute.Block):
		
		block_value =clamp(block_value + attribute_mng.get_value(Glob.CharactorAttribute.BlockRegen),0,attribute_mng.get_value(Glob.CharactorAttribute.Block))
		$Block.update_value(block_value)

func _ready():
	
	if is_player:
		fight_controller = player_controller_scene.instance()
		fight_controller.jisu = self
		add_child(fight_controller)
		fight_controller.connect("NewFightMotion",$Wu,"_on_FightController_NewFightMotion")
		
		var camera = Camera2D.new()
		camera.zoom=Vector2(0.5,0.5)
		add_child(camera)
		camera.position = Vector2(0,-75)
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
	#初始化属性
	var baseCharactor = BaseStandarCharactorsDMG.get_by_id(chosed_characor)
	attribute_mng.init(baseCharactor)
	#默认学会一个武学
	init_wuxue([Glob.WuxueEnum.Sanjiaomao])
	#初始化 预设武器
	init_weapon()
	#用特定武学 选择一件武器
	choose_weapon_using_wuxue(0,Glob.WuxueEnum.Sanjiaomao)
	#初始化仓库
	if inventory ==null:
		inventory = Inventory.new()
		inventory.init(self,Glob.Player_Item_Slot_Number)
		
	#初始状态检测
	#TODO 可以指定初始状态
	if not is_on_floor():
		fightKinematicMovableObj.state = FightKinematicMovableObj.ActionState.JumpDown
	
	block_value = attribute_mng.get_value(Glob.CharactorAttribute.Block)
	stamina_value = attribute_mng.get_value(Glob.CharactorAttribute.Stamina)
	
	$Block.set_max_value(block_value)
	$Block.update_value(block_value)
	#UI 现实血量
	UiManager.regist_none_ovelap_UI($Block.get_texture_progress())
	
	$Stamina.set_max_value(attribute_mng.get_value(Glob.CharactorAttribute.Stamina))
	$Stamina.update_value(stamina_value)
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
func init_weapon():
	#所有角色有一个默认的weapon-->fist
	equip_gear(Glob.GearEnum.Fist)
	for gear in initial_gears:
		#装备物品
		equip_gear(gear)
		pass
	
#选择武器使用
func choose_weapon_using_wuxue(id,wuxue):
	#武器 的 外形 在此初始化
	var weapon = _equiped_gears_dict.get(Glob.GearSlot.Weapon)[id] as Weapon
	
	var weapon_type = weapon.get_base_weapon().weapon_type
	
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
#	var base_gear = BaseGearDmg.get_by_id(base_gear_id) as BaseGear
	
	var base_gear = GlobVar.BaseGearConfig.get_by_id(base_gear_id) as BaseGear
	var _gear = base_gear.scene.instance() as Gear
	#TODO 忘记是做啥用的了
	if base_gear.get("script_path")!=null:
		var script =load(base_gear.get("script_path"))
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
#	var gongfu =[Glob.WuxueEnum.Sanjiaomao,Glob.WuxueEnum.Taijijian]
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
#wuxue: Glob.WuxueEnum.Sanjiaomao
func switch_weapon(index,wuxue):
	
	choose_weapon_using_wuxue(index,wuxue)
#	wu.switch_wu(wuxue)
#	sprite_animation.choose_wuxue_animation_and_gear(wu.wuxue)


func _set_prepared(p):
	is_prepared = p 
	if p:
		sprite_animation.set_state(StandarCharactor.CharactorState.Engaged)
	else:
		sprite_animation.set_state(StandarCharactor.CharactorState.Peace)
	
	if p:
		_update_prepared_timer()

#更新 PREPARED状态 计时器
func _update_prepared_timer():
	refresh_unpreparing_timer()
	while true:
		var func_return = yield(_unpreparing_timer,"timeout")
		
		if is_engaged:
			refresh_unpreparing_timer()
		else:
			var base = FightBaseActionDataSource.get_by_id(Glob.FightMotion.Unprepared) as BaseAction
			if base != null :
				var action = GlobVar.getPollObject(ActionInfo,[base.id, OS.get_ticks_msec(), [Vector2.ZERO], base.get_duration(), ActionInfo.EXEMOD_GENEROUS, false, true])
				actionMng.regist_actioninfo(action)
			break

#设置_unpreparing_timer 的paused 状态
func set_paused_unpreparing_timer(_p=true):
	if _p:
		_unpreparing_timer.stop()
	else:
		_unpreparing_timer.start()

#刷新_unpreparing_timer 时间
func refresh_unpreparing_timer(sec=50):
	_unpreparing_timer.start(sec)
	
#当前角色朝向
func is_face_left():
	return fightKinematicMovableObj.charactor_face_direction.x<0

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
	
	print("action start time",OS.get_ticks_msec())
#	print("action frame:",$SpriteAnimation/Sprite.frame)
#	$FightAnimationTree.act(action,time)
	get_animation_tree().act(action)
	
	if action.base_action ==Glob.FightMotion.Blocking:
		sprite_animation.get_standar_charactor().get_hurt_box().counter_attack_type = Glob.CounterDamageType.Block
	elif  action.base_action ==Glob.FightMotion.Dodge:
		sprite_animation.get_standar_charactor().get_hurt_box().counter_attack_type = Glob.CounterDamageType.Dodge
	elif  action.base_action ==Glob.FightMotion.Rolling:
		sprite_animation.get_standar_charactor().get_hurt_box().counter_attack_type = Glob.CounterDamageType.Rolling
	
	for _list in _equiped_gears_dict.values():
		
		for _gear  in _list:
			
			_gear.on_actioninfo_start(action)

func _on_FightActionMng_ActionFinish(action:ActionInfo):
	
	if action.base_action == Glob.FightMotion.HangingClimb:
#		fightKinematicMovableObj.hanging_climb_over(corner_detector._last_hang_climb_end)
		corner_detector.set_deferred("enabled", true)
	
	if action.base_action ==Glob.FightMotion.Prepared:
		
		sprite_animation.set_state(StandarCharactor.CharactorState.Engaged)
		if not self.is_prepared:
			self.is_prepared = true
		
	if action.base_action ==Glob.FightMotion.Unprepared:
		sprite_animation.set_state(StandarCharactor.CharactorState.Peace)
		if self.is_prepared:
			self.is_prepared = false
	
#	if action.base_action == Glob.FightMotion.JumpDown:
#		var base = FightBaseActionDataSource.get_by_id(Glob.FightMotion.Idle)
#		var idle_action = GlobVar.getPollObject(ActionInfo,[Glob.FightMotion.Idle, OS.get_ticks_msec(), [fight_controller.get_moving_vector()], base.get_duration(), ActionInfo.EXEMOD_GENEROUS, false, true])
#		actionMng.regist_actioninfo(idle_action)
	
	if action.base_action ==Glob.FightMotion.Blocking:
		sprite_animation.get_standar_charactor().get_hurt_box().counter_attack_type = Glob.CounterDamageType.AutoBlock
	elif  action.base_action ==Glob.FightMotion.Dodge:
		sprite_animation.get_standar_charactor().get_hurt_box().counter_attack_type = Glob.CounterDamageType.AutoBlock
	elif  action.base_action ==Glob.FightMotion.Rolling:
		sprite_animation.get_standar_charactor().get_hurt_box().counter_attack_type = Glob.CounterDamageType.AutoBlock
	
	for _list in _equiped_gears_dict.values():
		
		for _gear  in _list:
			
			_gear.on_actioninfo_end(action)
	
	get_animation_tree().set_time_scale()
		
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
#		if base_action == Glob.FightMotion.JumpUp: 
#			var action = GlobVar.getPollObject(ActionInfo,[base_action, OS.get_ticks_msec(), [fight_controller.get_moving_vector()], base.get_duration(), ActionInfo.EXEMOD_SEQ, false, true])
#			actionMng.regist_actioninfo(action)
#
#		elif  base_action == Glob.FightMotion.JumpDown:
#
#			var action = GlobVar.getPollObject(ActionInfo,[base_action, OS.get_ticks_msec(), [fight_controller.get_moving_vector()], base.get_duration(), ActionInfo.EXEMOD_GENEROUS, false, true])
#			actionMng.regist_actioninfo(action)
#
#		else:
		var action = GlobVar.getPollObject(ActionInfo,[base_action, OS.get_ticks_msec(), [fight_controller.get_moving_vector()], base.get_duration(), ActionInfo.EXEMOD_GENEROUS, false, true])
		actionMng.regist_actioninfo(action)
		print("on movableobj state change"+base_action as String)

func _on_SpriteAnimation_Hit(areas):
	pass # Replace with function body.


func _on_SpriteAnimation_Hurt(area,dmg):
	if block_value>0:
		block_value = block_value -dmg
		$Block.update_value(block_value)
		print("Im hurt")
	elif health_point >0:
		health_point = health_point -1
		if health_point<=0:
			isDead  = true
			test_dead_motion()
			print("Im dead")
