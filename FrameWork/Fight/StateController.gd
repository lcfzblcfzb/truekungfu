extends Object

#path to file
export(String, FILE) var cfg_path
# Declare member export(float, 0, 5, 0.1)  variables here. Examples:
# export(float, 0, 5, 0.1)  var a = 2
# export(float, 0, 5, 0.1)  var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	#从文件中读取JSON数据，并且赋值给对象同名属性上
	var json =Tool.load_json_file(cfg_path) as Dictionary
	
	var pl = get_property_list()
	for node in get_property_list():
					
		var p = node.name
		var splited_property_array = p.split("_")
		
		for k  in json.keys():
			var splited_array = k.split("_")
			
			if splited_array.size()!=splited_property_array.size():
				continue;
				
			if splited_array.size()<=0:
				continue	
			
			var is_match = true				
			for i in splited_property_array.size():
				
				var p_e = splited_property_array[i] as String
				var f_e =splited_array[i] as String
				
				if p_e==""||f_e=="":
					break
				
				if p_e[0]!=f_e[0]:
					is_match = false
					break
				pass
			
			if is_match:
				var v= json.get(k)
				set(p,v.value)
			
			pass
		
		pass
	pass
	
	pass # Replace with function body.
#攻击——上路
export(float, 0, 5, 0.1)  var a_u_pre :float;
export(float, 0, 5, 0.1)  var a_u_in :float;
export(float, 0, 5, 0.1)  var a_u_after :float;
#攻击——中路
export(float, 0, 5, 0.1)  var a_m_pre :float;
export(float, 0, 5, 0.1)  var a_m_in :float;
export(float, 0, 5, 0.1)  var a_m_after :float;
#攻击——下路
export(float, 0, 5, 0.1)  var a_b_pre :float;
export(float, 0, 5, 0.1)  var a_b_in :float;
export(float, 0, 5, 0.1)  var a_b_after :float;
	
#重攻击——上路
export(float, 0, 5, 0.1)  var ha_u_pre :float;
export(float, 0, 5, 0.1)  var ha_u_in :float;
export(float, 0, 5, 0.1)  var ha_u_after :float;
#重攻击——中路
export(float, 0, 5, 0.1)  var ha_m_pre :float;
export(float, 0, 5, 0.1)  var ha_m_in :float;
export(float, 0, 5, 0.1)  var ha_m_after :float;
#重攻击——下路
export(float, 0, 5, 0.1)  var ha_b_pre :float;
export(float, 0, 5, 0.1)  var ha_b_in :float;
export(float, 0, 5, 0.1)  var ha_b_after :float;

#防御——上路
export(float, 0, 5, 0.1)  var d_u_pre :float;
export(float, 0, 5, 0.1)  var d_u_in :float;
export(float, 0, 5, 0.1)  var d_u_end :float;
#防御——中路
export(float, 0, 5, 0.1)  var d_m_pre :float;
export(float, 0, 5, 0.1)  var d_m_in :float;
export(float, 0, 5, 0.1)  var d_m_end :float;
#防御——下路
export(float, 0, 5, 0.1)  var d_b_pre :float;
export(float, 0, 5, 0.1)  var d_b_in :float;
export(float, 0, 5, 0.1)  var d_b_end :float;

#重防御——上路
export(float, 0, 5, 0.1)  var hd_u_pre :float;
export(float, 0, 5, 0.1)  var hd_u_in :float;
export(float, 0, 5, 0.1)  var hd_u_end :float;
#重防御——中路
export(float, 0, 5, 0.1)  var hd_m_pre :float;
export(float, 0, 5, 0.1)  var hd_m_in :float;
export(float, 0, 5, 0.1)  var hd_m_end :float;
#重防御——下路
export(float, 0, 5, 0.1)  var hd_b_pre :float;
export(float, 0, 5, 0.1)  var hd_b_in :float;
export(float, 0, 5, 0.1)  var hd_b_end :float;


