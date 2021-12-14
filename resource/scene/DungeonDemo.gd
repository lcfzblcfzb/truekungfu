extends Node2D

onready var player = $MainPlayer
onready var spawn = $spawnPoint
onready var guard = $Guard


func _ready():
	player.set_deferred("position",spawn.position)
	if guard:
		guard.player = player
	

func _on_Area2D_body_entered(body):
	
	get_tree().change_scene("res://scene/DungeonDemo002.tscn")
