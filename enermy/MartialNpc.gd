extends NpcOf2Direction

var aggresiveMovingContril:AggresiveCharactor

onready var ai:AI =$AI

# Called when the node enters the scene tree for the first time.
func _ready():
	aggresiveMovingContril = AggresiveCharactor.new(self) 
	ai.movableObj = aggresiveMovingContril
func _process(delta):
	aggresiveMovingContril.onProcess(delta)
	
func _physics_process(delta):
	aggresiveMovingContril.onPhysicsProcess(delta)
