class_name StandarCharactor
extends Sprite

var charactor_type 
#就是 SpriteAnimation 节点
var animation_node
#animationPlayer中 由call_method_track 调用的方法
#做一个代理调用方法
func animation_call_method(args1):
	animation_node.emit_signal("AnimationCallMethod",args1)
	pass

