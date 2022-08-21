extends State

func _init():
	state_can_go = [Glob.WuMotion.JumpDown]
	state = Glob.WuMotion.JumpFalling
