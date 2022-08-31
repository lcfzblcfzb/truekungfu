extends Resource

export (Array,Resource) var datas

func get_by_id(id):
	
	for data in datas:
		if data.id== id:
			return data
