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

#重攻击生效范围半径.
var heavyAttackRadiusLimit = 5

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


#
func _create_attack_action(action_list):
		
	var param_dict ={}
	
	for i in range(action_list.size()):
		var k = action_list[i]
		var base = FightBaseActionMng.get_by_base_id(k) as BaseAction
		if i <2:
			
			param_dict[k]={create_time=OS.get_ticks_msec(),
								duration=base.duration*1000,
								exemod =ActionInfo.EXEMOD_SEQ}
		else:
			param_dict[k]={create_time=OS.get_ticks_msec(),
								duration=base.duration*1000,
								exemod =ActionInfo.EXEMOD_GENEROUS}
	
	return _create_group_actions(param_dict)

func _create_group_actions(action_dict:Dictionary):
	
	if action_dict==null||action_dict.size()<3:
		return
	
	var pool = Tool.PoolDict.get(ActionInfo) as ObjPool
	
	var result = []
	
	for k in action_dict:
		var item  = action_dict.get(k)
		if item:
			var act = pool.instance([k,item.get('create_time') if item.get('create_time') !=null else OS.get_ticks_msec() ,item.get('param'),item.get('duration'),item.get('exemod')])
			result.append(act)
		pass	
	return result

func _input(event):
	
	if(event is InputEventMouse):
		
		if event.is_action_pressed("attack"):
			
			show_attack_indicator()
			attack_begin_time = OS.get_ticks_msec()
			attack_pressed = true
			moving_position_array.clear()
#			$Timer.start(heavyAttackThreshold/1000)
			attackPos =event.global_position;
		elif event.is_action_released("attack"):
			#停下计时器
#			$Timer.stop()
						
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
			
			var lastByte = _calc_position_byte_array(R)
			
			var global_id 
			
			var heavyAttackThreshold =500
			
			var wu_motion =Tool.WuMotion.Idle
			
			#蓄力重攻击
			
			if moving_position_array.size()<=0:
				#nothing happen
				wu_motion = Tool.WuMotion.Idle
				return
			elif moving_position_array.size()==1:
				var byte = moving_position_array.pop_back()
				if _is_attack_up_position(byte):
					#heavy_attack_up

					wu_motion = Tool.WuMotion.Attack_Up
					
				elif _is_attack_mid_position(byte):
					#heavy_attack_mid

					wu_motion = Tool.WuMotion.Attack_Mid
					
				elif _is_attack_bot_position(byte):
					#heavy_attack_bot
#						var a_list =_create_attack_action([Tool.FightMotion.Attack_Bot_Pre,Tool.FightMotion.Attack_Bot_In,Tool.FightMotion.Attack_Bot_After])
#						regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_GROUP_NEWEST)

					wu_motion = Tool.WuMotion.Attack_Bot
				elif _is_def_bot(byte):
				
#					var a_list =_create_attack_action([Tool.FightMotion.Def_Bot_Pre,Tool.FightMotion.Def_Bot_In,Tool.FightMotion.Def_Bot_After])
#					regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_GROUP_NEWEST)
					wu_motion = Tool.WuMotion.Defend_Bot

				elif _is_def_mid(byte):
					
					wu_motion = Tool.WuMotion.Defend_Mid
				elif _is_def_up(byte):
					
					wu_motion = Tool.WuMotion.Defend_Up
				else:
					wu_motion = Tool.WuMotion.Idle
					pass	
			else:
				var startPos = moving_position_array.pop_front()
				var backPos = moving_position_array.pop_back()
				var resultByte=  startPos + backPos
				if startPos>backPos:
					resultByte += from_byte;
				
				if _is_attack_up_position(resultByte):
					#heavy_attack_up
#						var a_list =_create_attack_action([Tool.FightMotion.HeavyAttack_U_Pre,Tool.FightMotion.HeavyAttack_U_In,Tool.FightMotion.HeavyAttack_U_After])
#
#						regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_GROUP_NEWEST)
					wu_motion = Tool.WuMotion.Attack_Up
					pass
				elif _is_attack_u2m(resultByte):
					#heavy_attack_up
#						var a_list =_create_attack_action([Tool.FightMotion.HeavyAttack_U2M_Pre,Tool.FightMotion.HeavyAttack_U2M_In,Tool.FightMotion.HeavyAttack_U2M_After])
#
#						regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_GROUP_NEWEST)
					
					wu_motion = Tool.WuMotion.Attack_U2M
					pass
				elif _is_attack_u2b(resultByte):
					#h_a_u2b
					
