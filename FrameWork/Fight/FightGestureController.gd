class_name FightActionController
extends BaseFightActionController

const MaxAngleSpeed  = 500

export var fight_component :NodePath

#攻击指示标（鼠标按下和抬起的位置）
var endPos = Vector2.ZERO
var attackPos = Vector2.ZERO
var mouseMovingPos = Vector2.ZERO
var attackDirection = 0

#指向endPos向量的弧度
var endPosRotation = Vector2.ZERO
#朝向鼠标的向量
var toMouseVector = Vector2.ZERO
var jisu:FightKinematicMovableObj

var state_controller:Fight_State_Controller

#开始的角度
var attackRadiusBias = PI*3/2
#逆角度 方便计算
var _attackRadiusBias_oppose = 2*PI - attackRadiusBias

#攻击（上中下路）的范围界定
var attackUpLimit = PI/3
var attackMidLimit = attackUpLimit +PI/3
var attackBotLimit = attackMidLimit +PI/3

var defBotLimit = attackBotLimit+PI/3
var defMidLimit = defBotLimit+PI/3
var defUpLimit = defMidLimit+PI/3

#重攻击时间阈值.ms
var heavyAttackThreshold = 300.0
#重攻击生效范围半径.
var heavyAttackRadiusLimit = 5
#两个walk 转化为run的最小间隔
var run_action_min_interval =300

func _ready():
	if(!jisu):
		jisu = get_node(fight_component)
	
func show_attack_indicator():
	
	$attack_indicator.visible = true
	$heavy_attack_indicator.visible = false
	pass

func show_heavy_attack_indicator():
	
	$attack_indicator.visible = false
	$heavy_attack_indicator.visible = true
	pass
	
func hide_all():
	$attack_indicator.visible = false
	$heavy_attack_indicator.visible = false

var attack_begin_time=0
#是否按下"attack"
var attack_pressed = false
#移动方向记录
var moving_position_array = []

#计算目标点 相对attackRadiusBias 坐标的弧度(单位弧度）
func _calc_angle2endpos_relativily(start,end)->float:
	#计算角度
	var r = end.angle_to_point(start)
	var R = r - attackRadiusBias
	R =Tool.normalizeAngle(R)
	return R

# 一共6位，每一位置代表的含义：  0:up_right; 0:mid_right; 0:bot_right; 0:bot_left; 0:mid_left; 0:up_left;
var position_array =0b000000;
#位置的2进制
func _calc_position_byte_array(R)->int:
	if R>0&&R<=attackUpLimit:
		return 0b100000;
	elif R>attackUpLimit && R<=attackMidLimit:
		return 0b010000;
	elif R <=attackBotLimit && R>attackMidLimit:
		return 0b001000;
	elif R<=defBotLimit &&R>attackBotLimit:
		return 0b000100;
	elif R<=defMidLimit && R>defBotLimit:
		return 0b000010;
	elif R<=defUpLimit && R>defMidLimit:
		return 0b000001;
	else:
		return 0b000000;

#开关。
var is_cancel = false


#攻击指示器出现在角色的左边or右边
func is_on_left()->bool:
	
	print("is face left", jisu.is_face_left())
	return jisu.is_face_left()



#注册一系列的动画
func regist_set_of_action(action):
	var global_id = next_group_id()
	match action:
		
		Tool.FightMotion.Attack_Up:
			regist_action(Tool.FightMotion.Attack_Up_Pre,state_controller.get("a_u_pre"),global_id,ActionInfo.EXEMOD_GROUP_NEWEST)
			regist_action(Tool.FightMotion.Attack_Up_In,state_controller.get("a_u_in"),global_id,ActionInfo.EXEMOD_GROUP_NEWEST)
			regist_action(Tool.FightMotion.Attack_Up_After,state_controller.get("a_u_after"),global_id,ActionInfo.EXEMOD_GENEROUS)
		Tool.FightMotion.Attack_Mid:
			regist_action(Tool.FightMotion.Attack_Mid_Pre,state_controller.get("a_m_pre"),global_id,ActionInfo.EXEMOD_GROUP_NEWEST)
			regist_action(Tool.FightMotion.Attack_Mid_In,state_controller.get("a_m_in"),global_id,ActionInfo.EXEMOD_GROUP_NEWEST)
			regist_action(Tool.FightMotion.Attack_Mid_After,state_controller.get("a_m_after"),global_id,ActionInfo.EXEMOD_GENEROUS)
		Tool.FightMotion.Attack_Bot:
			regist_action(Tool.FightMotion.Attack_Bot_Pre,state_controller.get("a_b_pre"),global_id,ActionInfo.EXEMOD_GROUP_NEWEST)
			regist_action(Tool.FightMotion.Attack_Bot_In,state_controller.get("a_b_in"),global_id,ActionInfo.EXEMOD_GROUP_NEWEST)
			regist_action(Tool.FightMotion.Attack_Bot_After,state_controller.get("a_b_after"),global_id,ActionInfo.EXEMOD_GENEROUS)
			
			pass
		
	pass
	
