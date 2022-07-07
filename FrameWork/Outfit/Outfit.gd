class_name Outfit

var id
var base_id
var num

var base_obj

func on_added():
	pass

func on_used():
	pass
	
func on_removed():
	pass

func get_base_outfit():
	if base_obj==null:
		base_obj = GlobVar.BaseOutfitConfig.get_by_id(base_id)
		
	return base_obj
