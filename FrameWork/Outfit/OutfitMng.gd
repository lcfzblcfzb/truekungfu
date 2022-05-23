class_name OutfitMng

func new_outfit(base_id, num):
	var outfit = Outfit.new()
	outfit.id = Glob.get_next_gid()
	outfit.base_id = base_id
	outfit.num = num
	return outfit
