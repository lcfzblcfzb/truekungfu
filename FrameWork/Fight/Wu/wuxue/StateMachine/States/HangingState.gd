extends State

func _init():
	state_can_go = [Glob.WuMotion.HangingClimb,Glob.WuMotion.JumpFalling]
	state = Glob.WuMotion.Hanging
