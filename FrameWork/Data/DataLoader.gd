class_name DataLoader
extends Node

var _file_path
var _datas=[]

func load_from_json_array_file(path,_class:GDScript):
	
	var json_result = _load_json_file(path)
	
	if json_result!=null:
		_file_path = path
		
		if typeof(json_result) == TYPE_ARRAY:
			
			for unit in json_result:
				
				var to_object = _class.new() as Object
				
				var list = to_object.get_property_list()
			
				for attr in list:
					#这里的 attr 是一个 字典；包含了改 property 的 各项属性
					# .name 属性 是对应property 的名称
					if unit.has(attr.name):
						to_object[attr.name] = unit.get(attr.name) 
					pass
					
				_datas.append(to_object)
				pass
			
		else:
			push_error("Unexpected results.")
		
	pass
	
	

#从text文件中读取json 并保存为json对象
func _load_json_file(path):
	"""Loads a JSON file from the given res path and return the loaded JSON object."""
	var file = File.new()
	file.open(path, file.READ)
	var text = file.get_as_text()
	var result_json = JSON.parse(text)
	if result_json.error != OK:
		print("[load_json_file] Error loading JSON file '" + str(path) + "'.")
		print("\tError: ", result_json.error)
		print("\tError Line: ", result_json.error_line)
		print("\tError String: ", result_json.error_string)
		push_error("JSON parse error")
		return null
	var obj = result_json.result
	return obj
