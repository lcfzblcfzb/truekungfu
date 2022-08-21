extends State

func _init():
	state_can_go = [Glob.WuMotion.Idle,Glob.WuMotion.HangingClimb,Glob.WuMotion.JumpFalling]
	state = Glob.WuMotion.Hanging
