class_name FightActionController
extends Node2D

const MaxAngleSpeed  = 500

export var fight_component :NodePath

signal NewFightMotion
#攻击指示标（鼠标按下和抬起的位置）
var endPos = Vector2.ZERO
var attackPos = Vector2.ZERO
var mouseMovingPos = Vector2.ZERO
var attackDirection = 0

#指向endPos向量的弧度
var endPosRotation = Vector2.ZERO
#朝向鼠标的向量
var toMouseVector = Vector2.ZERO
var jisu :FightComponent_human

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
var run_action_min_interval =200

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
	
	U2M_Left =0b1000011,
	U2B_Left =0b1000101,
	M2U_Left =0b0000110,
	M2B_Left =0b1000011,
	B2U_Left =0b0000101,
	B2M_Left =0b0000011,
	
}
var from_byte = 0b1000000;
var to_byte = 0;

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

#鼠标处于 防御-下 的位置
func _is_def_bot_position(R)->bool:
	return R<=defBotLimit &&R>attackBotLimit
#鼠标处于 防御-中 的位置
func _is_def_mid_position(R)->bool:
	return R<=defMidLimit && R>defBotLimit
#鼠标处于 防御-上 的位置
func _is_def_up_position(R)->bool:
	return R<=defUpLimit && R>defMidLimit

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
	
export var MAX_ACTION_ARRAY_SIZE =101	
#动作历史记录
var action_array = []
#旧数组数据
var old_array =[]
#对象池
var actionPool = ObjPool.new(ActionInfo)
#保持数组长度不超过 MAX_ACTION_ARRAY_SIZE 的长度
#缓存上一个数组的数据
func regist_action(a,param=null):
	#var action =ActionInfo.new(a,OS.get_ticks_msec(),param)
	var action =actionPool.instance([a,OS.get_ticks_msec(),param])
	if action_array.size() >= MAX_ACTION_ARRAY_SIZE:
		var last  = action_array.pop_back()
		if old_array.size()>0:
			for o in old_array:
				o.dead()
				
		old_array = action_array
		action_array = [last,action]
	else:		
		action_array.append(action)
		
