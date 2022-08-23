extends State

func _init():
	state_can_go = [Glob.WuMotion.JumpDown,Glob.WuMotion.JumpFalling , Glob.WuMotion.Hanging]
	state = Glob.WuMotion.JumpFalling
