extends State

func _init():
	state_can_go = [Glob.WuMotion.Idle,Glob.WuMotion.Walk,Glob.WuMotion.Run,Glob.WuMotion.Rolling,Glob.WuMotion.JumpUp,Glob.WuMotion.Attack,Glob.WuMotion.Attack_Pi,Glob.WuMotion.Block,Glob.WuMotion.Holding,Glob.WuMotion.Cancel]
	state = Glob.WuMotion.Attack
