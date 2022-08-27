extends Node2D

const BaseActionList =preload("res://resource/config/Action/BaseActionList.tres")

var dict={}

func _ready():
	
	for data in BaseActionList.data_list:
		
		dict[data.id] = data

func get_by_anim_name(anim)->String:
	
	for i in dict:
		var item = dict.get(i)
		if item.animation_name ==anim:
			return item
	
	return ""

func get_by_id(id):
	return dict[id]
