class_name BaseCharactor

# 采用 Glob.CharactorEnum
var id:int

var name
#骨骼类型   Glob.ChatactorSkeletalType
var skeletal_type setget _set_skeletal_type

var attribute:Dictionary ={}


func _set_skeletal_type(s):
	skeletal_type = int(s)
