extends State

func _init():
	state_can_go = [Glob.WuMotion.Attack,Glob.WuMotion.Holding,Glob.WuMotion.Idle]
	state = Glob.WuMotion.Holding
