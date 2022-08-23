extends State

func _init():
	state_can_go = [Glob.WuMotion.Attack,Glob.WuMotion.Holding]
	state = Glob.WuMotion.Holding
