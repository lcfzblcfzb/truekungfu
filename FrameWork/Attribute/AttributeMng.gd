extends Node2D

var _attribute_dict={}

func init(charactor:BaseCharactor):
	
	for a in Glob.CharactorAttribute:
		var idx = Glob.CharactorAttribute[a]
		var attr = Attribute.new( charactor.attribute.get(idx,0 ) )
		_attribute_dict[idx]= attr
