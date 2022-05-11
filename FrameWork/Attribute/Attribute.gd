class_name Attribute
extends VirtualAttribute

var base =0 
var bonus =0
var bonus_rate =1
var base_rate =0
var all_rate =1

func _init(_base,type).(type):
	base=_base
	_recalc_value()

func _recalc_value():
	
	for fac in _factor_array:
		if fac:
			fac = fac as AttributeFactor
			
			match fac.type:
				AttributeFactor.Type.Base:
					base = fac.value
					pass
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
	
	if type == Glob.CharactorAttribute.BlockRegen or type == Glob.CharactorAttribute.StaminaRegen:
		_value = _value / Engine.iterations_per_second
	elif type in range(Glob.AttributeType.get("DurationMs").get("min_idx"),Glob.AttributeType.get("DurationMs").get("max_idx")+1):
		_value = _value * 1000
	
	_is_dirty = false



