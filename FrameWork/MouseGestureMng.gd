extends Node2D

const MaxAngleSpeed  = 500

#攻击指示标（鼠标按下和抬起的位置）
var endPos = Vector2.ZERO
var attackPos = Vector2.ZERO
var mouseMovingPos = Vector2.ZERO
var attackDirection = 0

#指向endPos向量的弧度
var endPosRotation = Vector2.ZERO
#朝向鼠标的向量
var toMouseVector = Vector2.ZERO
var jisu

func _init(jizhu):
	if(jizhu):
		jisu = jizhu

func _ready():
	if(!jisu):
		jisu = get_parent()		

func _input(event):
	
	if(event is InputEventMouse):
		
		if event.is_action_pressed("attack"):
			attackPos =event.global_position;
			onAttackPosChange()
		elif event.is_action_released("attack"):
			endPos = event.global_position
						
			var screenPos =Tool.getCameraPosition(self)
			
			var startVector = attackPos - screenPos
			var moveVector = endPos - screenPos

			attackDirection =sign(startVector.cross(moveVector))
			if attackDirection==0:
				attackDirection =1;
			#计算 endPos 与 父节点 所成的向量 的 角度值
			endPosRotation =Tool.normalizeAngle(endPos.angle_to_point(screenPos))
			onEndPosChange()
	if(event is InputEventMouseMotion):
		#relativePos = event.relative;
		mouseMovingPos = event.global_position
		var screenPos =Tool.getCameraPosition(jisu.sprite)
		toMouseVector = (mouseMovingPos- screenPos).normalized()
		onMouseMovingPosChange()
		
func onAttackPosChange():
	
	pass
	
func onEndPosChange():
	pass

func onMouseMovingPosChange():
	pass
