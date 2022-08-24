extends State


func _init():
	state_can_go = [Glob.WuMotion.Idle,Glob.WuMotion.Walk,Glob.WuMotion.Run,Glob.WuMotion.JumpFalling,Glob.WuMotion.Attack,Glob.WuMotion.Attack_Pi,Glob.WuMotion.JumpUp]
	state = Glob.WuMotion.Rolling
