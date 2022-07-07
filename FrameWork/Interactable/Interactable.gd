class_name Interactable
extends Node2D

export(Glob.BaseOutfitType) var base_outfit_id
export(int) var num = 1

var added_bodys =[]

func pick(fight_cpt):
	var outfit = GlobVar.outfitMng.new_outfit(base_outfit_id,num)
	fight_cpt.inventory.add_outfit(outfit)
	
	for body in added_bodys:
		body.remove_interactable(self)
	added_bodys.clear()
	queue_free()

func _on_Area2D_body_entered(body):
	body.add_interactable(self)
	added_bodys.append(body)

func _on_Area2D_body_exited(body):
	body.remove_interactable(self)
	added_bodys.erase(body)
