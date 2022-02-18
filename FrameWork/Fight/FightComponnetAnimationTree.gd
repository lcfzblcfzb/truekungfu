extends AnimationTree

const MOVE =0 
const HANGING =1
const CLIMB =2
const JUMP =3

var TRANSITION = "parameters/Transition/current"
var MOVE_BP ="parameters/move/blend_position"

var current_state = MOVE

func _ready():
#	yield(get_tree().create_timer(3),"timeout")
#	anim_player = textEdit_animator
	pass
	
var fight_action_control;

func set_fight_action_control(f):
	fight_action_control = get_node(f)

signal State_Changed;
#前一个路过的结点；
var prv_node =-1

func _process(delta):
	
	var current_node = get(TRANSITION)
	if current_node!=prv_node:
		emitSignal(current_node)
		prv_node = current_node
		
	pass
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
		Tool.FightMotion.Idle:
			set(TRANSITION,MOVE)
			set(MOVE_BP,Vector2.ZERO)
			
		Tool.FightMotion.Walk:
			set(TRANSITION,MOVE)
			set(MOVE_BP,Vector2.RIGHT)
		
		Tool.FightMotion.Hanging:
			set("parameters/hangingclimbshot/active",false)
			set(TRANSITION,HANGING)
		
		Tool.FightMotion.HangingClimb:
			set("parameters/hangingclimbshot/active",true)
			set(TRANSITION,HANGING)
		
		Tool.FightMotion.Attack:
			set("parameters/attack_shot/active",true)
		_:
			set(TRANSITION,MOVE)
			set(MOVE_BP,Vector2.ZERO)
	
#	state_machine_playback.travel(name)

#玩一下yield方法；
func emitSignal(toNode):
	print("current time scale",get("parameters/TimeScale/scale"))
	print("current node",toNode,OS.get_ticks_msec())
#	$RichTextLabel.text +=( "-->" + toNode as String)
	#sinal
	emit_signal("State_Changed",toNode)
