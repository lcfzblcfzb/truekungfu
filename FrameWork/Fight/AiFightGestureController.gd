class_name AiFightGestureController

extends BaseFightActionController

var fight_cpn:FightComponent_human
var behavior_tree:BehaviorTree

func _ready():
	
	pass

func init_behaviour_tree(tree):
	assert(tree!=null,"error,behaviortree is suppose to be not null")	
	behavior_tree = tree
	add_child(tree)

func switch_tree(tree):
	assert(tree!=null,"error,behaviortree is suppose to be not null")	
	
	if behavior_tree!=null:
		behavior_tree.is_active = false
		remove_child(behavior_tree)
	behavior_tree = tree
	add_child(tree)
