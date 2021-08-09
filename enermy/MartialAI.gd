extends Node2D

export (NodePath) var charactorNodePath;
onready var detector=$AiDetector as AIDetector
var charactor:BaseCharactor

var isPlayerAround =false
var isLocked = false
var lockTarget;

var WIGGLE = 0
var READY =1
var RETREAT =2
var SWITCH=3
var DEF=4
var ROLL=5
var IDLE =6
var PATROL =7
var ESCAPE=8

var state ;

# Called when the node enters the scene tree for the first time.
func _ready():
	state = IDLE
	charactor = get_node(charactorNodePath)

func _process(delta):
	pass

func _physics_process(delta):
	if charactor:
		#查找到	
		var oppoArray =CharactorMng.findOpposeMember(charactor.camp,false)
	#进行ray 检测

