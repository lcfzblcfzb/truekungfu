extends State

func _init():
	state_can_go = [Glob.WuMotion.Climb,Glob.WuMotion.JumpUp,Glob.WuMotion.JumpDown,Glob.WuMotion.JumpRising,Glob.WuMotion.JumpFalling,Glob.WuMotion.Idle]
	state = Glob.WuMotion.Climb
