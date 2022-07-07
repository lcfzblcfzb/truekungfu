extends Resource

export(Array,Resource) var list
func get_by_id(id):
	for item in list:
		if item.get(id)==id:
			return item
			
func get_by_base_gear_id(base_gear_id):
	for item in list:
		if item.get("baseGearId")==base_gear_id:
			return item
