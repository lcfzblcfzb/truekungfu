extends Resource

export(Array,Resource) var list
func get_by_id(id):
	for item in list:
		if item.get("id")==id:
			return item
