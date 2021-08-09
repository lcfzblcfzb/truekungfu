extends NpcOf2Direction

var aggresiveMovingContril:AggresiveCharactor

# Called when the node enters the scene tree for the first time.
func _ready():
	aggresiveMovingContril = AggresiveCharactor.new(self) 


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
