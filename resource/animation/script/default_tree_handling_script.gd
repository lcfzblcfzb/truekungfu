#比较通用的 tree 处理，适配搭载 StandarCharactorTree 的 animation_tree 以及
#在其基础上拓展的（保留原有的节点结构和命名方式不变）

extends AnimationTree

const MOVE =0 
const HANGING =1
const CLIMB =2
const JUMP =3
const ROLLING =4

const STATE_PREPARED =0
const STATE_UNPREPARED = 1

var TRANSITION_UNPREPARED = "parameters/unprepared_tran/current"
var TRANSITION_PREPARED = "parameters/prepared_tran/current"

var MOVE_BP ="parameters/move/blend_position"
var MOVE_PREPARED_BP ="parameters/move_prepared/blend_position"

var prepared_jump_bt_tran ="parameters/prepared_jump_bt/Transition/current"
var unprepared_jump_bt_tran ="parameters/unpreapred_jump_bt/Transition/current"

var current_state = MOVE
	
var fight_action_control;

func set_fight_action_control(f):
	fight_action_control = get_node(f)

signal State_Changed;
#前一个路过的结点；
var prv_node =-1

func _process(delta):
	
	var current_node = get(TRANSITION_PREPARED)
	if current_node!=prv_node:
		emitSignal(current_node)
		prv_node = current_node

func set_time_scale(time_scale = 1):
	set_deferred("parameters/TimeScale/scale",time_scale)
		
#动作动作
func act(action:ActionInfo):
	var base_action = action.get_base_action()
	if base_action!=null:
		
		travelTo(action)
		
		#动画播放时长
		var time = action.action_duration_ms / 1000
		if time<=0 || time ==null:
			time=1
		#set_deferred("parameters/TimeScale/scale",5)
		time = 1/time
		
		if base_action.handle_type == Glob.ActionHandlingType.Action:
			set_deferred("parameters/action_tree/action_scale/scale",time)
		elif base_action.handle_type ==Glob.ActionHandlingType.Movement:
			set_deferred("parameters/TimeScale/scale",time)
		
#封装的travel 方法;
func travelTo(action:ActionInfo):
	
	match action.base_action:
		
		
		Glob.FightMotion.Dodge:
			set("parameters/action_shot/active",true)
			
			set("parameters/action_tree/dodge_tran/current",0)
			
			set("parameters/action_tree/action_tran/current",2)
		
		Glob.FightMotion.Idle:
			
			set("parameters/action_shot/active",false)
			set(TRANSITION_PREPARED,MOVE)
			set(TRANSITION_UNPREPARED,MOVE)
			set(MOVE_BP,Vector2.ZERO)
			set(MOVE_PREPARED_BP,Vector2.ZERO)
			
		Glob.FightMotion.Walk:
			set(TRANSITION_PREPARED,MOVE)
			set(TRANSITION_UNPREPARED,MOVE)
			set(MOVE_BP,Vector2.RIGHT)
			set(MOVE_PREPARED_BP,Vector2.RIGHT)
		
		Glob.FightMotion.Hanging:
			set("parameters/hangingclimbshot/active",false)
			set("parameters/hangingclimbshot_prepared/active",false)
			set(TRANSITION_PREPARED,HANGING)
			set(TRANSITION_UNPREPARED,HANGING)
		
		Glob.FightMotion.HangingClimb:
			set("parameters/hangingclimbshot_prepared/active",true)
			set("parameters/hangingclimbshot/active",true)
			set(TRANSITION_PREPARED,HANGING)
			set(TRANSITION_UNPREPARED,HANGING)
		
		Glob.FightMotion.Attack_Ci:
			set("parameters/action_shot/active",true)
			
			set("parameters/action_tree/attack_tran/current",0)
			
			set("parameters/action_tree/action_tran/current",0)
