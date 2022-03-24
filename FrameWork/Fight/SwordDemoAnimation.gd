extends Node2D

signal Hit
signal Hurt
signal AnimationCallMethod

export (NodePath)var fight_component_path

var fight_component:FightComponent_human 

func _ready():
	
	fight_component = get_node(fight_component_path)
	change_face_direction(1)
	
#选用队应的角色形象 Glob.CharactorEnum
func choose_charactor(c):
	#根据设置的charactor 找到对应的角色类 并设置上
	$StandarAnimatedCharactor.choose_charactor(c,self)
	
	var hurt_box = $StandarAnimatedCharactor.get_standar_charactor().get_hurt_box()
	hurt_box.set("fight_cpn",fight_component)
	if fight_component.camp == Glob.CampEnum.Bad:
		#设置武器碰撞检测层
		hurt_box.collision_layer =  	0b1000
		hurt_box.collision_mask =	    0b0001
	elif fight_component.camp == Glob.CampEnum.Good:
		#设置武器碰撞检测层
		hurt_box.collision_layer =   0b0010
		hurt_box.collision_mask = 0b0100
	
	$StandarAnimatedCharactor.fight_cpn = fight_component


func choose_wuxue_animation(wuxue:WuXue):
	$StandarAnimatedCharactor.choose_coresponding_animation(wuxue)

func change_state(state):
	change_state(state)

func change_face_direction(face):
	
	if face>0:
		scale.x = 1
	elif face<0:
		scale.x = -1
	print("change face direction",face)
	pass

func _on_FightKinematicMovableObj_Charactor_Face_Direction_Changed(direction):
	
	change_face_direction(direction.x)

func get_coresponding_animation_tree():
	return $StandarAnimatedCharactor.get_coresponding_animation_tree()

func set_state(s):
	$StandarAnimatedCharactor.set_state(s)

func get_standar_charactor()->StandarCharactor:
	return $StandarAnimatedCharactor.get_standar_charactor()
