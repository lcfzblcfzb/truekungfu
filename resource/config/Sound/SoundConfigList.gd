extends Resource

export(Array,Resource) var data_list


func get_by_id(id):
	
	for sound in data_list:
		if sound.id == id:
			return sound
