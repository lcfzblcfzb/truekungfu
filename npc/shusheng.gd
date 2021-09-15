extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("kick")
	delayFunc()
	pass # Replace with function body.

var flag = true
func delayFunc():
	print("start")
	yield(get_tree().create_timer(1.0), "timeout")
	if flag:
		#$npc_poly.texture =load("res://texture/npc/peson.png")
		$npc_poly.texture =load("res://texture/texture002/jinyiwei_attackleft_down_002-Sheet.png")
		
	else:
		$npc_poly.texture =load( "res://texture/npc/shusheng.png")
	flag = !flag
	delayFunc()
	print("end")