func _input(event):
	
	if(event is InputEventMouse):
		
		if event.is_action_pressed("attack"):
			
			show_attack_indicator()
			attack_begin_time = OS.get_ticks_msec()
			attack_pressed = true
			moving_position_array.clear()
			$Timer.start(heavyAttackThreshold/1000)
			attackPos =event.global_position;
			onAttackPosChange()
		elif event.is_action_released("attack"):
			#停下计时器
			$Timer.stop()
						
			if is_cancel:
				is_cancel = false;
				return
			
			hide_all()
			endPos = event.global_position
			attack_pressed=false
			
			#计算角度
			var R =_calc_angle2endpos_relativily(attackPos,endPos)
			#debug
			var rc =RayCast2D.new()
			add_child(rc)
			rc.global_position = attackPos
			rc.cast_to=endPos-attackPos
			rc.force_raycast_update()
			
			jisu.change_movable_state(Vector2.ZERO,FightKinematicMovableObj.ActionState.Attack)
			var global_id = next_group_id()
			if OS.get_ticks_msec()<=attack_begin_time+heavyAttackThreshold:
				#轻攻击
				#攻击 调用
				var byte = _calc_position_byte_array(R)
				if _is_attack_up_position(byte):
					#attack up
					#var name =Tool._map_action2animation(Tool.FightMotion.Attack_Up)
					#regist_action(Tool.FightMotion.Attack_Up,state_controller.get(Tool._map_action2animation(Tool.FightMotion.Attack_Up)),ActionInfo.EXEMOD_NEWEST)
					
					regist_action(Tool.FightMotion.Attack_Up_Pre,state_controller.get("a_u_pre"),ActionInfo.EXEMOD_GROUP_NEWEST,global_id)
					regist_action(Tool.FightMotion.Attack_Up_In,state_controller.get("a_u_in"),ActionInfo.EXEMOD_GROUP_NEWEST,global_id)
					regist_action(Tool.FightMotion.Attack_Up_After,state_controller.get("a_u_after"),ActionInfo.EXEMOD_GENEROUS,global_id)

					pass
				elif _is_attack_mid_position(byte):
					#attack mid
					
					regist_action(Tool.FightMotion.Attack_Mid_Pre,state_controller.get("a_m_pre"),ActionInfo.EXEMOD_GROUP_NEWEST,global_id)
					regist_action(Tool.FightMotion.Attack_Mid_In,state_controller.get("a_m_in"),ActionInfo.EXEMOD_GROUP_NEWEST,global_id)
					regist_action(Tool.FightMotion.Attack_Mid_After,state_controller.get("a_m_after"),ActionInfo.EXEMOD_GENEROUS,global_id)

					#regist_action(Tool.FightMotion.Attack_Mid)
					pass
				elif _is_attack_bot_position(byte):
					#attack bot
					
					regist_action(Tool.FightMotion.Attack_Bot_Pre,state_controller.get("a_b_pre"),global_id,ActionInfo.EXEMOD_GROUP_NEWEST)
					regist_action(Tool.FightMotion.Attack_Bot_In,state_controller.get("a_b_in"),global_id,ActionInfo.EXEMOD_GROUP_NEWEST)
					regist_action(Tool.FightMotion.Attack_Bot_After,state_controller.get("a_b_after"),global_id,ActionInfo.EXEMOD_GENEROUS)
			
					#regist_action(Tool.FightMotion.Attack_Bot)
					pass
				
				elif _is_def_bot(byte):
					regist_action(Tool.FightMotion.Def_Bot)
				elif _is_def_mid(byte):
					regist_action(Tool.FightMotion.Def_Mid)
				elif _is_def_up(byte):
					regist_action(Tool.FightMotion.Def_Up)
				else:
					regist_action(Tool.FightMotion.Idle)
					jisu.change_movable_state(Vector2.ZERO,FightKinematicMovableObj.ActionState.Idle)
					#defend todo
					pass
			else:
				#蓄力重攻击
				
				if moving_position_array.size()<=0:
					#nothing happen
					regist_action(Tool.FightMotion.Idle)
					jisu.change_movable_state(Vector2.ZERO,FightKinematicMovableObj.ActionState.Idle)
	
					return
				elif moving_position_array.size()==1:
					var byte = moving_position_array.pop_back()
					if _is_attack_up_position(byte):
						#heavy_attack_up
						regist_action(Tool.FightMotion.HeavyAttack_U)
						pass
					elif _is_attack_mid_position(byte):
						#heavy_attack_mid
						regist_action(Tool.FightMotion.HeavyAttack_M)
						pass
					elif _is_attack_bot_position(byte):
						#heavy_attack_bot
						regist_action(Tool.FightMotion.HeavyAttack_B)
						pass
				else:
					var startPos = moving_position_array.pop_front()
					var backPos = moving_position_array.pop_back()
					var resultByte=  startPos + backPos
					if startPos>backPos:
						resultByte += from_byte;
					
					if _is_attack_up_position(resultByte):
						
						#heavy_attack_up:  h_a_u
						regist_action(Tool.FightMotion.HeavyAttack_U)
						pass
					elif _is_attack_u2m(resultByte):
						#h_a_u2m
						regist_action(Tool.FightMotion.HeavyAttack_U2M)
						pass
					elif _is_attack_u2b(resultByte):
						#h_a_u2b
						regist_action(Tool.FightMotion.HeavyAttack_U2B)
						pass
					elif _is_attack_m2u(resultByte):
							#h_a_m2u
						regist_action(Tool.FightMotion.HeavyAttack_M2U)
						pass
					elif _is_attack_mid_position(resultByte):
							#h_a_m
						regist_action(Tool.FightMotion.HeavyAttack_M)
						pass
					elif _is_attack_m2b(resultByte):
							#h_a_m2b
						regist_action(Tool.FightMotion.HeavyAttack_M2B)
						pass
							
					elif _is_attack_b2u(resultByte):
							#h_a_b2u
						regist_action(Tool.FightMotion.HeavyAttack_B2U)
						pass
					elif _is_attack_b2m(resultByte):
							#h_a_b2m
						regist_action(Tool.FightMotion.HeavyAttack_B2M)
						pass
					elif _is_attack_bot_position(resultByte):
						#h_a_b
						regist_action(Tool.FightMotion.HeavyAttack_B)
						pass
					else:
						#无效的指令了
						regist_action(Tool.FightMotion.Idle)
						jisu.change_movable_state(Vector2.ZERO,FightKinematicMovableObj.ActionState.Idle)
	
						pass
				
				pass
			
			onEndPosChange()
			print("array:",_calc_position_byte_array(R))
		if event.is_action_pressed("cancel"):
			
			jisu.state = FightKinematicMovableObj.ActionState.Idle
			hide_all()	
			is_cancel = true
	#移动
	#超乱
	#只有在非 攻击（ATTACK）状态下 才进行移动/ 奔跑切换
	if event.is_action("ui_right")||event.is_action("ui_left")||event.is_action("ui_up")||event.is_action("ui_down"):
		
		var input_vector = Vector2.ZERO;
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left");
		input_vector.y = Input.get_action_strength("ui_down")-Input.get_action_strength("ui_up");
		
		input_vector =  input_vector.normalized()
		
		if  !event.is_echo():
			if input_vector != Vector2.ZERO:
				
				var is_run = is_trigger_run(input_vector)
				
				if is_run :
					
					var action = regist_action(Tool.FightMotion.Run,-1,ActionInfo.EXEMOD_GENEROUS,-1,[input_vector])
					jisu.change_movable_state(input_vector,FightKinematicMovableObj.ActionState.Run)
				else:
					regist_action(Tool.FightMotion.Walk,-1,ActionInfo.EXEMOD_GENEROUS,-1,[input_vector])

					jisu.change_movable_state(input_vector,FightKinematicMovableObj.ActionState.Walk)
			else:
				#if jisu.fightKinematicMovableObj.state!=FightKinematicMovableObj.ActionState.Attack:
					
					var lastMotion =action_array.back()
					
					if lastMotion.base_action != Tool.FightMotion.Run:
						regist_action(Tool.FightMotion.Idle,-1,ActionInfo.EXEMOD_GENEROUS,-1,[input_vector])

						#regist_action(Tool.FightMotion.Idle,input_vector)
						jisu.change_movable_state(input_vector,FightKinematicMovableObj.ActionState.Idle)
		else:
			
			var lastMotion =action_array.back()
			
			#这里是 攻击结束后，已经按下移动中的情况
			#if jisu.fightKinematicMovableObj.state == FightKinematicMovableObj.ActionState.Idle:
			if lastMotion.base_action ==Tool.FightMotion.Walk:
				regist_action(Tool.FightMotion.Walk,-1,ActionInfo.EXEMOD_GENEROUS,-1,[input_vector])
				#regist_action(Tool.FightMotion.Walk,-1,ActionInfo.EXEMOD_NEWEST,[input_vector])
				jisu.change_movable_state(input_vector,FightKinematicMovableObj.ActionState.Walk)
				
				pass
		
		#if jisu.state != FightKinematicMovableObj.ActionState.Attack:
		#	jisu.change_movable_state(input_vector,FightKinematicMovableObj.ActionState.Attack)
		#	pass	
	if(event is InputEventMouseMotion):
		#relativePos = event.relative;
		mouseMovingPos = event.global_position
		var screenPos
		
		screenPos =Tool.getCameraPosition(jisu)
		toMouseVector = (mouseMovingPos- screenPos).normalized()
		
		#攻击按下
		#才开始记录	
		#记录过程中所有的位置值
		#与上一个重复的就不记录了
		#最后只有第一个和最后一个有用。
		#如果开始到最后都没有移出 heavyAttackRadiusLimit 视作无效
		
		if attack_pressed:
			#计算角度
			var R =_calc_angle2endpos_relativily(attackPos,mouseMovingPos)
			#计算距离：
			#蓄力攻击只记录移动到limit之外的方向
			if mouseMovingPos.distance_squared_to(attackPos)<heavyAttackRadiusLimit:
				#不记录
				return;
			#
			if moving_position_array.size()>0:
				var prv = moving_position_array.back()
				var cur =_calc_position_byte_array(R);
				if prv !=cur:
					
					moving_position_array.append(cur)
					print(moving_position_array)
			else:
				moving_position_array.append(_calc_position_byte_array(R))
			pass
		
		onMouseMovingPosChange()
		
#判定是否是run
#进行一个run 判定
#两个间隔时间在 run_action_min_interval  的walk 指令触发成run
func is_trigger_run(input_vector)->bool:
	
	var index =action_array.size()
	
	while true:
		index=index-1
		if index<0:
			break
		var tmp = action_array[index] as ActionInfo
		#在极短时间内的几个run或者walk 都视为触发了run
		if  tmp.action_create_time+run_action_min_interval>= OS.get_ticks_msec():
			if (tmp.base_action ==Tool.FightMotion.Walk ||tmp.base_action ==Tool.FightMotion.Run) && tmp.param[0] == input_vector:
				return true
		else:
			return false;
		pass
	return false
	pass

func onAttackPosChange():
	pass
	
func onEndPosChange():
	pass

func onMouseMovingPosChange():
	pass

func _on_Timer_timeout():
	show_heavy_attack_indicator()
	regist_action(Tool.FightMotion.Holding,-1,ActionInfo.EXEMOD_NEWEST)
	jisu.change_movable_state(Vector2.ZERO,FightKinematicMovableObj.ActionState.Idle)
