extends Node2D

class_name Weapon

enum Direction{
	UP,CENTER,DOWN
}

#防御
func defence(d):
	push_warning("defence not implemented .")
	pass

#重攻击
func heavyAttack(d):
	push_warning("heavyAttack not implemented .")
	pass
#轻攻击
func lightAttck(d):
	push_warning("lightAttck not implemented .")
	pass

#defBox 自动防御的区域
func defDirection(direction:Vector2):
	pass