#						var a_list =_create_attack_action([Tool.FightMotion.HeavyAttack_U2B_Pre,Tool.FightMotion.HeavyAttack_U2B_In,Tool.FightMotion.HeavyAttack_U2B_After])
#
#						regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_GROUP_NEWEST)
					wu_motion = Tool.WuMotion.Attack_U2B
					pass
				elif _is_attack_m2u(resultByte):
					#h_a_m2u
					
#						var a_list =_create_attack_action([Tool.FightMotion.HeavyAttack_M2U_Pre,Tool.FightMotion.HeavyAttack_M2U_In,Tool.FightMotion.HeavyAttack_M2U_After])
#
#						regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_GROUP_NEWEST)
					
					wu_motion = Tool.WuMotion.Attack_M2U
					pass
				elif _is_attack_mid_position(resultByte):
					#h_a_m
					
#						var a_list =_create_attack_action([Tool.FightMotion.HeavyAttack_M_Pre,Tool.FightMotion.HeavyAttack_M_In,Tool.FightMotion.HeavyAttack_M_After])
#
#						regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_GROUP_NEWEST)

					wu_motion = Tool.WuMotion.Attack_Mid
					
					pass
				elif _is_attack_m2b(resultByte):
						#h_a_m2b
					
#						var a_list =_create_attack_action([Tool.FightMotion.HeavyAttack_M2B_After,Tool.FightMotion.HeavyAttack_M2B_In,Tool.FightMotion.HeavyAttack_M2B_After])
#
#						regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_GROUP_NEWEST)
					wu_motion = Tool.WuMotion.Attack_M2B
					pass
						
				elif _is_attack_b2u(resultByte):
						#h_a_b2u
											
#						var a_list =_create_attack_action([Tool.FightMotion.HeavyAttack_B2U_Pre,Tool.FightMotion.HeavyAttack_B2U_In,Tool.FightMotion.HeavyAttack_B2U_After])
#
#						regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_GROUP_NEWEST)
						
					wu_motion = Tool.WuMotion.Attack_B2U
					pass
				elif _is_attack_b2m(resultByte):
						#h_a_b2m
						
#						var a_list =_create_attack_action([Tool.FightMotion.HeavyAttack_B2M_Pre,Tool.FightMotion.HeavyAttack_B2M_In,Tool.FightMotion.HeavyAttack_B2M_After])
#
#						regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_GROUP_NEWEST)
					wu_motion = Tool.WuMotion.Attack_B2M
					pass
				elif _is_attack_bot_position(resultByte):
					#h_a_b
					
#						var a_list =_create_attack_action([Tool.FightMotion.HeavyAttack_B_Pre,Tool.FightMotion.HeavyAttack_B_In,Tool.FightMotion.HeavyAttack_B_After])
#
#						regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_GROUP_NEWEST)
					wu_motion = Tool.WuMotion.Attack_Bot
					pass
				else:
					#无效的指令了
#						regist_action(Tool.FightMotion.Idle)
#						jisu.change_movable_state(Vector2.ZERO,FightKinematicMovableObj.ActionState.Idle)
					wu_motion = Tool.WuMotion.Idle
					pass

			var newActionEvent = Tool.getPollObject(NewActionEvent,[wu_motion,attack_begin_time,OS.get_ticks_msec()])
			emit_signal("NewFightMotion",newActionEvent)
			
			
	#移动
	#超乱
	#只有在非 攻击（ATTACK）状态下 才进行移动/ 奔跑切换
	if event.is_action("ui_right")||event.is_action("ui_left")||event.is_action("ui_up")||event.is_action("ui_down"):
		
		var input_vector = Vector2.ZERO;
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left");
		input_vector.y = Input.get_action_strength("ui_down")-Input.get_action_strength("ui_up");
		
		input_vector =  input_vector.normalized()
		
		var newActionEvent = Tool.getPollObject(MoveEvent,[input_vector,event.is_echo()])
		emit_signal("NewFightMotion",newActionEvent)	
		
		if event.is_action_pressed("cancel"):

			jisu.state = FightKinematicMovableObj.ActionState.Idle
			hide_all()	
			is_cancel = true	
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
		
		

