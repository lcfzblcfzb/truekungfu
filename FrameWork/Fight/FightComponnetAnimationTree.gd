extends AnimationTree

const MOVE =0 
const HANGING =1
const CLIMB =2
const JUMP =3

const STATE_PREPARED =0
const STATE_UNPREPARED = 1

var TRANSITION_UNPREPARED = "parameters/unprepared_tran/current"
var TRANSITION_PREPARED = "parameters/prepared_tran/current"

var MOVE_BP ="parameters/move/blend_position"
var MOVE_PREPARED_BP ="parameters/move_prepared/blend_position"

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
		
#动作动作
func act(action:ActionInfo,timescale):
	var animation = action.get_base_action().get("animation_name")
	print("【action】: ",animation)
	if animation!=null:
		
		travelTo(action)
		#set_deferred("parameters/TimeScale/scale",5)
		var time = 1/timescale
		set_deferred("parameters/TimeScale/scale",time)
		
#封装的travel 方法;
func travelTo(action:ActionInfo):
	
	match action.base_action:
		Glob.FightMotion.Idle:
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
		
		Glob.FightMotion.Attack:
			set("parameters/attack_shot/active",true)
		
		Glob.FightMotion.Prepared:
			set("parameters/prepared_shot/active",true)
			set("parameters/state_tran/current",STATE_PREPARED)
			
		Glob.FightMotion.Unprepared:
			set("parameters/unprepared_shot/active",true)
			set("parameters/state_tran/current",STATE_UNPREPARED)
		
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
