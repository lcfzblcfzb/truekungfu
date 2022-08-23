extends State

func _init():
	state_can_go = [Glob.WuMotion.Idle,Glob.WuMotion.Attack_Pi,Glob.WuMotion.Block,Glob.WuMotion.Attack,Glob.WuMotion.Holding]
	state = Glob.WuMotion.Attack_Pi