#			set("parameters/move_action_blend/blend_amount",1)
		
		Glob.FightMotion.Attack_Sao:
			
			set("parameters/action_shot/active",true)
			
			set("parameters/action_tree/attack_tran/current",4)
			
			set("parameters/action_tree/action_tran/current",0)
			
		Glob.FightMotion.Attack_Pi:
			
			set("parameters/action_shot/active",true)
			
			set("parameters/action_tree/attack_tran/current",2)
			
			set("parameters/action_tree/action_tran/current",0)
		
		
		Glob.FightMotion.Holding:
			
			set("parameters/action_shot/active",true)
			
			set("parameters/action_tree/holding_sm/current",0)
			
			set("parameters/action_tree/action_tran/current",3)
			
#			set("parameters/action_tran/current",0)
#			set("parameters/attack_bs/blend_position",Vector2(0,-1))
#			set("parameters/move_action_blend/blend_amount",1)
		Glob.FightMotion.Blocking:
			
			set("parameters/action_shot/active",true)
			
			set("parameters/action_tree/block_tran/current",1)
			
			set("parameters/action_tree/action_tran/current",1)
		Glob.FightMotion.Pre_Block:
			
			set("parameters/action_shot/active",true)
			
			set("parameters/action_tree/block_tran/current",0)
			
			set("parameters/action_tree/action_tran/current",1)	
		Glob.FightMotion.Post_Block:
			
			set("parameters/action_shot/active",true)
			
			set("parameters/action_tree/block_tran/current",2)
			
			set("parameters/action_tree/action_tran/current",1)	
		Glob.FightMotion.Canceled:
			
			set("parameters/action_shot/active",false)
			
			set("parameters/action_tree/action_tran/current",4)
#			set("parameters/action_tran/current",1)
#			set("parameters/block_bs/blend_position",Vector2(0,0))
#			set("parameters/move_action_blend/blend_amount",1)
		Glob.FightMotion.Rolling:
			set("parameters/rolling_shot/active",true)
		
		Glob.FightMotion.Prepared:
			set("parameters/prepared_shot/active",true)
			set("parameters/state_tran/current",STATE_PREPARED)
			
		Glob.FightMotion.Unprepared:
			set("parameters/unprepared_shot/active",true)
			set("parameters/state_tran/current",STATE_UNPREPARED)
		
		Glob.FightMotion.JumpUp:
			
			set(TRANSITION_PREPARED,JUMP)
			set(TRANSITION_UNPREPARED,JUMP)
			
			set(prepared_jump_bt_tran,0)
			set(unprepared_jump_bt_tran,0)
#			get(prepared_jump_playback).start("jumpup")
#			get(unprepared_jump_playback).start("jumpup")
		Glob.FightMotion.JumpRising:
			
			set(TRANSITION_PREPARED,JUMP)
			set(TRANSITION_UNPREPARED,JUMP)
			
			set(prepared_jump_bt_tran,1)
			set(unprepared_jump_bt_tran,1)
#			get(prepared_jump_playback).start("jump_rising")
#			get(unprepared_jump_playback).start("jump_rising")
			pass
		Glob.FightMotion.JumpFalling:
			
			set(TRANSITION_PREPARED,JUMP)
			set(TRANSITION_UNPREPARED,JUMP)
			
			set(prepared_jump_bt_tran,2)
			set(unprepared_jump_bt_tran,2)
#			get(prepared_jump_playback).start("jump_falling")
#			get(unprepared_jump_playback).start("jump_falling")
			pass
		Glob.FightMotion.JumpDown:
			
			set(TRANSITION_PREPARED,JUMP)
			set(TRANSITION_UNPREPARED,JUMP)
				
			set(prepared_jump_bt_tran,3)
			set(unprepared_jump_bt_tran,3)
#			get(prepared_jump_playback).start("jumpdown")
#			get(unprepared_jump_playback).start("jumpdown")
			pass
		_:
			set(TRANSITION_PREPARED,MOVE)
			set(TRANSITION_UNPREPARED,MOVE)
			set(MOVE_BP,Vector2.ZERO)
			set(MOVE_PREPARED_BP,Vector2.ZERO)
	
#	state_machine_playback.travel(name)

#玩一下yield方法；
func emitSignal(toNode):
	print("current time scale",get("parameters/TimeScale/scale"))
	print("current node",toNode,OS.get_ticks_msec())
#	$RichTextLabel.text +=( "-->" + toNode as String)
	#sinal
	emit_signal("State_Changed",toNode)
