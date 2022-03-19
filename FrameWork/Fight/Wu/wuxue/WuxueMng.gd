tool
extends Node
class_name WuxueMngClass
#字典对象
var dict ={
	Glob.WuxueEnum.Fist:preload("res://FrameWork/Fight/Wu/wuxue/WU_Fist.tscn"),
	Glob.WuxueEnum.Sword:preload("res://Game/Wuxue/WU_Sword.tscn")
}


#通过WuxueEnum 获得队应类
func get_by_type(type)->PackedScene:
	return dict.get(type)
	


