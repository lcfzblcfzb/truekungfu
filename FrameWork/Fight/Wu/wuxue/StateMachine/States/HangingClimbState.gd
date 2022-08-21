extends State


func _init():
	state_can_go = [Glob.WuMotion.Idle,Glob.WuMotion.JumpUp]
	state = Glob.WuMotion.HangingClimb
