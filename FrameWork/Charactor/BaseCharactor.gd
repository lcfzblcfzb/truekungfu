class_name BaseCharactor
extends KinematicBody2D

#所属阵营。值在Tool.CampEnum
export (Tool.CampEnum) var camp:int ;
#是否挂掉了
var isDead:bool;

func _ready():
	CharactorMng.campDict[camp].append(self)
