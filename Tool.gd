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
	return node.get_viewport_transform() * (node.get_global_transform() * node.position)
