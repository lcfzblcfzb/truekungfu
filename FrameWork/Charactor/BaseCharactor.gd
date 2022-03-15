class_name BaseCharactor

# 采用 Tool.CharactorEnum
var id

var name
#骨骼类型   Tool.ChatactorSkeletalType
var skeletal_type setget _set_skeletal_type

func _set_skeletal_type(s):
	skeletal_type = int(s)
