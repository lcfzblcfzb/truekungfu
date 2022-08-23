extends State


func _init():
	state_can_go = [Glob.WuMotion.JumpFalling,Glob.WuMotion.Walk,Glob.WuMotion.Run,Glob.WuMotion.JumpUp,Glob.WuMotion.Climb,Glob.WuMotion.Rolling,Glob.WuMotion.Attack,Glob.WuMotion.Attack_Pi,Glob.WuMotion.Block,Glob.WuMotion.Holding]
	state = Glob.WuMotion.Idle
