tool
extends Node


enum CampEnum {
	Good,
	Bad,
	Neutral,#以上可以互相攻击
	Harmless#任何一方都无法攻击
}

func test():
	print("print test global")

var dPi = 2*PI
var hPi = PI/2
#返回一个介于0-》2PI 之间的角度
func normalizeAngle(angle:float):
	var absAngle =abs(angle)
	if(absAngle>dPi||angle<0):
		angle = fposmod(angle,dPi)
	
	return angle
#详情见godot文档。节点在屏幕上的坐标章节 
func getCameraPosition(node:Node2D)->Vector2:
	
#	print(node.get_viewport_transform(),node.get_global_transform(),node.position)
	
	return node.get_viewport_transform() * (node.get_global_transform() * node.position)

func load_json_file(path):
	"""Loads a JSON file from the given res path and return the loaded JSON object."""
	var file = File.new()
	file.open(path, file.READ)
	var text = file.get_as_text()
	var result_json = JSON.parse(text)
	if result_json.error != OK:
		print("[load_json_file] Error loading JSON file '" + str(path) + "'.")
		print("\tError: ", result_json.error)
		print("\tError Line: ", result_json.error_line)
		print("\tError String: ", result_json.error_string)
		return null
	var obj = result_json.result
	return obj
