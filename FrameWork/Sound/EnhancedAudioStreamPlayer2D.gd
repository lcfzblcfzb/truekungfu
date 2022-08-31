extends AudioStreamPlayer2D

var looping =false

func _ready():
	connect("finished",self,"_on_AudioStreamPlayer2D_finished")

func _on_AudioStreamPlayer2D_finished():
	if looping:
		play()
	else:
		stop()
