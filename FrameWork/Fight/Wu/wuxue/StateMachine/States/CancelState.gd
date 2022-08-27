extends State

func _init():
	state_can_go = [Glob.WuMotion.Idle,Glob.WuMotion.Attack,Glob.WuMotion.Attack_Pi]
	state = Glob.WuMotion.Cancel
