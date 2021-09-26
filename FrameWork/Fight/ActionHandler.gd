extends Node2D

#移动速度
export var moveSpeed = 100
#翻滚速度
export var rollSpeed = 5000
#翻滚持续时间.ms
export var rollDuration = 500
#翻滚CD
export var rollCD = 2000

#用来定义是否正处于某个action中，用来实现action之间的cd
#另一个优点是在一个action结束的时候快速切换用户正输入的action而不必等待下一帧。
var action_occupied = false
#当前输入的action指令
var input_action =Action.NOINPUT 

#上次切换的时间.ms
var _action_changed_time = 0
#角色的动作
var action = Action.IDLE setget set_action
func set_action(a):
	print("state",a)
#动作开始时间
var _roll_begin_time = 0
#动作结束时间
var _roll_end_time = 0
#下个可以翻滚的开始时间
var _next_available_time =0
#切换至roll
func _shift_roll():
	currentSpeed = rollSpeed
	_roll_begin_time = OS.get_ticks_msec()
	_roll_end_time = _roll_begin_time+rollDuration
	_next_available_time =_roll_end_time+rollCD
	
#当前移动速度。最后传给了controlableMovingObj
var currentSpeed = 0

enum Action{
	IDLE,ROLL,MOVE,ATTACK,BLOCK,NOINPUT
}
#接口方法
func getSpeed():
	return currentSpeed;
# Called when the node enters the scene tree for the first time.
func _ready():
	currentSpeed = moveSpeed
	pass # Replace with function body.
func processAction(delta):
	
	match(action):
		Action.ROLL:
			if _roll_end_time<=OS.get_ticks_msec():
				currentSpeed = moveSpeed
				action_occupied =false
				#设置成input_action
				if input_action != Action.NOINPUT:
					self.action = input_action
				else:
					self.action = Action.Idle
			
			pass
	
	pass


func _physics_process(delta):
	processAction(delta)
	pass
	
#玩家有新输入的时候，更新input_action
func update_input_action(a):
	input_action = a
	if !action_occupied:
		shift_action(a)
	
pass

#切换action
func shift_action(a):
	if can_shift(a):
		_action_changed_time = OS.get_ticks_msec()
		action = a
		print("state",a)
		match a:
			Action.ROLL:
				action_occupied = true
				_shift_roll()
				pass
	pass

#判断是否可以切换action。最主要的一个判断是CD
func can_shift(a):
	
	match a:
		Action.ROLL:
			
			print("next_avatime %10d,os_time %10d"%[_next_available_time,OS.get_ticks_msec()])
			var b= (_next_available_time<= OS.get_ticks_msec())
			if b:
				return true;
			else:
				print("roll in cd!")
				return false
			pass
	
	return true
	
func _input(event):
	if event.is_action_pressed("ui_select"):
		update_input_action(Action.ROLL)
	
	if event.is_action_released("ui_select"):
		update_input_action(Action.IDLE)
