class_name BaseAction

extends Object


func _init(param:Dictionary):
	
	id= param.get("id")
	name= param.get("name")
	animation_name= param.get("animation_name")
	type= param.get("type")
	duration= param.get("duration")
	

var id;
var name;
var animation_name;
var type:Array;
var duration

