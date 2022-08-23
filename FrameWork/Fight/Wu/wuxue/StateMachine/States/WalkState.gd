extends State




func _init():
	state_can_go = [Glob.WuMotion.Walk,Glob.WuMotion.Idle,Glob.WuMotion.Run,Glob.WuMotion.JumpUp,Glob.WuMotion.JumpFalling ,Glob.WuMotion.Rolling ,Glob.WuMotion.Climb,Glob.WuMotion.Block,Glob.WuMotion.Attack,Glob.WuMotion.Attack_Pi,Glob.WuMotion.Holding]
	state = Glob.WuMotion.Walk
