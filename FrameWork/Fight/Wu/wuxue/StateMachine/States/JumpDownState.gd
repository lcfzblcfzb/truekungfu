extends State

func _init():
	state_can_go = [Glob.WuMotion.Idle,Glob.WuMotion.Walk,Glob.WuMotion.Run]
	state = Glob.WuMotion.JumpDown
