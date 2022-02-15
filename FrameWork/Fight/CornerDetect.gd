extends RayCast2D

var _last_hang_climb_end:Vector2

func is_colliding_with_corner()->bool:
	if is_colliding(): 
		
		var collider = get_collider()
		if collider!=null:
			
			if collider is TileMap:
				return test_tilemap_corner(collider)
			
			return true
	
	return false
	pass
#
#func _physics_process(delta):
#	if not is_colliding():
#		print(is_colliding())

func test_tilemap_corner(collider)->bool :
	#检测攀爬的角度
	if collider and collider is TileMap:
		
		var g_pos = global_position
		var cell_pos = collider.world_to_map(collider.to_local(get_collision_point()))
#		cell_pos -= _collision.normal
		var tile_id = collider.get_cellv(cell_pos)
		#从左往右
		if scale.x >0 :
			var a =collider.get_cell(cell_pos.x -1,cell_pos.y)
			var b =collider.get_cell(cell_pos.x -1,cell_pos.y-1)
			var c =collider.get_cell(cell_pos.x ,cell_pos.y-1)
			
			if collider.get_cell(cell_pos.x -1,cell_pos.y) == TileMap.INVALID_CELL and collider.get_cell(cell_pos.x -1,cell_pos.y -1) == TileMap.INVALID_CELL and  collider.get_cell(cell_pos.x ,cell_pos.y -1) == TileMap.INVALID_CELL:
				
				var local_pos = collider.map_to_world(cell_pos)
				_last_hang_climb_end = collider.to_global(local_pos)
			
				return true
			else:
				return false
		#从右边往左
		if scale.x <0 :
			if collider.get_cell(cell_pos.x +1,cell_pos.y) == TileMap.INVALID_CELL and collider.get_cell(cell_pos.x +1,cell_pos.y -1) == TileMap.INVALID_CELL and  collider.get_cell(cell_pos.x ,cell_pos.y -1) == TileMap.INVALID_CELL:
				var local_pos = collider.map_to_world(cell_pos)
				_last_hang_climb_end = collider.to_global(local_pos)
			
				return true
			else:
				return false
		
	return false


func _on_FightKinematicMovableObj_Charactor_Face_Direction_Changed(direction):
	if direction.x>0:
		position.x =3
		scale.x = 1
	else:
		position.x=-3
		scale.x = -1
	pass # Replace with function body.

