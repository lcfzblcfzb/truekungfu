extends State


func _init():
	state_can_go = [Glob.WuMotion.JumpFalling,Glob.WuMotion.JumpDown,Glob.WuMotion.Climb,Glob.WuMotion.Hanging]
	state = Glob.WuMotion.JumpRising
