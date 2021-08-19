extends Node2D

class_name AIDetector

#所有可攻击对象
var targetsArray=[];

onready var attackRangeShape = $AttackRange/CollisionShape2D
onready var secureRangeShape = $SecureRange/CollisionShape2D
onready var detectEnemyRay:RayCast2D = $RayCast2D

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
	
	pass
	
func _process(delta):
	pass
func _physics_process(delta):
	
	
	pass
	
func checkRange():
	pass
