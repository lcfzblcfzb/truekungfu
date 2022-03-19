class_name BaseRole
extends KinematicBody2D

#所属阵营。值在Tool.CampEnum
export (Glob.CampEnum) var camp:int ;
#是否挂掉了
var isDead:bool;

#export var INIT_SPEED =100;
#var speed =INIT_SPEED setget , getSpeed;
#
#func getSpeed():
#	return speed


func _ready():
	RoleMng.campDict[camp].append(self)
	connect("tree_exiting",self,"_on_dead")

#角色移除出场景的时候触发
func _on_dead():
	RoleMng.remove_from_list(self)
