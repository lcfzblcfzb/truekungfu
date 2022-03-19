class_name PlatformGestureActionController
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
var jisu

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

#记录方向按键的状态 up:10 down:01 left:10 right:01
var _horizon_key_pressed  =0
var _vertical_key_pressed =0

#水平方向上最后按下的
var _horizon_last_pressed = 0
#垂直方向上最后按下的
var _vetical_last_pressed =0

#重攻击生效范围半径.
var heavyAttackRadiusLimit = 5

func _ready():
	if jisu==null:
		jisu = get_node(fight_component)
	

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
	R =Glob.normalizeAngle(R)
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
		var base = FightBaseActionDataSource.get_by_id(k) as BaseAction
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
	
	var pool = Glob.PoolDict.get(ActionInfo) as ObjPool
	
	var result = []
	
	for k in action_dict:
		var item  = action_dict.get(k)
		if item:
			var act = pool.instance([k,item.get('create_time') if item.get('create_time') !=null else OS.get_ticks_msec() ,item.get('param'),item.get('duration'),item.get('exemod')])
			result.append(act)
		pass	
	return result


var _prv_input =null
func _physics_process(delta):
	
	#根据按键重新构造input_vector
	var input_vector = _gen_input_vector_by_bincode()
	var is_echo =false
	
	if _prv_input!=null and _prv_input== input_vector:
		is_echo = true
		
	if _prv_input!=null and _prv_input ==Vector2.ZERO and _prv_input== input_vector:
		pass
	else:
		var newActionEvent = Glob.getPollObject(MoveEvent,[input_vector,is_echo,Input.is_action_just_pressed("jump")])	
		emit_signal("NewFightMotion",newActionEvent)	
		_prv_input = input_vector


#通过二进制生成input_vector
func _gen_input_vector_by_bincode():
	#根据按键重新构造input_vector
	var input_vector = Vector2.ZERO;
	if  _vertical_key_pressed & 0b10 == 0b10:
		input_vector.y = -1
	elif  _vertical_key_pressed & 0b01 == 0b01:
		input_vector.y =1
	
	if _horizon_key_pressed == 0b10:
		input_vector.x = -1
	elif _horizon_key_pressed == 0b01:
		input_vector.x = 1
	elif _horizon_key_pressed == 0b11:
		if _horizon_last_pressed == 0b10:
			input_vector.x = -1
		elif _horizon_last_pressed == 0b01:
			input_vector.x = 1
	
	return input_vector
	


func _input(event):
	
	if event.is_action_pressed("attack"):
		attack_pressed = true
		var newActionEvent = Glob.getPollObject(NewActionEvent,[Glob.WuMotion.Attack,attack_begin_time,OS.get_ticks_msec()])
		emit_signal("NewFightMotion",newActionEvent)
	if event.is_action_pressed("prepared"):
		var newActionEvent = Glob.getPollObject(NewActionEvent,[Glob.WuMotion.Prepared,attack_begin_time,OS.get_ticks_msec()])
		emit_signal("NewFightMotion",newActionEvent)
	if event.is_action_pressed("switch"):
		
		var newActionEvent = Glob.getPollObject(NewActionEvent,[Glob.WuMotion.Switch,attack_begin_time,OS.get_ticks_msec()])
		emit_signal("NewFightMotion",newActionEvent)
	
	var is_action =event.is_action("ui_right")
	#以上下左右的顺序 ，垂直方向上下对应用 10 和01  ；水平上左右对应用 10和01 表示
	if event.is_action_pressed("up"):
		_vertical_key_pressed =_vertical_key_pressed | 0b10
	if event.is_action_pressed("down"):
		_vertical_key_pressed =_vertical_key_pressed | 0b01
	
	if event.is_action_released("up") :
		_vertical_key_pressed = _vertical_key_pressed & 0b00
	elif event.is_action_released("down") :
		_vertical_key_pressed = _vertical_key_pressed & 0b00
	
	if event.is_action_pressed("left"):
		_horizon_key_pressed = _horizon_key_pressed | 0b10
		_horizon_last_pressed = 0b10
	elif event.is_action_pressed("right"):
		_horizon_key_pressed = _horizon_key_pressed | 0b01
		_horizon_last_pressed = 0b01
		
	if event.is_action_released("left") :
		_horizon_key_pressed = _horizon_key_pressed & 0b01 
		
	elif event.is_action_released("right") :
		_horizon_key_pressed = _horizon_key_pressed & 0b10 
	
	if event.is_action_pressed("jump") :
		var input_vector = _gen_input_vector_by_bincode()
		var newActionEvent = Glob.getPollObject(MoveEvent,[input_vector,false,true])	
		emit_signal("NewFightMotion",newActionEvent)	
	
	if event.is_action_pressed("cancel"):

#		jisu.state = FightKinematicMovableObj.ActionState.Idle
#		hide_all()	
		is_cancel = true	
		#移动
		#超乱
		#只有在非 攻击（ATTACK）状态下 才进行移动/ 奔跑切换
#		if event.is_action("ui_right")||event.is_action("ui_left")||event.is_action("ui_up")||event.is_action("ui_down"):
			
#			var input_vector = Vector2.ZERO;
#			input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left");
#			input_vector.y = Input.get_action_strength("ui_down")-Input.get_action_strength("ui_up");
#
#			input_vector =  input_vector.normalized()
#			print(event.is_echo())
#			var newActionEvent = Glob.getPollObject(MoveEvent,[input_vector,event.is_echo()])
#			emit_signal("NewFightMotion",newActionEvent)	
#
#			if event.is_action_pressed("cancel"):
#
#				jisu.state = FightKinematicMovableObj.ActionState.Idle
#				hide_all()	
#				is_cancel = true	
		
	if(event is InputEventMouseMotion):
		#relativePos = event.relative;
		mouseMovingPos = event.global_position
		var screenPos
		
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
		
func get_moving_vector()->Vector2:
	return _gen_input_vector_by_bincode()

func _on_Timer_timeout():
#	show_heavy_attack_indicator()
	var motionEvent =Glob.getPollObject(NewActionEvent,[Glob.WuMotion.Holding,OS.get_ticks_msec(),OS.get_ticks_msec()])
	emit_signal("NewFightMotion",motionEvent)
#	regist_action(Glob.FightMotion.Holding,-1,ActionInfo.EXEMOD_NEWEST)
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
	
	

