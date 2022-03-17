extends Node2D

var max_value =0
var value  = 0

func _ready():
	var margins = [$TextureProgress.margin_bottom,$TextureProgress.margin_top,$TextureProgress.margin_left,$TextureProgress.margin_right]
	$TextureProgress.set_meta("margin",margins)

func _physics_process(delta):
	
#	update_value(value+delta)

	pass
func get_texture_progress():
	return $TextureProgress


func set_max_value(v):
	
	max_value = v
	
	$TextureProgress.max_value = v
	$TextureProgress/max.text = str(v)

func update_value(v):
	
	value = v
	$TextureProgress.value =v
	$TextureProgress/current.text = str(round(v))
	var siz = $TextureProgress.rect_size 
	var m =$TextureProgress.max_value
	var offset = $TextureProgress.value / m
	$TextureProgress/current.anchor_left = offset
	
