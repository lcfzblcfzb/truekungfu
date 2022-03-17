extends Node

var none_overlaping_array=[]
#安全的范围
var safe_margin =10

var IS_MOVEAWAY ="is_moveaway"
var INTER_NUM ="internum"

var _original_margin:Rect2;
	

func _process(delta):
	
	start_check()
	pass

#通过注册到管理器，实现血条不会重叠的效果
func regist_none_ovelap_UI(control):
	none_overlaping_array.append(control)


func start_check():
	
	for i in none_overlaping_array.size():
		
		var _cur = none_overlaping_array[i] as Control
		
		for j in (none_overlaping_array.size()-i-1):
			
			if  j<0 :
				break
				
			var _next = none_overlaping_array[i+j+1] as Control
			
			if _check_if_overlap(_cur,_next):
				#do over lap
				#DO PUSH AWAY
				_next.set_global_position(_next.get_global_rect().position+Vector2( 0 , -_cur.rect_size.y-3))
#				_next.set_position(_next.rect_position+ Vector2( 0 , -_cur.rect_size.y-3))
				_next.set_meta(IS_MOVEAWAY,true)
				
				if _next.has_meta(INTER_NUM) :
					var list =_next.get_meta(INTER_NUM) as Array
					if !list.has(_cur):
						list.append(_cur)
				else:
					var arr =[]
					arr.append(_cur)
					_next.set_meta(INTER_NUM,arr)
				
			else:
				var rect_a =_cur.get_global_rect()
				var rect_b =_next.get_global_rect()
				var safe_margin_a = rect_a.grow(safe_margin)
				
				safe_margin_a.position = _cur.rect_global_position
				var safe_margin_b = rect_b.grow(safe_margin)
				safe_margin_b.position = _next.rect_global_position
				
				if safe_margin_a.intersects(safe_margin_b):
					
					
					pass
				elif _next.has_meta(IS_MOVEAWAY) and _next.get_meta(IS_MOVEAWAY):
					
					if _next.has_meta(INTER_NUM) :
						var list = _next.get_meta(INTER_NUM) as Array
						var idx = list.find(_cur)
						if idx>=0:
							list.remove(idx)
						
						if list.size()<=0 :
							#恢复到原位
		#					_next.set_position(_next.rect_position+ Vector2( 0 , _cur.rect_size.y+3))
							var margins =_next.get_meta("margin")
							_next.set_margin(MARGIN_TOP,margins[1])
							_next.set_margin(MARGIN_BOTTOM,margins[0])
							_next.set_margin(MARGIN_LEFT,margins[2])
							_next.set_margin(MARGIN_RIGHT,margins[3])
							_next.set_meta(IS_MOVEAWAY,false)
					pass
				pass
				
			pass
		
		
		pass
	
	

func _check_if_overlap(controlA:Control, controlB:Control):
	
	var b_rect = controlB.get_rect()
	b_rect.position = controlB.rect_global_position
	var a_rect =controlA.get_rect()
	a_rect.position = controlA.rect_global_position
	
	if b_rect.intersects(a_rect):
		return true
	
	return false
	
#if controlA.rect_global_position.x>= controlB.rect_global_position.x:
#		#A在B右边
#
#
#		pass
#	else:
#		#A在B左边
#		pass
#
#	pass
