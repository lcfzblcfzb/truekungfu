tool
extends Node2D

class_name AIDetector


onready var attackRangeShape = $AttackRange/CollisionShape2D
onready var secureRangeShape = $SecureRange/CollisionShape2D

export var attackRangeRadius:float setget setAttackRangeRadius

func setAttackRangeRadius(v):
	attackRangeRadius = v
	if attackRangeShape:
		attackRangeShape.shape.radius = v

export var secureRangeRadius: float setget setSecureRangeRadius

func setSecureRangeRadius(v):
	secureRangeRadius = v
	if secureRangeShape:
		secureRangeShape.shape.radius =v
	
export var searchRangeRadius:float

#================================功能函数区域	
func _init(attackRange=70,secureRange=200,searchRanges=250):
	attackRangeRadius = attackRange
	secureRangeRadius = secureRange
	searchRangeRadius = searchRanges

func _ready():
	
	self.attackRangeRadius = 987 
	
func _process(delta):
	print(attackRangeShape.shape.radius)
	print("")
