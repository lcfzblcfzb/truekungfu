class_name Attribute
extends VirtualAttribute

var base
var bonus
var bonus_rate
var base_rate
var all_rate

func _init(_base):
	base=_base

func _recalc_value():
	
	for fac in _factor_array:
		if fac:
			fac = fac as AttributeFactor
			
			match fac.type:
				AttributeFactor.Type.Bonus:
					bonus+= fac.value
					pass
				AttributeFactor.Type.BaseRate:
					base_rate+= fac.value
					pass
				AttributeFactor.Type.BonusRate:
					bonus_rate+= fac.value
					pass
				AttributeFactor.Type.AllRate:
					all_rate+= fac.value
					pass
			
			pass
		pass
	
	
	_value = base+ base * base_rate * all_rate + bonus * bonus_rate * all_rate
	_is_dirty = false



