extends State

func _init():
	state_can_go = [Glob.WuMotion.JumpDown,Glob.WuMotion.JumpFalling]
	state = Glob.WuMotion.JumpFalling