func _input(event):
	
	if(event is InputEventMouse):
		
		if event.is_action_pressed("attack"):
			
			global_position = event.global_position;
			show_attack_indicator()
			attack_begin_time = OS.get_ticks_msec()
			attack_pressed = true
			moving_position_array.clear()
			print("startMs",OS.get_ticks_msec(),"suppose:",heavyAttackThreshold/1000)
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
	
			if OS.get_ticks_msec()<=attack_begin_time+heavyAttackThreshold:
				#轻攻击
				#攻击 调用
				var byte = _calc_position_byte_array(R)
				if _is_attack_up_position(byte):
					#attack up
					regist_action(FightComponent_human.FightMotion.Attack_Up)
					emit_signal("NewFightMotion",FightComponent_human.FightMotion.Attack_Up)
					pass
				elif _is_attack_mid_position(byte):
					#attack mid
					regist_action(FightComponent_human.FightMotion.Attack_Mid)
					emit_signal("NewFightMotion",FightComponent_human.FightMotion.Attack_Mid)
					pass
				elif _is_attack_bot_position(byte):
					#attack bot
					regist_action(FightComponent_human.FightMotion.Attack_Bot)
					emit_signal("NewFightMotion",FightComponent_human.FightMotion.Attack_Bot)
					pass
				else:
					regist_action(FightComponent_human.FightMotion.Idle)
					emit_signal("NewFightMotion",FightComponent_human.FightMotion.Idle)
					
					jisu.change_movable_state(Vector2.ZERO,FightKinematicMovableObj.ActionState.Idle)
					#defend todo
					pass
			else:
				#蓄力重攻击
				
				if moving_position_array.size()<=0:
					#nothing happen
					regist_action(FightComponent_human.FightMotion.Idle)
					emit_signal("NewFightMotion",FightComponent_human.FightMotion.Idle)
					jisu.change_movable_state(Vector2.ZERO,FightKinematicMovableObj.ActionState.Idle)
	
					return
				elif moving_position_array.size()==1:
					var byte = moving_position_array.pop_back()
					if _is_attack_up_position(byte):
						#heavy_attack_up
						regist_action(FightComponent_human.FightMotion.HeavyAttack_U)
						emit_signal("NewFightMotion",FightComponent_human.FightMotion.HeavyAttack_U)
						pass
					elif _is_attack_mid_position(byte):
						#heavy_attack_mid
						regist_action(FightComponent_human.FightMotion.HeavyAttack_M)
						emit_signal("NewFightMotion",FightComponent_human.FightMotion.HeavyAttack_M)
						pass
					elif _is_attack_bot_position(byte):
						#heavy_attack_bot
						regist_action(FightComponent_human.FightMotion.HeavyAttack_B)
						emit_signal("NewFightMotion",FightComponent_human.FightMotion.HeavyAttack_B)
						pass
				else:
					var startPos = moving_position_array.pop_front()
					var backPos = moving_position_array.pop_back()
					var resultByte=  startPos + backPos
					if startPos>backPos:
						resultByte += from_byte;
					
					if _is_attack_up_position(resultByte):
						
						#heavy_attack_up:  h_a_u
						regist_action(FightComponent_human.FightMotion.HeavyAttack_U)
						emit_signal("NewFightMotion",FightComponent_human.FightMotion.HeavyAttack_U)
						pass
					elif _is_attack_u2m(resultByte):
						#h_a_u2m
						regist_action(FightComponent_human.FightMotion.HeavyAttack_U2M)
						emit_signal("NewFightMotion",FightComponent_human.FightMotion.HeavyAttack_U2M)
						pass
					elif _is_attack_u2b(resultByte):
						#h_a_u2b
						regist_action(FightComponent_human.FightMotion.HeavyAttack_U2B)
						emit_signal("NewFightMotion",FightComponent_human.FightMotion.HeavyAttack_U2B)
						pass
					elif _is_attack_m2u(resultByte):
							#h_a_m2u
						regist_action(FightComponent_human.FightMotion.HeavyAttack_M2U)
						emit_signal("NewFightMotion",FightComponent_human.FightMotion.HeavyAttack_M2U)
						pass
					elif _is_attack_mid_position(resultByte):
							#h_a_m
						regist_action(FightComponent_human.FightMotion.HeavyAttack_M)
						emit_signal("NewFightMotion",FightComponent_human.FightMotion.HeavyAttack_M)
						pass
					elif _is_attack_m2b(resultByte):
							#h_a_m2b
						regist_action(FightComponent_human.FightMotion.HeavyAttack_M2B)
						emit_signal("NewFightMotion",FightComponent_human.FightMotion.HeavyAttack_M2B)
						pass
							
					elif _is_attack_b2u(resultByte):
							#h_a_b2u
						regist_action(FightComponent_human.FightMotion.HeavyAttack_B2U)
						emit_signal("NewFightMotion",FightComponent_human.FightMotion.HeavyAttack_B2U)
						pass
					elif _is_attack_b2m(resultByte):
							#h_a_b2m
						regist_action(FightComponent_human.FightMotion.HeavyAttack_B2M)
						emit_signal("NewFightMotion",FightComponent_human.FightMotion.HeavyAttack_B2M)
						pass
					elif _is_attack_bot_position(resultByte):
						#h_a_b
						regist_action(FightComponent_human.FightMotion.HeavyAttack_B)
						emit_signal("NewFightMotion",FightComponent_human.FightMotion.HeavyAttack_B)
						pass
					else:
						#无效的指令了
						regist_action(FightComponent_human.FightMotion.Idle)
						emit_signal("NewFightMotion",FightComponent_human.FightMotion.Idle)
						jisu.change_movable_state(Vector2.ZERO,FightKinematicMovableObj.ActionState.Idle)
	
						pass
				
				pass
			
			onEndPosChange()
			print("array:",_calc_position_byte_array(R))
		if event.is_action_pressed("cancel"):
			
			jisu.fightKinematicMovableObj.state = FightKinematicMovableObj.ActionState.Idle
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
		
		if jisu.fightKinematicMovableObj.state!=FightKinematicMovableObj.ActionState.Attack:
		
			if  !event.is_echo():
				if input_vector != Vector2.ZERO:
					
					var is_run = is_trigger_run(input_vector)
					
					if is_run :
						regist_action(FightComponent_human.FightMotion.Run,input_vector)
						emit_signal("NewFightMotion",FightComponent_human.FightMotion.Run)
						jisu.change_movable_state(input_vector,FightKinematicMovableObj.ActionState.Run)
					else:
						regist_action(FightComponent_human.FightMotion.Walk,input_vector)
						emit_signal("NewFightMotion",FightComponent_human.FightMotion.Walk)
						jisu.change_movable_state(input_vector,FightKinematicMovableObj.ActionState.Walk)
				else:
					if jisu.fightKinematicMovableObj.state!=FightKinematicMovableObj.ActionState.Attack:
						
						var lastMotion =action_array.back()
						
						if lastMotion.action_type != FightComponent_human.FightMotion.Run:
							
							regist_action(FightComponent_human.FightMotion.Idle,input_vector)
							emit_signal("NewFightMotion",FightComponent_human.FightMotion.Idle)
							jisu.change_movable_state(input_vector,FightKinematicMovableObj.ActionState.Idle)
			else:
				
				#这里是 攻击结束后，以前按下移动中的情况
				if jisu.fightKinematicMovableObj.state == FightKinematicMovableObj.ActionState.Idle:
					
					jisu.change_movable_state(input_vector,FightKinematicMovableObj.ActionState.Walk)
					
					regist_action(FightComponent_human.FightMotion.Walk,input_vector)
					emit_signal("NewFightMotion",FightComponent_human.FightMotion.Walk)
					pass
			
	if(event is InputEventMouseMotion):
		#relativePos = event.relative;
		mouseMovingPos = event.global_position
		var screenPos
		
		if jisu.get("sprite") != null:
			screenPos =Tool.getCameraPosition(jisu.sprite)
		else:
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
	
	var index = action_array.size()
	
	while true:
		index=index-1
		if index<0:
			break
		var tmp = action_array[index] as ActionInfo
		
		if tmp.action_begin+run_action_min_interval>= OS.get_ticks_msec():
			if tmp.action_type ==FightComponent_human.FightMotion.Walk && tmp.param == input_vector:
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
	jisu.change_movable_state(Vector2.ZERO,FightKinematicMovableObj.ActionState.Idle)
	print("endMs",OS.get_ticks_msec())
	show_heavy_attack_indicator()
	regist_action(FightComponent_human.FightMotion.Holding)
	emit_signal("NewFightMotion",FightComponent_human.FightMotion.Holding)

#action 信息
class ActionInfo :

	extends ObjPool.IPoolAble	
	func _init(pool,params).(pool):
		action_type=params[0]
		action_begin = params[1]
		param =params[2]
	pass
	
	var action_type;
	var action_begin;
	var param;#如果是 run/move 指令，保存方向向量
	
	func _clean():
		action_type=null
		action_begin=null
		param=null
		pass
