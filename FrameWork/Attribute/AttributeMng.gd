class_name AttribugeMng
extends Node2D

var _attribute_dict={}

func init(charactor:BaseCharactor):
	
	for a in Glob.CharactorAttribute:
		var idx = Glob.CharactorAttribute[a]
		var attr = Attribute.new( charactor.attribute.get(a,0 ) ,idx)
		_attribute_dict[idx]= attr

#type => Glob.CharactorAttribute
func get_value(type):
	
	var attribute = _attribute_dict.get(type)
	
	if attribute:
		return attribute.get_value()
	
