extends State




func _init():
	state_can_go = [Glob.WuMotion.Idle,Glob.WuMotion.Run,Glob.WuMotion.JumpUp,Glob.WuMotion.JumpFalling ,Glob.WuMotion.Rolling ,Glob.WuMotion.Climb]
	state = Glob.WuMotion.Walk
