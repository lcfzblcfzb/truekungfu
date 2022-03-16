extends Node

var none_overlaping_array=[]
#安全的范围
var safe_margin =10

var IS_MOVEAWAY ="is_moveaway"


func _process(delta):
	
	start_check()
	pass

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
				_next.set_position(_next.rect_position+ Vector2( 0 , -_cur.rect_size.y))
				_next.set_meta(IS_MOVEAWAY,true)
				pass
			else:
				
				var safe_margin_a = _cur.get_rect().grow(safe_margin)
				safe_margin_a.position = _cur.rect_global_position
				var safe_margin_b = _next.get_rect().grow(safe_margin)
				safe_margin_b.position = _next.rect_global_position
				
				if safe_margin_a.intersects(safe_margin_b):
					
					pass
				elif _next.has_meta(IS_MOVEAWAY) and _next.get_meta(IS_MOVEAWAY):
					#恢复到原位
					_next.set_position(_next.rect_position+ Vector2(0, _cur.rect_size.y))
					_next.set_meta(IS_MOVEAWAY,false)
					pass
				pass
				
				var h =_next.has_meta(IS_MOVEAWAY);
				var m =_next.get_meta(IS_MOVEAWAY)
				print(h,m)
				
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
