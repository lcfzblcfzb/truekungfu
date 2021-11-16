extends AnimationTree

var state_machine_playback = get("parameters/sm/playback")

#export (NodePath)var _fight_action_path setget set_fight_action_control
#
#export (NodePath) var textEdit_animator
#export (NodePath) var sword_animator
#
#func _ready():
#
#	yield(get_tree().create_timer(3),"timeout")
#	anim_player = textEdit_animator
#
#var fight_action_control;
#
#func set_fight_action_control(f):
#	fight_action_control = get_node(f)

signal State_Changed;
#前一个路过的结点；
var prv_node =""

func _process(delta):
	
	var current_node = state_machine_playback.get_current_node()
	if current_node!=prv_node:
		emitSignal(current_node)
		prv_node = current_node
		
	pass
#动作动作
func act(action:ActionInfo,timescale):
	var animation = action.get_base_action().get("animation_name")
	print("【action】: ",animation)
	if animation!=null:
		
		travelTo(animation)
		#set_deferred("parameters/TimeScale/scale",5)
		var time = 1/timescale
		print(time)
		set_deferred("parameters/TimeScale/scale",time)
		
#封装的travel 方法;
func travelTo(name):
	state_machine_playback.travel(name)

#玩一下yield方法；
func emitSignal(toNode):
	print("current time scale",get("parameters/TimeScale/scale"))
	print("current node",toNode,OS.get_ticks_msec())
	$RichTextLabel.text +=( "-->" + toNode as String)
	#sinal
	emit_signal("State_Changed",toNode)
