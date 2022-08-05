class_name CommonTools

static func get_enum_key_name(enum_obj,v):
	for k in enum_obj.keys():
		if enum_obj[k]==v:
			return k
