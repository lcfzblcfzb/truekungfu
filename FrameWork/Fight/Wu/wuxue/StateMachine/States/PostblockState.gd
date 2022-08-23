extends State

func _init():
	state_can_go = [Glob.WuMotion.Block,Glob.WuMotion.Idle,Glob.WuMotion.Walk,Glob.WuMotion.JumpFalling,Glob.WuMotion.JumpRising,Glob.WuMotion.JumpUp,Glob.WuMotion.JumpDown,Glob.WuMotion.Rolling,Glob.WuMotion.Attack_Pi,Glob.WuMotion.Attack]
	state = Glob.WuMotion.PostBlock
