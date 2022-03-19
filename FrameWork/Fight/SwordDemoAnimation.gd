extends Node2D

signal Hit
signal Hurt
signal AnimationCallMethod

export (NodePath)var fight_component_path

var fight_component:FightComponent_human 

#可选角色形象
export (Glob.CharactorEnum) var chosed_characor = Glob.CharactorEnum.Daoshi

func _ready():
	#根据设置的charactor 找到对应的角色类 并设置上
	$StandarAnimatedCharactor.choose_charactor(chosed_characor,self)
	fight_component = get_node(fight_component_path)
	
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
	change_face_direction(1)

func choose_wuxue_animation_and_gear(wuxue:WuXue):
	$StandarAnimatedCharactor.choose_coresponding_wuxue(wuxue)

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

#func _physics_process(delta):
#	#检测武器实时碰撞(不使用信号是因为信号无法检测 在启动 monitoring的瞬间已经处于碰撞状态的情况
#	if weapon_box.monitoring :
#		var list =weapon_box.get_overlapping_areas()
#		if list.size()>0:
#			emit_signal("Hit",list)	
#			weapon_box.monitoring = false
#			for area in list:
#				var fight_cpn = area.fight_cpn
#				fight_cpn.sprite_animation.emit_signal("Hurt",weapon_box)	
#				pass
			
func get_coresponding_animation_tree():
	return $StandarAnimatedCharactor.get_coresponding_animation_tree()

func set_state(s):
	$StandarAnimatedCharactor.set_state(s)

func get_standar_charactor()->StandarCharactor:
	return $StandarAnimatedCharactor.get_standar_charactor()
