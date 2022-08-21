extends State



func _init():
	state_can_go = [Glob.WuMotion.Idle,Glob.WuMotion.Walk,Glob.WuMotion.JumpUp,Glob.WuMotion.JumpFalling ,Glob.WuMotion.Rolling ,Glob.WuMotion.Climb]
	state = Glob.WuMotion.Run
