extends Node2D

var daoshi_scn = preload("res://FrameWork/Charactor/standar_charactors/DaoshiStandar.tscn")
var rusheng_scn = preload("res://FrameWork/Charactor/standar_charactors/RushengStandar.tscn")

onready var charactor_scene:StandarCharactor = $hip

func choose_charactor(c):
	
	if charactor_scene.charactor_type == c:
		return 
	
	if charactor_scene!= null :
		charactor_scene.queue_free()
	
	match c:
		Tool.CharactorEnum.Rusheng:
			charactor_scene = rusheng_scn.instance()
			charactor_scene.set("animation_node",self)
			add_child(charactor_scene)
			$AnimationTree/AnimationPlayer.root_node = $AnimationTree/AnimationPlayer.get_path_to(charactor_scene)
			
		Tool.CharactorEnum.Daoshi:
			charactor_scene = daoshi_scn.instance()
			charactor_scene.set("animation_node",self)
			add_child(charactor_scene)
			$AnimationTree/AnimationPlayer.root_node = $AnimationTree/AnimationPlayer.get_path_to(charactor_scene)
	
func get_coresponding_animationplayer(wuxue):
	
#	match wuxue :
#		WuxueMng.WuxueEnum.Fist:
#			$AnimationTree.anim_player = $AnimationTree.get_path_to($AnimationPlayer)
#		WuxueMng.WuxueEnum.Sword:
#			$AnimationTree.anim_player = $AnimationTree.get_path_to($AnimationPlayer)
#		_:
#			$AnimationTree.anim_player = $AnimationTree.get_path_to($AnimationPlayer)
	$AnimationTree.active = true

func get_coresponding_animation_tree():
	return $AnimationTree
