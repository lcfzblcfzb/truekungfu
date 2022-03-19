extends Node2D

var campDict={}
# Called when the node enters the scene tree for the first time.
func _ready():
	for c in Glob.CampEnum:
		campDict[Glob.CampEnum[c]]=[]
	
#找到某个阵营的所有成员
func findCampMembers(camp,duplicate=false):
	
	var result =campDict[camp] as Array
	if result ==null :
		return []
	if duplicate:
		return result.duplicate()
	else :
		return result

#找到所有对立阵营;  duplicate：是否要将结果存在新的数组中，不影响原始数组。选择true 则比较安全保险，以防数组被滥用。选择false表示已经知晓了影响，要注意对于返回的数组中元素的增删改操作都会影响CharactorMng中的campDict内容
func findOpposeMember(camp,duplicate=false)->Array:
	if camp ==Glob.CampEnum.Good:
		return campDict[Glob.CampEnum.Bad]
	elif camp ==Glob.CampEnum.Bad:
		return campDict[Glob.CampEnum.Good]
	return []

#移除出数组
func remove_from_list(charactor):
	var campList = campDict.get(charactor.camp) as Array
	
	var index = campList.find(charactor)
	
	if index >=0:
		campList.remove(index)
	
	pass
	