func _on_Timer_timeout():
	show_heavy_attack_indicator()
	var motionEvent =Tool.getPollObject(NewActionEvent,[Tool.WuMotion.Holding,OS.get_ticks_msec(),OS.get_ticks_msec()])
	emit_signal("NewFightMotion",motionEvent)
#	regist_action(Tool.FightMotion.Holding,-1,ActionInfo.EXEMOD_NEWEST)
#	jisu.change_movable_state(Vector2.ZERO,FightKinematicMovableObj.ActionState.Idle)

#位置命名
enum PositionName{
		
	UP_Right=0b100000,
	Mid_Right=0b010000,
	Bot_Right=0b001000,
	Bot_Left=0b000100,
	Mid_Left=0b000010,
	Up_Left=0b000001
	#左侧第一位代表方向。因 UP_Right+Mid_Right= 110000 缺少方向标识，所以定义一个方向位；
	#代表着 相加结果中的高位1 是朝向低位 1 的位置 或者相反；
	#若左侧第一位是1 代表 UP_right->Mid_right;若第一位为0 代表 Mid_right ->Up_right；
	U2M_Right =0b1110000,
	U2B_Right =0b1101000,
	M2U_Right =0b0110000,
	M2B_Right =0b1011000,
	B2U_Right =0b0101000,
	B2M_Right =0b0011000,
	
	U2M_Left =0b0000011,
	U2B_Left =0b0000101,
	M2U_Left =0b1000011,
	M2B_Left =0b0000110,
	B2U_Left =0b1000101,
	B2M_Left =0b1000110,
	
}
var from_byte = 0b1000000;
var to_byte = 0;

#鼠标当前处于 攻击-上 的位置
func _is_attack_up_position(byte)->bool:
	if is_on_left():
		return byte ^ PositionName.Up_Left ==0
		pass
	else:
		return byte ^ PositionName.UP_Right ==0
		pass
#鼠标当前处于 攻击-中 的位置	
func _is_attack_mid_position(byte)->bool:
	if is_on_left():
		return byte ^ PositionName.Mid_Left ==0
		pass
	else:
		return byte ^ PositionName.Mid_Right ==0
		pass
		
#鼠标当前处于 攻击-下 的位置
func _is_attack_bot_position(byte)->bool:
	if is_on_left():
		return byte ^ PositionName.Bot_Left ==0
		pass
	else:
		return byte ^ PositionName.Bot_Right ==0
		pass
	
func _is_attack_u2b(byte):
	if is_on_left():
		return byte ^ PositionName.U2B_Left ==0
		pass
	else:
		return byte ^ PositionName.U2B_Right ==0
		pass
	
func _is_attack_u2m(byte):
	if is_on_left():
		return byte ^ PositionName.U2M_Left ==0
		pass
	else:
		return byte ^ PositionName.U2M_Right ==0
		pass

func _is_attack_m2u(byte):
	if is_on_left():
		return byte ^ PositionName.M2U_Left ==0
		pass
	else:
		return byte ^ PositionName.M2U_Right ==0
		pass
	
func _is_attack_m2b(byte):
	if is_on_left():
		return byte ^ PositionName.M2B_Left ==0
		pass
	else:
		return byte ^ PositionName.M2B_Right ==0
		pass

func _is_attack_b2u(byte):
	if is_on_left():
		return byte ^ PositionName.B2U_Left ==0
		pass
	else:
		return byte ^ PositionName.B2U_Right ==0
		pass
	
func _is_attack_b2m(byte):
	if is_on_left():
		return byte ^ PositionName.B2M_Left ==0
		pass
	else:
		return byte ^ PositionName.B2M_Right ==0
		pass

func _is_def_mid(byte):
	
	if is_on_left():
		return byte ^ PositionName.Mid_Right ==0
		pass
	else:
		return byte ^ PositionName.Mid_Left ==0
		pass
	
	pass

func _is_def_up(byte):
	
	if is_on_left():
		return byte ^ PositionName.UP_Right == 0
	else:
		
		return byte ^ PositionName.Up_Left == 0
	pass
	

func _is_def_bot(byte):
	return byte ^ PositionName.Bot_Right == 0 if is_on_left() else byte^ PositionName.Bot_Left==0
	
	

