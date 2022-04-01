class_name VirtualAttribute

#Glob.CharactorAttribute
var type setget _private_set

var _factor_array=[] setget _private_set,_private_get

var _is_dirty = true
var _value =0


func _init(_type):
	type = _type

func get_value():
	
	if _is_dirty:
		_recalc_value()
		
	return _value

#virtual method
func _recalc_value():
	pass


func add_factor(factor:AttributeFactor):
	
	_is_dirty = true
	_factor_array.append(factor)
	factor._attribute = self
	
func remove_factor(factor):
	
	_is_dirty = true
	_factor_array.erase(factor)
	factor.dead()
	
func _private_set(s):
	push_warning("trying to set private property")

func _private_get():
	push_warning("trying to get private property")
