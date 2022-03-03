extends Node2D

signal Hit
signal Hurt
signal AnimationCallMethod

export (NodePath)var fight_component_path

var fight_component:FightComponent_human 

onready var weapon_box:WeaponBox = $weapon_box 
onready var hurt_box:HurtBox = $hurt_box

#可选角色形象
export (Tool.CharactorEnum) var chosed_characor = Tool.CharactorEnum.Daoshi

func _ready():
	$StandarAnimatedCharactor.choose_charactor(chosed_characor,self)
	fight_component = get_node(fight_component_path)
	$hurt_box.set("fight_cpn",fight_component)
	change_face_direction(1)

func choose_wuxue_animation_and_gear(wuxue):
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

func _physics_process(delta):
	#检测武器实时碰撞(不使用信号是因为信号无法检测 在启动 monitoring的瞬间已经处于碰撞状态的情况
	if weapon_box.monitoring :
		var list =weapon_box.get_overlapping_areas()
		if list.size()>0:
			emit_signal("Hit",list)	
			weapon_box.monitoring = false
			for area in list:
				var fight_cpn = area.fight_cpn
				fight_cpn.sprite_animation.emit_signal("Hurt",weapon_box)	
				pass
			
func get_coresponding_animation_tree():
	return $StandarAnimatedCharactor.get_coresponding_animation_tree()

func set_state(s):
	$StandarAnimatedCharactor.set_state(s)
