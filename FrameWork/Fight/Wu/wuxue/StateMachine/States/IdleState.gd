extends State


func _init():
	state_can_go = [Glob.WuMotion.Walk,Glob.WuMotion.Run,Glob.WuMotion.JumpUp,Glob.WuMotion.Climb,Glob.WuMotion.Rolling]
	state = Glob.WuMotion.Idle
