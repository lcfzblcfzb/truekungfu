class_name ListDataMng
extends DataMng

var _list:Array=[]

func load_data():
	_list = DataLoader.load_from_json_array_file(file_path,data_type)
	

func get_by_id(id):
	for _e in _list:
		if _e.get("id")== id:
#			print(_e.get("id"))
			return _e 
	return null
