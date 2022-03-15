extends DataLoader

func _ready():
	load_from_json_array_file("res://resource/config/BaseCharactors.tres",BaseCharactor)

func get_by_id ( id )->BaseCharactor:
	
	for item in _datas:
		
		if item.id == id:
			return item
	
	return null
