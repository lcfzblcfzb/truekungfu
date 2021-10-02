extends Node2D

const MaxAngleSpeed  = 500

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
#重攻击时间阈值.ms
var heavyAttackThreshold = 300
#重攻击生效范围半径.
var heavyAttackRadiusLimit = 5

#位置命名
enum PositionName{
	
	UP,#上
	Mid,#中
	Bot#下
	
}

func _ready():
	if(!jisu):
		jisu = get_parent()
		
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
			hide_all()
			$Timer.stop()
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
			
			if OS.get_ticks_msec()<=attack_begin_time+heavyAttackThreshold:
				#轻攻击
				#攻击 调用
				
				if R>=0&&R<=attackUpLimit:
					#attack up
					pass
				elif R>attackUpLimit && R<=attackMidLimit:
					#attack mid
					pass
				elif R <=attackBotLimit:
					#attack bot
					pass
				else:
					
					#defend todo
					pass
			else:
				#蓄力重攻击
				
				if moving_position_array.size()<=0:
					#nothing happen
					return
				elif moving_position_array.size()==1:
					var pos = moving_position_array.pop_back()
					match pos:
						PositionName.UP:
							#heavy_attack_up
							pass
						PositionName.Mid:
							#heavy_attack_mid
							pass
						PositionName.Bot:
							#heavy_attack_bot
							pass
				else:
					var startPos = moving_position_array.pop_front()
					var endPos = moving_position_array.pop_back()
					
					if startPos==PositionName.UP:
						if endPos==PositionName.UP:
							#heavy_attack_up:  h_a_u
							pass
						elif endPos==PositionName.Mid:
							#h_a_u2m
							pass
						elif endPos==PositionName.Bot:
							#h_a_u2b
							pass
					elif startPos==PositionName.Mid:
					
						if endPos==PositionName.UP:
							#h_a_m2u
							pass
						elif endPos==PositionName.Mid:
							#h_a_m
							pass
						elif endPos==PositionName.Bot:
							#h_a_m2b
							pass
							
					elif startPos ==PositionName.Bot:
						if endPos==PositionName.UP:
							#h_a_b2u
							pass
						elif endPos==PositionName.Mid:
							#h_a_b2m
							pass
						elif endPos==PositionName.Bot:
							#h_a_b
							pass
					else:
						#无效的指令了
						pass
				
				pass
			
			onEndPosChange()
		
		if event.is_action_pressed("cancel"):
			hide_all()	
		
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
				if R>=0&&R<=attackUpLimit:
					#attack up
					if prv ==PositionName.UP:
						return
					else:
						moving_position_array.append(PositionName.UP)
				elif R>attackUpLimit && R<=attackMidLimit:
					#attack mid
					if prv ==PositionName.Mid:
						return
					else:
						moving_position_array.append(PositionName.Mid)
				elif R <=attackBotLimit:
					#attack bot
					if prv ==PositionName.Bot:
						return
					else:
						moving_position_array.append(PositionName.Bot)
				
			else:
				if R>=0&&R<=attackUpLimit:
					#attack up
					moving_position_array.append(PositionName.UP)
				elif R>attackUpLimit && R<=attackMidLimit:
					#attack mid
					moving_position_array.append(PositionName.Mid)
				elif R <=attackBotLimit:
					#attack bot
					moving_position_array.append(PositionName.Bot)
			pass
		
		onMouseMovingPosChange()
		
func onAttackPosChange():
	pass
	
func onEndPosChange():
	pass

func onMouseMovingPosChange():
	pass


func _on_Timer_timeout():
	show_heavy_attack_indicator()
