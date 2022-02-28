extends Weapon


func _init():
	peace_transform = Transform2D(deg2rad(-110),Vector2(1,0))
	engaged_transform = Transform2D(deg2rad(115),Vector2(0,0))
	
#初始化的时候调用的
func add_to_charactor(_attached_charactor:StandarCharactor,to_state=StandarCharactor.CharactorState.Peace):
	attached_charactor = _attached_charactor
	to_state(to_state)

func _on_to_state(s):
	
	match s:
		StandarCharactor.CharactorState.Peace:
			attached_charactor.add_to_body(StandarCharactor.CharactorBodySlotEnum.Left_Hand , self )
		StandarCharactor.CharactorState.Engaged:
			attached_charactor.add_to_body(StandarCharactor.CharactorBodySlotEnum.Right_Hand , self)
