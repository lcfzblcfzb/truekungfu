tool
extends Node
class_name WuxueMngClass
#字典对象
var dict ={
	WuxueEnum.Fist:preload("res://FrameWork/Fight/Wu/weapon/WU_Fist.tscn"),
	WuxueEnum.Sword:preload("res://FrameWork/Fight/Wu/weapon/WU_Sword.tscn")
}

#枚举类型
enum WuxueEnum{
	
	Fist,Sword
	
}

#通过WuxueEnum 获得队应类
func get_by_type(type)->PackedScene:
	return dict.get(type)
	


