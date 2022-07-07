extends Control

const ITEM_EMPTY ="res://resource/texture/UI/Ancient/brown.png"
const ITEM_OCCUPIED = "res://resource/texture/UI/Ancient/brown_pressed.png"
const ITEM_INSIDE = "res://resource/texture/UI/Ancient/brown_inlay.png"
const ITEM_LOCKED ="res://resource/texture/UI/Ancient/grey.png"

onready var UI_outfit_icon = $outfit_icon

export(int) var index =0
#stored outfit in this slot
var outfit

func has_point(pos):
	var rect =get_global_rect()
	return rect.has_point(pos)

func get_preview_texture():
	return UI_outfit_icon.texture

func add_texture(tex):
	UI_outfit_icon.texture =tex

func add_outfit(of):
	if outfit!=null:
		return
	outfit = of
	
	var base = outfit.get_base_outfit()
	UI_outfit_icon.texture = base.icon

func remove_outfit():
	outfit =null
	UI_outfit_icon.texture =null

#func get_drag_data(_pos):
#	# Use another colorpicker as drag preview.
#	var spr = TextureRect.new()
#	spr.texture = sprite.texture
#	spr.anchor_top =1
#	set_drag_preview(spr)
#	# Return color as drag data
#	return sprite
#
#func can_drop_data(_pos, data):
#	return data is Sprite
#
#func drop_data(_pos, data):
#	sprite.texture = data.texture
#	data.texture = null
#	data.visible =true
